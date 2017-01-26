/*******************************************************************************
 * Copyright (c) 2016 Istvan David
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *    Istvan David - initial API and implementation
 *******************************************************************************/

package be.uantwerpen.msdl.process.dse

import be.uantwerpen.msdl.process.dse.objectives.hard.ValidityHardObjectives
import be.uantwerpen.msdl.process.dse.objectives.soft.SoftObjectives
import be.uantwerpen.msdl.process.dse.rules.RulesFactory
import be.uantwerpen.msdl.processmodel.ProcessModel
import be.uantwerpen.msdl.processmodel.ProcessmodelPackage
import be.uantwerpen.msdl.processmodel.base.BasePackage
import be.uantwerpen.msdl.processmodel.cost.CostPackage
import be.uantwerpen.msdl.processmodel.ftg.FtgPackage
import be.uantwerpen.msdl.processmodel.pm.PmPackage
import be.uantwerpen.msdl.processmodel.properties.PropertiesPackage
import be.uantwerpen.msdl.processmodel.resources.ResourcesPackage
import com.google.common.base.Stopwatch
import java.io.IOException
import java.util.Collections
import java.util.concurrent.TimeUnit
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.viatra.dse.api.DesignSpaceExplorer
import org.eclipse.viatra.dse.api.Strategies
import org.eclipse.viatra.dse.solutionstore.SolutionStore
import org.eclipse.viatra.dse.statecoding.simple.SimpleStateCoderFactory
import org.eclipse.viatra.query.runtime.base.exception.ViatraBaseException
import org.eclipse.viatra.query.runtime.exception.ViatraQueryException
import org.junit.After
import org.junit.Before
import org.junit.Test

/**
 * This will be the actual implementation of the DSE logic
 */

class DSERunner2 {
	private static final val LEVEL = Level::DEBUG
	private static final val FILE_LOCATION = ""	//TODO: access model

	private ResourceSet resourceSet
	private Resource resource
	private Logger logger
	private Stopwatch stopwatch

	@Before
	def void setup() {
		logger = Logger.getLogger("Process DSE")
		logger.setLevel(LEVEL)

		// init
		ProcessmodelPackage.eINSTANCE.eClass()

		val extensionToFactoryMap = Resource.Factory.Registry.INSTANCE.extensionToFactoryMap
		extensionToFactoryMap.put("processmodel", new XMIResourceFactoryImpl())
		resourceSet = new ResourceSetImpl()
		resource = resourceSet.getResource(URI.createURI(FILE_LOCATION), true)
	}

	@After
	def void tearDown() {
		resource = null
		resourceSet = null
		stopwatch = null
	}

	@Test
	def void explore() throws ViatraQueryException, IOException, ViatraBaseException {
		// Load persisted model
		val processModel = resource.contents.head as ProcessModel

		logger.debug("setting up engine")
		stopwatch = Stopwatch.createStarted()

		// Set up DSE engine
		val dse = new DesignSpaceExplorer()
		dse.setInitialModel(processModel)
		dse.addMetaModelPackage(ProcessmodelPackage.eINSTANCE)
		dse.addMetaModelPackage(PmPackage.eINSTANCE)
		dse.addMetaModelPackage(FtgPackage.eINSTANCE)
		dse.addMetaModelPackage(PropertiesPackage.eINSTANCE)
		dse.addMetaModelPackage(ResourcesPackage.eINSTANCE)
		dse.addMetaModelPackage(CostPackage.eINSTANCE)
		dse.addMetaModelPackage(BasePackage.eINSTANCE)

		logger.debug(String.format("initial model set in %d ms", timeElapsed))
		stopwatch.resetAndRestart

		// Trafo rules
		RulesFactory.ruleGroups.forEach [ ruleGroup |
			ruleGroup.addTransformationRules(dse)
		]
		logger.debug(
			String.format("%d trafo rules added in %d ms", dse.globalContext.transformations.size, timeElapsed))
		stopwatch.resetAndRestart

		// Objectives
		new SoftObjectives().addConstraints(dse)
		new ValidityHardObjectives().addConstraints(dse)
		logger.debug(String.format("%d objectives added in %d ms", dse.globalContext.objectives.size, timeElapsed))
		stopwatch.resetAndRestart

		// State coding
		dse.addMetaModelPackage(ProcessmodelPackage.eINSTANCE)
		dse.setStateCoderFactory(new SimpleStateCoderFactory(dse.metaModelPackages))
		logger.debug(String.format("state coding done in %d ms", timeElapsed))
		stopwatch.resetAndRestart

		// Start
		logger.debug("starting")
		dse.solutionStore = new SolutionStore(1);
		dse.setMaxNumberOfThreads(1);
		dse.startExploration(Strategies::creatHillClimbingStrategy)
//		Logger.getLogger(typeof(DepthFirstStrategy)).setLevel(Level.DEBUG);
		// Finish
		logger.debug(String.format("exploration took %d ms", timeElapsed))
		stopwatch.stop()

		// Get results
		logger.debug("number of solutions: " + dse.solutions.size)

		if (dse.solutions.size() > 0) {
//			println(dse.toStringSolutions)
			logger.debug("persisting first solution")
			val solution = dse.solutions.head
			val trajectory = solution.arbitraryTrajectory
			trajectory.model = processModel
			trajectory.doTransformation

			logger.debug("Fitness values:")
			trajectory.fitness.entrySet.forEach [ fitessValue |
				logger.debug(String.format("\t %s = %.2f", fitessValue.key, fitessValue.value))
			]

			resource.save(Collections.EMPTY_MAP)
			logger.debug("solution persisted")
		}
		logger.debug("end")
	}

	private def resetAndRestart(Stopwatch stopwatch) {
		stopwatch.reset.start
	}

	private def timeElapsed() {
		stopwatch.elapsed(TimeUnit.MILLISECONDS)
	}

}