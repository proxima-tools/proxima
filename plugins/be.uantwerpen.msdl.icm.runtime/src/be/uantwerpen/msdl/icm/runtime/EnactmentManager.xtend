/*******************************************************************************
 * Copyright (c) 2016-2017 Istvan David
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *    Istvan David - initial API and implementation
 *******************************************************************************/

package be.uantwerpen.msdl.icm.runtime

import be.uantwerpen.msdl.enactment.ActivityState
import be.uantwerpen.msdl.enactment.Enactment
import be.uantwerpen.msdl.enactment.EnactmentFactory
import be.uantwerpen.msdl.enactment.Token
import be.uantwerpen.msdl.icm.runtime.queries.AttributeModificationActivity
import be.uantwerpen.msdl.icm.runtime.queries.AvailableActivity
import be.uantwerpen.msdl.icm.runtime.queries.AvailableFinish
import be.uantwerpen.msdl.icm.runtime.queries.FinishedProcess
import be.uantwerpen.msdl.icm.runtime.queries.ReadyActivity
import be.uantwerpen.msdl.icm.runtime.queries.RunnigActivity
import be.uantwerpen.msdl.icm.runtime.querying.AmesimQuery
import be.uantwerpen.msdl.icm.runtime.querying.MatlabQuery
import be.uantwerpen.msdl.icm.runtime.querying.toolselection.ToolSelectionHelper
import be.uantwerpen.msdl.icm.runtime.scripting.connection.MatlabConnectionManager
import be.uantwerpen.msdl.icm.runtime.scripting.manager.ScriptExecutionManager
import be.uantwerpen.msdl.icm.runtime.scripting.scripts.IScript
import be.uantwerpen.msdl.icm.runtime.transformations.SimulatorTransformations2
import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager
import be.uantwerpen.msdl.processmodel.ProcessModel
import be.uantwerpen.msdl.processmodel.base.NamedElement
import be.uantwerpen.msdl.processmodel.ftg.Formalism
import be.uantwerpen.msdl.processmodel.ftg.JavaBasedActivityDefinition
import be.uantwerpen.msdl.processmodel.ftg.MatlabScript
import be.uantwerpen.msdl.processmodel.ftg.PythonScript
import be.uantwerpen.msdl.processmodel.ftg.Script
import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.processmodel.pm.AutomatedActivity
import be.uantwerpen.msdl.processmodel.pm.Initial
import be.uantwerpen.msdl.processmodel.pm.ManualActivity
import be.uantwerpen.msdl.processmodel.pm.Node
import be.uantwerpen.msdl.processmodel.pm.Object
import be.uantwerpen.msdl.processmodel.pm.Process
import be.uantwerpen.msdl.processmodel.properties.AmesimAttributeDefinition
import be.uantwerpen.msdl.processmodel.properties.Attribute
import be.uantwerpen.msdl.processmodel.properties.GraphQueryAttributeDefinition
import be.uantwerpen.msdl.processmodel.properties.InMemoryAttributeDefinition
import be.uantwerpen.msdl.processmodel.properties.MatlabAttributeDefinition
import com.google.common.collect.Lists
import com.google.common.collect.Maps
import java.io.File
import java.util.List
import java.util.Map
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import org.eclipse.viatra.query.runtime.emf.EMFScope
import org.eclipse.xtend.lib.annotations.Accessors

class EnactmentManager {

	private ProcessModel processModel
	private Process process

	// Enactment core
	private Enactment enactment

	// Scripting support
	private Map<Activity, IScript> activityScripts = Maps::newHashMap
	private ScriptExecutionManager scriptExecutionManager

	// MATLAB support
	// FIXME this command boots up Matlab even though it's not necessarily required. A proxy pattern would
	// solve this temporarily, but maybe a full re-structure would be the best.
	var MatlabProxy matlabProxy = null // new MatlabProxyFactory().proxy //null
	// Variable support
	@Accessors(PUBLIC_GETTER) VariableManager variableManager

	private ViatraQueryEngine queryEngine
	private SimulatorTransformations2 simulatorTransformations2
	private Logger logger = Logger.getLogger("Enactment Manager")

	new(File processModelFile, List<Class<? extends IScript>> scripts) {
		val extensionToFactoryMap = Resource.Factory.Registry.INSTANCE.extensionToFactoryMap
		extensionToFactoryMap.put("processmodel", new XMIResourceFactoryImpl())
		val resourceSet = new ResourceSetImpl()
		val resource = if (processModelFile.path.toLowerCase.startsWith('c') ||
				processModelFile.path.toLowerCase.startsWith('d')) {
				resourceSet.getResource(URI.createFileURI(processModelFile.path), true)
			} else {
				resourceSet.getResource(URI.createURI(processModelFile.path), true)
			}

		setUpProcessModel(resource.contents.head as ProcessModel, scripts)
	}

	new(ProcessModel processModel, List<Class<? extends IScript>> scripts) {
		setUpProcessModel(processModel, scripts)
	}

