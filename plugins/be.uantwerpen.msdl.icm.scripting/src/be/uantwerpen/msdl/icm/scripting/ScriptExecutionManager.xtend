package be.uantwerpen.msdl.icm.scripting

import be.uantwerpen.msdl.icm.scripting.python.RuntimeScriptManager
import be.uantwerpen.msdl.icm.scripting.java.JavaBasedScriptManager

class ScriptExecutionManager {
	
	val public static String PYTHON_EXTENSION = "py"
	val public static String JAVA_EXTENSION = "java"
	
	val IExecutor pythonExecutor = new RuntimeScriptManager
	val IExecutor javaExecutor = new JavaBasedScriptManager
	
	def execute(String script) {
		val split =  script.split('\\.')
		switch(split.last){
			case PYTHON_EXTENSION: pythonExecutor.execute(script)
			case JAVA_EXTENSION: javaExecutor.execute(script)
			default: throw new IllegalArgumentException("Unknown file extension.")
		}
	}

}