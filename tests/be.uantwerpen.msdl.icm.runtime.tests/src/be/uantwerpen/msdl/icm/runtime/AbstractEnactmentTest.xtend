package be.uantwerpen.msdl.icm.runtime

import com.google.common.base.Stopwatch
import java.io.File
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.junit.After
import org.junit.Before

abstract class AbstractEnactmentTest {
	protected EnactmentManager enactmentManager
	protected Logger logger = Logger.getLogger("Enactment Runner")
	protected Stopwatch stopwatch
	private String testFileLocation

	new(String testFileLocation) {
		this.testFileLocation = testFileLocation
	}

	@Before
	def void setup() {
		enactmentManager = new EnactmentManager(new File(testFileLocation), null)
	}

	@After
	def void tearDown() {
		enactmentManager = null
	}

	protected def resetAndRestart(Stopwatch stopwatch) {
		stopwatch.reset.start
	}

	protected def timeElapsed() {
		stopwatch.elapsed(TimeUnit.MILLISECONDS)
	}
}