	def private setUpProcessModel(ProcessModel processModel, List<Class<? extends IScript>> scripts) {
		this.processModel = processModel
		this.process = processModel.process.head

		this.enactment = EnactmentFactory.eINSTANCE.createEnactment
		this.enactment.enactedProcessModel = processModel

		this.queryEngine = ViatraQueryEngine.on(new EMFScope(enactment));
		this.simulatorTransformations2 = new SimulatorTransformations2(queryEngine, enactment)
		simulatorTransformations2.registerRulesWithCustomPriorities
		logger.level = Level::DEBUG

		initialize

		// Variables
		val propertyModel = processModel.propertyModel
		variableManager = VariableManager.instance
		variableManager.setup(propertyModel)

		// Scripting
//		if (!scripts.empty) {
		scriptExecutionManager = new ScriptExecutionManager(matlabProxy)

		for (activity : process.activities) {
			val script = scripts.findFirst [ s |
				s.simpleName.equalsIgnoreCase((activity as NamedElement).name)
			]
			if (script !== null) {
				val runnable = script.newInstance as IScript
				activityScripts.put(activity, runnable)
			}
		}
//		}
	}

	def private initialize() {
		logger.debug(String.format("Initializing enactment for processmodel %s", process.toString))

		val token = EnactmentFactory.eINSTANCE.createToken
		enactment.token.add(token)
		token.currentNode = process.node.findFirst[n|n instanceof Initial]
	}

	def getAvailableActivities() {
		val fireableControlFlows = queryEngine.getMatcher(AvailableActivity.instance).allMatches
		val activities = Lists::newArrayList

		for (ctrlFlowMatch : fireableControlFlows) {
			val toNode = ctrlFlowMatch.controlFlow.to
			activities.add(toNode)
		}

		val fireableFinalControlFlows = queryEngine.getMatcher(AvailableFinish.instance).allMatches
		for (ctrlFlowMatch : fireableFinalControlFlows) {
			val toNode = ctrlFlowMatch.controlFlow.to
			activities.add(toNode)
		}

		activities
	}

	def getReadyActivities() {
		val matches = queryEngine.getMatcher(ReadyActivity.instance).allMatches

		val activities = Lists::newArrayList

		for (match : matches) {
			activities.add(match.node)
		}

		activities
	}

	def prepareActivity(String activityName) {
		val match = queryEngine.getMatcher(AvailableActivity.instance).allMatches.findFirst [ match |
			(match.activity as NamedElement).name.equalsIgnoreCase(activityName)
		]
		if (match !== null) {
			prepareActivity(match.activity, match.token)
		} else {
			logger.debug("No available activity with matching name.")
		}
	}

	def prepareActivity(Activity activity, Token token) {
		token.state = ActivityState::READY
		logger.debug(String::format("State of token %s:", token, token.state))

		token.currentNode = activity

		// TODO boot up tools
		val objectsIn = activity.dataFlowFrom.filter[node|node instanceof Object].map[node|(node as Object)]
		val objectsOut = activity.dataFlowTo.filter[node|node instanceof Object].map[node|(node as Object)]
	}

	def runActivity(String activityName) {
		val match = queryEngine.getMatcher(ReadyActivity.instance).allMatches.findFirst [ match |
			(match.node as NamedElement).name.equalsIgnoreCase(activityName)
		]

		if (match !== null) {
			runActivity(match.node)
		} else {
			logger.debug("No prepared activity with the matching name.")
		}
	}

	def runActivity(Activity activity) {
		val token = enactment.token.findFirst[t|t.currentNode.equals(activity)]
		token.state = ActivityState::RUNNING

//		if (!(activity instanceof AutomatedActivity)) {
//			return
//		}
		if (activity.typedBy === null) {
			return
		}

		// Parameters
		val parameters = activity.executionParameters

		if (activity instanceof AutomatedActivity) {
			if (activity.typedBy.definition instanceof JavaBasedActivityDefinition) {
				// execute by name
				val script = activityScripts.get(activity)
				if (script !== null) {
					scriptExecutionManager.execute(script, parameters)
				}
			} else if (activity.typedBy.definition instanceof Script) {
				// Execution by script file
				val location = (activity.typedBy.definition as Script).location
				if (location !== null) {
					logger.debug(String.format("Script file %s located. Executing script.", location))
					switch (activity.typedBy.definition) {
						PythonScript:
							scriptExecutionManager.execute(
								new be.uantwerpen.msdl.icm.runtime.scripting.scripts.PythonScript(location), parameters)
						MatlabScript:
							scriptExecutionManager.execute(
								new be.uantwerpen.msdl.icm.runtime.scripting.scripts.MatlabScript(location), parameters)
						default:
							throw new IllegalArgumentException()
					}
				}
			}
		} else if (activity instanceof ManualActivity) {
			getTool(activity)
		} else {
			throw new IllegalArgumentException
		}
	}

	def finishActivity(String activityName) {
		val match = queryEngine.getMatcher(RunnigActivity.instance).allMatches.findFirst [ match |
			(match.node as NamedElement).name.equalsIgnoreCase(activityName)
		]

		if (match !== null) {
			finishActivity(match.node)
		} else {
			logger.debug("No running activity with the matching name.")
		}
	}

