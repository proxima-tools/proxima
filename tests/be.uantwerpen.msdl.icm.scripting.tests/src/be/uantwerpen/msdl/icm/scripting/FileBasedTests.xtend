package be.uantwerpen.msdl.icm.scripting

import org.junit.After
import org.junit.Before
import org.junit.Test
import be.uantwerpen.msdl.icm.scripting.python.RuntimeScriptExecutor
import be.uantwerpen.msdl.icm.scripting.scripts.PythonScript

class FileBasedTests {

//	private static final String TEST_FILE = "test1.py"
	private static final String TEST_FILE = "d:\\tools\\LMS\\LMS Imagine.Lab Amesim\\v1400\\amesimtest.py"

	private RuntimeScriptExecutor scriptManager

	@Before
	def void setUp() {
		this.scriptManager = new RuntimeScriptExecutor
	}

	@After
	def void tearDown() {
		this.scriptManager = null
	}

	@Test
	def void executeStatic() {
		scriptManager.execute(new PythonScript(TEST_FILE))
	}

}
