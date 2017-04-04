package be.uantwerpen.msdl.icm.scripting.python

import java.util.Properties
import org.python.util.PythonInterpreter
import be.uantwerpen.msdl.icm.scripting.IExecutor

class JythonScriptManager implements IExecutor {

	override execute(String script) {

		val props = new Properties();
		props.put("python.home", "lib");
		props.put("python.console.encoding", "UTF-8"); // Used to prevent: console: Failed to install '': java.nio.charset.UnsupportedCharsetException: cp0.
		props.put("python.security.respectJavaAccessibility", "false"); // don't respect java accessibility, so that we can access protected members on subclasses
		props.put("python.import.site", "false");

		val preprops = System.getProperties();

		PythonInterpreter.initialize(preprops, props, #[]);

		val interp = new PythonInterpreter();
		interp.execfile(script);
	}
}
