package be.uantwerpen.msdl.icm.runtime

import com.google.common.base.Stopwatch
import org.apache.log4j.Level
import org.junit.Test

class AttributeTest extends AbstractEnactmentTest {
	private static final val TEST_FILE_LOCATION = "..\\be.uantwerpen.msdl.icm.test.data\\processes\\attributetest.processmodel"

	new() {
		super(TEST_FILE_LOCATION)
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
}