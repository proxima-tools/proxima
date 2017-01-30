package be.uantwerpen.msdl.process.dse.simulator

import be.uantwerpen.msdl.processmodel.ProcessModel
import be.uantwerpen.msdl.processmodel.ProcessmodelPackage
import com.google.common.base.Stopwatch
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import org.eclipse.viatra.query.runtime.emf.EMFScope
import org.junit.After
import org.junit.Before
import org.junit.Test

class SimulateCosts {
	private static final val LEVEL = Level::DEBUG
	private ProcessModel modelRoot
	private ViatraQueryEngine queryEngine
	private ResourceSet resourceSet
	private Resource resource
	private Logger logger
	private Stopwatch stopwatch
	private static final val TEST_FILE_LOCATION = "file:///D:/GitHub/msdl/agv/be.uantwerpen.msdl.icm.cases.agv2/agv.processmodel"
	
	@Before
	def void setup() {
		logger = Logger.getLogger("Process DSE")
		logger.setLevel(LEVEL)

		// init
		ProcessmodelPackage.eINSTANCE.eClass()

		val extensionToFactoryMap = Resource.Factory.Registry.INSTANCE.extensionToFactoryMap
		extensionToFactoryMap.put("processmodel", new XMIResourceFactoryImpl())
		resourceSet = new ResourceSetImpl()
		resource = resourceSet.getResource(URI.createURI(TEST_FILE_LOCATION), true)
		
		queryEngine = ViatraQueryEngine.on(new EMFScope(resource));
		modelRoot = resource.contents.head as ProcessModel
	}

	@After
	def void tearDown() {
		resource = null
		resourceSet = null
		stopwatch = null
	}
	
	@Test
	def void simulate(){
		var cost = 0.0
		
		val simulator = new FixedIterationCostSimulator(modelRoot, queryEngine)
		if (simulator.canSimulate()) {
			cost = simulator.simulate()
		} else {
			cost = Double.POSITIVE_INFINITY
		}
		println(cost)
	}
}