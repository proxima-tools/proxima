package be.uantwerpen.msdl.icm.scripting

import org.junit.After
import org.junit.Before
import org.junit.Test

class JythonTests {

//	private static final String TEST_FILE = "test1.py"
	private static final String TEST_FILE = "d:\\tools\\LMS\\LMS Imagine.Lab Amesim\\v1400\\amesimtest.py"

	private JythonScriptManager scriptManager

	@Before
	def void setUp() {
		this.scriptManager = new JythonScriptManager
	}

	@After
	def void tearDown() {
		this.scriptManager = null
	}

	@Test
	def void executeStatic() {
		scriptManager.execute(TEST_FILE)
	}

}
