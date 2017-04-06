package be.uantwerpen.msdl.icm.runtime

import be.uantwerpen.msdl.enactment.ActivityState
import be.uantwerpen.msdl.enactment.Enactment
import be.uantwerpen.msdl.enactment.EnactmentFactory
import be.uantwerpen.msdl.enactment.Token
import be.uantwerpen.msdl.icm.runtime.queries.util.AvailableActivityQuerySpecification
import be.uantwerpen.msdl.icm.runtime.queries.util.AvailableFinishQuerySpecification
import be.uantwerpen.msdl.icm.runtime.queries.util.FinishedProcessQuerySpecification
import be.uantwerpen.msdl.icm.runtime.queries.util.ReadyActivityQuerySpecification
import be.uantwerpen.msdl.icm.runtime.queries.util.RunnigActivityQuerySpecification
import be.uantwerpen.msdl.icm.runtime.transformations.SimulatorTransformations2
import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager
import be.uantwerpen.msdl.icm.scripting.manager.ScriptExecutionManager
import be.uantwerpen.msdl.icm.scripting.scripts.IScript
import be.uantwerpen.msdl.processmodel.ProcessModel
import be.uantwerpen.msdl.processmodel.base.NamedElement
import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.processmodel.pm.AutomatedActivity
import be.uantwerpen.msdl.processmodel.pm.Initial
import be.uantwerpen.msdl.processmodel.pm.Node
import be.uantwerpen.msdl.processmodel.pm.Object
import be.uantwerpen.msdl.processmodel.pm.Process
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

class EnactmentManager {

	private ProcessModel processModel
	private Process process

	// Enactment core
	private Enactment enactment

	// Scripting support
	private Map<Activity, IScript> activityScripts = Maps::newHashMap
	private ScriptExecutionManager scriptExecutionManager

	// Variable support
	private VariableManager variableManager

	private ViatraQueryEngine queryEngine
	private SimulatorTransformations2 simulatorTransformations2
	private Logger logger = Logger.getLogger("Enactment Manager")

	new(File processModelFile, List<Class<? extends IScript>> scripts) {
		val extensionToFactoryMap = Resource.Factory.Registry.INSTANCE.extensionToFactoryMap
		extensionToFactoryMap.put("processmodel", new XMIResourceFactoryImpl())
		val resourceSet = new ResourceSetImpl()
		val resource = resourceSet.getResource(URI.createURI(processModelFile.path), true)

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

		// Scripting
		if (!scripts.empty) {
			scriptExecutionManager = new ScriptExecutionManager

			for (activity : process.activities) {
				val script = scripts.findFirst [ s |
					s.simpleName.equalsIgnoreCase((activity as NamedElement).name)
				]
				if (script != null) {
					val runnable = script.newInstance() as IScript
					activityScripts.put(activity, runnable)
				}
			}
		}

		// Variables
		val propertyModel = processModel.propertyModel
		val relationships = propertyModel.relationship.toList
		
		variableManager = new VariableManager(relationships)
	}

	def private initialize() {
		logger.debug(String.format("Initializing enactment for processmodel %s", process.toString))

		val token = EnactmentFactory.eINSTANCE.createToken
		enactment.token.add(token)
		token.currentNode = process.node.findFirst[n|n instanceof Initial]
	}

	def getAvailableActivities() {
		val fireableControlFlows = queryEngine.getMatcher(AvailableActivityQuerySpecification.instance).allMatches
		val activities = Lists::newArrayList

		for (ctrlFlowMatch : fireableControlFlows) {
			val toNode = ctrlFlowMatch.controlFlow.to
			activities.add(toNode)
		}

		val fireableFinalControlFlows = queryEngine.getMatcher(AvailableFinishQuerySpecification.instance).allMatches
		for (ctrlFlowMatch : fireableFinalControlFlows) {
			val toNode = ctrlFlowMatch.controlFlow.to
			activities.add(toNode)
		}

		activities
	}

	def getReadyActivities() {
		val matches = queryEngine.getMatcher(ReadyActivityQuerySpecification.instance).allMatches

		val activities = Lists::newArrayList

		for (match : matches) {
			activities.add(match.node)
		}

		activities
	}

