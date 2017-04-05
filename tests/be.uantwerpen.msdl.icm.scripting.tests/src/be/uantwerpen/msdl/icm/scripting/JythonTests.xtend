package be.uantwerpen.msdl.icm.scripting

import org.junit.After
import org.junit.Before
import org.junit.Test
import be.uantwerpen.msdl.icm.scripting.python.JythonScriptExecutor
import be.uantwerpen.msdl.icm.scripting.scripts.PythonScript

class JythonTests {

//	private static final String TEST_FILE = "test1.py"
	private static final String TEST_FILE = "d:\\tools\\LMS\\LMS Imagine.Lab Amesim\\v1400\\amesimtest.py"

	private JythonScriptExecutor scriptManager

	@Before
	def void setUp() {
		this.scriptManager = new JythonScriptExecutor
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
