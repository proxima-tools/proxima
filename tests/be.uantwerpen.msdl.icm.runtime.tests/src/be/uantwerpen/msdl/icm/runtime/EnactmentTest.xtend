package be.uantwerpen.msdl.icm.runtime

import com.google.common.base.Stopwatch
import org.apache.log4j.Level
import org.junit.Test

class EnactmentTest extends AbstractEnactmentTest {

	private static final val TEST_FILE_LOCATION = "..\\be.uantwerpen.msdl.icm.test.data\\processes\\process1.processmodel"

	new() {
		super(TEST_FILE_LOCATION)
	}

	@Test
	def void execute() {
		logger.level = Level::DEBUG
		logger.debug("setting up engine")
		stopwatch = Stopwatch.createStarted()

		// execute
		logger.debug("Ready")
		new CommandInterpreter(enactmentManager).interpret

		// finish
		stopwatch.resetAndRestart
		logger.debug("Process finished.")
	}
}
