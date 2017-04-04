package be.uantwerpen.msdl.icm.runtime

import be.uantwerpen.msdl.enactment.Enactment
import be.uantwerpen.msdl.enactment.EnactmentFactory
import be.uantwerpen.msdl.processmodel.ProcessModel
import be.uantwerpen.msdl.processmodel.ProcessmodelPackage
import com.google.common.base.Stopwatch
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.junit.After
import org.junit.Before

abstract class AbstractEnactmentTest {
	protected ProcessModel processModel
	private Enactment enactment
	protected EnactmentManager enactmentManager
	private Resource resource
	private ResourceSet resourceSet
	protected Logger logger = Logger.getLogger("Enactment Runner")
	protected Stopwatch stopwatch
	private String testFileLocation
	
	new(String testFileLocation) {
		this.testFileLocation = testFileLocation
	}

	@Before
	def void setup() {
		ProcessmodelPackage.eINSTANCE.eClass()

		val extensionToFactoryMap = Resource.Factory.Registry.INSTANCE.extensionToFactoryMap
		extensionToFactoryMap.put("processmodel", new XMIResourceFactoryImpl())
		resourceSet = new ResourceSetImpl()
		resource = resourceSet.getResource(URI.createURI(testFileLocation), true)

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

	protected def resetAndRestart(Stopwatch stopwatch) {
		stopwatch.reset.start
	}

	protected def timeElapsed() {
		stopwatch.elapsed(TimeUnit.MILLISECONDS)
	}
}