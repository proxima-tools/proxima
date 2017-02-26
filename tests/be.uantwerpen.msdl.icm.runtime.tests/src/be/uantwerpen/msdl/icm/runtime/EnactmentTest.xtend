package be.uantwerpen.msdl.icm.runtime

import be.uantwerpen.msdl.enactment.Enactment
import be.uantwerpen.msdl.enactment.EnactmentFactory
import be.uantwerpen.msdl.processmodel.ProcessModel
import be.uantwerpen.msdl.processmodel.ProcessmodelPackage
import com.google.common.base.Stopwatch
import java.util.concurrent.TimeUnit
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.junit.After
import org.junit.Before
import org.junit.Test

class EnactmentTest {
	private ProcessModel processModel
	private Enactment enactment
	private EnactmentManager enactmentManager
	private Resource resource
	private ResourceSet resourceSet
	private Logger logger = Logger.getLogger(
		"Enactment Runner")
	private Stopwatch stopwatch

	private static final val TEST_FILE_LOCATION = "..\\be.uantwerpen.msdl.icm.test.data\\processes\\process1.processmodel"

	@Before
	def void setup() {
		ProcessmodelPackage.eINSTANCE.eClass()

		val extensionToFactoryMap = Resource.Factory.Registry.INSTANCE.extensionToFactoryMap
		extensionToFactoryMap.put("processmodel", new XMIResourceFactoryImpl())
		resourceSet = new ResourceSetImpl()
		resource = resourceSet.getResource(URI.createURI(TEST_FILE_LOCATION), true)

		this.processModel = resource.contents.head as ProcessModel
		enactment = EnactmentFactory.eINSTANCE.createEnactment
		enactment.enactedProcessModel = processModel
		enactmentManager = new EnactmentManager(processModel.process.head, enactment)
	}

	@After
	def void tearDown() {
		resource = null
		resourceSet = null
		enactment = null
		enactmentManager = null
	}

	@Test
	def void execute() {
		logger.level = Level::DEBUG
		logger.debug("setting up engine")
		stopwatch = Stopwatch.createStarted()

		println(processModel.process.head.node.size)
		processModel.name = "test"

		// compile
		enactmentManager.initialize

		// execute
		logger.debug("Ready")
		new CommandInterpreter(enactmentManager).interpret

		// finish
		stopwatch.resetAndRestart
		logger.debug("Process finished.")
	}

	protected def resetAndRestart(Stopwatch stopwatch) {
		stopwatch.reset.start
	}

	protected def timeElapsed() {
		stopwatch.elapsed(TimeUnit.MILLISECONDS)
	}
}