	def finishActivity(Activity activity) {
		val token = enactment.token.findFirst[t|t.currentNode.equals(activity)]
		token.state = ActivityState::DONE

		val modifiedAttributes = queryEngine.getMatcher(AttributeModificationActivity.instance).
			getAllValuesOfattribute(activity)
		if (!modifiedAttributes.empty) {
			logger.debug("Checking for consistency")
			// TODO check consistency
			// get the variable from the model and load into the variable manager
			var values = Maps::newHashMap();

			for (attribute : modifiedAttributes) {
				val value = attribute.getValue2(activity)
				values.put(attribute.name, value)
			}
			VariableManager.getInstance().setVariables(values)
		}
	}
	
	@Deprecated
	def getValue(Attribute attribute, Activity activity) {
		switch (attribute.attributedefinition) {
			MatlabAttributeDefinition: {
				new MatlabQuery(attribute, activity).execute as Double
			}
			AmesimAttributeDefinition: {
				new AmesimQuery(attribute, activity).execute as Double
			}
			GraphQueryAttributeDefinition: {
				0.0
			}
			InMemoryAttributeDefinition: {
				0.0
			}
		}
	}

	private static extension val ToolSelectionHelper toolSelectionHelper = new ToolSelectionHelper

	private def getValue2(Attribute attribute, Activity activity) {
		val tool = attribute.selectTool(activity)
		switch (tool.name.toLowerCase) {
			case "matlab": {
				new MatlabQuery(attribute, activity).execute as Double
			}
			case "amesim": {
				new AmesimQuery(attribute, activity).execute as Double
			}
			default: {
				0.0
			}
		}
	}

	def stepActivity() {
		val matchAvailable = queryEngine.getMatcher(AvailableActivity.instance).allMatches.head
		val matchReady = queryEngine.getMatcher(ReadyActivity.instance).allMatches.head

		if (matchAvailable !== null) {
			val match = matchAvailable
			prepareActivity(match.activity, match.token)
			runActivity(match.activity)
			finishActivity(match.activity)
		} else if (matchReady !== null) {
			val match = matchReady
			runActivity(match.node)
			finishActivity(match.node)
		} else {
			logger.debug("No available activity with matching name.")
		}
	}

	def stepActivity(String activityName) {
		val matchAvailable = queryEngine.getMatcher(AvailableActivity.instance).allMatches.findFirst [ match |
			(match.activity as NamedElement).name.equalsIgnoreCase(activityName)
		]
		val matchReady = queryEngine.getMatcher(ReadyActivity.instance).allMatches.findFirst [ match |
			(match.node as NamedElement).name.equalsIgnoreCase(activityName)
		]

		if (matchAvailable !== null) {
			val match = matchAvailable
			prepareActivity(match.activity, match.token)
			runActivity(match.activity)
			finishActivity(match.activity)
		} else if (matchReady !== null) {
			val match = matchReady
			runActivity(match.node)
			finishActivity(match.node)
		} else {
			logger.debug("No available activity with matching name.")
		}
	}

	def finalStep() {
		val fireableFinalControlFlows = queryEngine.getMatcher(AvailableFinish.instance).allMatches

		if (fireableFinalControlFlows.empty) {
			logger.debug("The process cannot be finished at this point.")
			return
		}

		cleanUp()

		fireableFinalControlFlows.head.token.currentNode = fireableFinalControlFlows.head.final
	}

	def boolean processFinished() {
		queryEngine.getMatcher(FinishedProcess.instance).countMatches > 0
	}

	// Use this method if maintenance is done in a batch-fashion
	// def maintain() {
	// simulatorTransformations.maintain
	// }
	def getActivities(Process process) {
		process.node.filter[n|n instanceof Activity].map[n|n as Activity]
	}

	def isDoneActivity(Node node) {
		if (!(node instanceof Activity)) {
			return false
		}
		val token = enactment.token.findFirst[t|t.currentNode.equals(node)]
		token.state.equals(ActivityState::DONE)
	}

	def getTool(Activity activity) {
		// find by artifact
		val inputObjects = activity.dataFlowFrom.filter[dFrom|dFrom instanceof Object].map[o|o as Object]

//		inputObjects.forEach [ o |
//			val tools = (o.typedBy as Formalism).implementedBy
//			logger.debug(String.format("Tool %s needed for executing Activity %s.", tools.head.name, activity.name))
//		]
		val inputObject = inputObjects.head
		val tool = (inputObject.typedBy as Formalism).implementedBy.head
		logger.debug(String.format("Tool %s needed for executing Activity %s.", tool.name, activity.name))

		/**
		 * XXX
		 */
		MatlabConnectionManager::matlabEngine
	}

	def runAtOnce() {
		while (availableActivities.size > 0) {
			if (availableActivities.head instanceof Activity) {
				(availableActivities.head as Activity).name.stepActivity
			} else {
				finalStep
			}
		}
	}

	def exit() {
		cleanUp()
	}

	private def cleanUp() {
		matlabProxy.exit
	}

}
