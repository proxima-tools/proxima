package be.uantwerpen.msdl.process.dse

import be.uantwerpen.msdl.metamodels.process.ProcessModel
import be.uantwerpen.msdl.metamodels.process.ProcessPackage
import be.uantwerpen.msdl.process.dse.objectives.hard.ValidityHardObjectives
import be.uantwerpen.msdl.process.dse.objectives.soft.SoftObjectives
import be.uantwerpen.msdl.process.dse.rules.RulesFactory
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
import org.eclipse.viatra.dse.api.strategy.impl.DepthFirstStrategy
import org.eclipse.viatra.dse.solutionstore.SolutionStore
import org.eclipse.viatra.dse.statecoding.simple.SimpleStateCoderFactory
import org.eclipse.viatra.query.runtime.base.exception.ViatraBaseException
import org.eclipse.viatra.query.runtime.exception.ViatraQueryException
import org.junit.After
import org.junit.Before
import org.junit.Test

class DSERunner {
	private static final val LEVEL = Level::
		DEBUG
	private static final val TEST_FILE_LOCATION = "file:///D:/GitHub/msdl/robot/be.uantwerpen.msdl.icm.robot/robot2.process"

	private ResourceSet resourceSet
	private Resource resource
	private Logger logger
	private Stopwatch stopwatch

	@Before
	def void setup() {
		logger = Logger.getLogger("Process DSE")
		logger.setLevel(LEVEL)

		// init
		ProcessPackage.eINSTANCE.eClass()

		val extensionToFactoryMap = Resource.Factory.Registry.INSTANCE.extensionToFactoryMap
		extensionToFactoryMap.put("process", new XMIResourceFactoryImpl())
		resourceSet = new ResourceSetImpl()
		resource = resourceSet.getResource(URI.createURI(TEST_FILE_LOCATION), true)
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
		dse.addMetaModelPackage(ProcessPackage.eINSTANCE)
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
