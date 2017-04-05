package be.uantwerpen.msdl.icm.scripting.python

import be.uantwerpen.msdl.icm.scripting.scripts.PythonScript
import java.util.Properties
import org.python.util.PythonInterpreter

class JythonScriptExecutor {

	def execute(PythonScript script) {

		val props = new Properties();
		props.put("python.home", "lib");
		props.put("python.console.encoding", "UTF-8"); // Used to prevent: console: Failed to install '': java.nio.charset.UnsupportedCharsetException: cp0.
		props.put("python.security.respectJavaAccessibility", "false"); // don't respect java accessibility, so that we can access protected members on subclasses
		props.put("python.import.site", "false");

		val preprops = System.getProperties();

		PythonInterpreter.initialize(preprops, props, #[]);

		val interp = new PythonInterpreter();
		interp.execfile(script.scriptLocation);
	}
}