	def prepareActivity(String activityName) {
		val match = queryEngine.getMatcher(AvailableActivityQuerySpecification.instance).allMatches.findFirst [ match |
			(match.activity as NamedElement).name.equalsIgnoreCase(activityName)
		]
		if (match != null) {
			prepareActivity(match.activity, match.token)
		} else {
			logger.debug("No available activity with matching name.")
		}
	}

	def prepareActivity(Activity activity, Token token) {
		token.currentNode = activity
		token.state = ActivityState::READY
	}

	def runActivity(String activityName) {
		val match = queryEngine.getMatcher(ReadyActivityQuerySpecification.instance).allMatches.findFirst [ match |
			(match.node as NamedElement).name.equalsIgnoreCase(activityName)
		]

		if (match != null) {
			runActivity(match.node)
		} else {
			logger.debug("No prepared activity with the matching name.")
		}
	}

	def runActivity(Activity activity) {
		val token = enactment.token.findFirst[t|t.currentNode.equals(activity)]
		token.state = ActivityState::RUNNING

		getTool(activity)

		if (!(activity instanceof AutomatedActivity)) {
			return
		}

		val script = activityScripts.get(activity)
		if (script == null) {
			return
		}
		scriptExecutionManager.execute(script)
	}

	def finishActivity(String activityName) {
		val match = queryEngine.getMatcher(RunnigActivityQuerySpecification.instance).allMatches.findFirst [ match |
			(match.node as NamedElement).name.equalsIgnoreCase(activityName)
		]

		if (match != null) {
			finishActivity(match.node)
		} else {
			logger.debug("No running activity with the matching name.")
		}
	}

	def finishActivity(Activity activity) {
		val token = enactment.token.findFirst[t|t.currentNode.equals(activity)]
		token.state = ActivityState::DONE
	}

	def stepActivity() {
		val matchAvailable = queryEngine.getMatcher(AvailableActivityQuerySpecification.instance).allMatches.head
		val matchReady = queryEngine.getMatcher(ReadyActivityQuerySpecification.instance).allMatches.head

		if (matchAvailable != null) {
			val match = matchAvailable
			prepareActivity(match.activity, match.token)
			runActivity(match.activity)
			finishActivity(match.activity)
		} else if (matchReady != null) {
			val match = matchReady
			runActivity(match.node)
			finishActivity(match.node)
		} else {
			logger.debug("No available activity with matching name.")
		}
	}

	def stepActivity(String activityName) {
		val matchAvailable = queryEngine.getMatcher(AvailableActivityQuerySpecification.instance).allMatches.findFirst [ match |
			(match.activity as NamedElement).name.equalsIgnoreCase(activityName)
		]
		val matchReady = queryEngine.getMatcher(ReadyActivityQuerySpecification.instance).allMatches.findFirst [ match |
			(match.node as NamedElement).name.equalsIgnoreCase(activityName)
		]

		if (matchAvailable != null) {
			val match = matchAvailable
			prepareActivity(match.activity, match.token)
			runActivity(match.activity)
			finishActivity(match.activity)
		} else if (matchReady != null) {
			val match = matchReady
			runActivity(match.node)
			finishActivity(match.node)
		} else {
			logger.debug("No available activity with matching name.")
		}
	}

	def finalStep() {
		val fireableFinalControlFlows = queryEngine.getMatcher(AvailableFinishQuerySpecification.instance).allMatches

		if (fireableFinalControlFlows.empty) {
			logger.debug("The process cannot be finished at this point.")
			return
		}

		fireableFinalControlFlows.head.token.currentNode = fireableFinalControlFlows.head.final
	}

	def boolean processFinished() {
		queryEngine.getMatcher(FinishedProcessQuerySpecification.instance).countMatches > 0
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

		inputObjects.forEach [ o |
			logger.debug(String.format("Tool %s needed for executing Activity %s.", o.typedBy.name, activity.name))
		]
	// TODO add calls to a connection manager
	}

}
