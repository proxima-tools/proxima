package be.uantwerpen.msdl.icm.scripting

import org.junit.After
import org.junit.Before
import org.junit.Test

class FileBasedTests {

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
		scriptManager.execute("test1.py")
	}
	
}
