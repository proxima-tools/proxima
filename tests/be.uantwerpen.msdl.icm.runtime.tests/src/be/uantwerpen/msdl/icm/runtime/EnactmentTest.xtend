package be.uantwerpen.msdl.icm.runtime

import be.uantwerpen.msdl.enactment.Enactment
import be.uantwerpen.msdl.enactment.EnactmentFactory
import be.uantwerpen.msdl.processmodel.ProcessModel
import be.uantwerpen.msdl.processmodel.ProcessmodelPackage
import be.uantwerpen.msdl.processmodel.base.NamedElement
import be.uantwerpen.msdl.processmodel.pm.Final
import com.google.common.base.Stopwatch
import java.io.BufferedReader
import java.io.InputStreamReader
import java.util.concurrent.TimeUnit
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.eclipse.xtend.lib.annotations.Accessors
import org.junit.After
import org.junit.Before
import org.junit.Test

class EnactmentTest {
	@Accessors(PROTECTED_GETTER, PROTECTED_SETTER) ProcessModel processModel
	@Accessors(PROTECTED_GETTER, PROTECTED_SETTER) Enactment enactment
	@Accessors(PROTECTED_GETTER, PROTECTED_SETTER) EnactmentManager enactmentManager
	@Accessors(PROTECTED_GETTER, PROTECTED_SETTER) Resource resource
	@Accessors(PROTECTED_GETTER) Logger logger = Logger.getLogger(
		"Enactment Runner")
	@Accessors(PROTECTED_GETTER) Stopwatch stopwatch
	private ResourceSet resourceSet

	public static final String PREP_COMMAND = "prepare"
	public static final String RUN_COMMAND = "run"
	public static final String FINISH_COMMAND = "finish"
	public static final String STEP_COMMAND = "step"
	public static final String FINAL_COMMAND = "final"
	public static final String EXIT_COMMAND = "exit"

//	private static final val TEST_FILE_LOCATION = "file:///D:/GitHub/msdl/agv/be.uantwerpen.msdl.icm.cases.agv2/agv.processmodel"
	private static final val TEST_FILE_LOCATION = "..\\be.uantwerpen.msdl.icm.test.data\\processes\\test.processmodel"

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
		val br = new BufferedReader(new InputStreamReader(System.in))
		logger.debug("Ready")

		do {
			logger.debug("Available activities: " + enactmentManager.availableActivities.fold("") [ result, activity |
				switch activity {
					NamedElement: result.concat("\n\t").concat((activity as NamedElement).name)
					Final: result.concat("\n\t Final")
				}
			])

			logger.debug("Ready activities: " + enactmentManager.readyActivities.fold("") [ result, activity |
				result.concat("\n\t").concat((activity as NamedElement).name)
			])

			print("> ")
			val input = br.readLine()

			switch input {
				case input.toLowerCase.startsWith(PREP_COMMAND): {
					val activity = input.split(" ", 2).toList.get(1)
					logger.debug(String.format("Preparing activity %s.", activity))
					enactmentManager.prepareActivity(activity)
				}
				case input.toLowerCase.startsWith(RUN_COMMAND): {
					val activity = input.split(" ", 2).toList.get(1)
					logger.debug(String.format("Executing activity %s.", activity))
					enactmentManager.runActivity(activity)
				}
				case input.toLowerCase.startsWith(FINISH_COMMAND): {
					val activity = input.split(" ", 2).toList.get(1)
					logger.debug(String.format("Finishing activity %s.", activity))
					enactmentManager.finishActivity(activity)
				}
				case input.toLowerCase.equals(STEP_COMMAND): {
					logger.debug(String.format("Preparing, executing and finishing randomly."))
					enactmentManager.stepActivity()
				}
				case input.toLowerCase.startsWith(STEP_COMMAND): {
					val activity = input.split(" ", 2).toList.get(1)
					logger.debug(String.format("Preparing, executing and finishing activity %s.", activity))
					enactmentManager.stepActivity(activity)
				}
				case input.toLowerCase.equals(FINAL_COMMAND): {
					logger.debug(String.format("Preparing, executing and finishing process."))
					enactmentManager.finalStep
				}
				case input.toLowerCase.equals(EXIT_COMMAND): {
					logger.debug("Exiting.")
					stopwatch.resetAndRestart
					return
				}
				default: {
					logger.debug("Unknown command.");
				}
			}
			enactmentManager.maintain
		} while (true && !enactmentManager.processFinished);

		logger.debug("Process finished.")
	}

	protected def resetAndRestart(Stopwatch stopwatch) {
		stopwatch.reset.start
	}

	protected def timeElapsed() {
		stopwatch.elapsed(TimeUnit.MILLISECONDS)
	}
}
