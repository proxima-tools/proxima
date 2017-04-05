package be.uantwerpen.msdl.icm.scripting.manager

import be.uantwerpen.msdl.icm.scripting.java.JavaBasedScriptExecutor
import be.uantwerpen.msdl.icm.scripting.python.RuntimeScriptExecutor
import be.uantwerpen.msdl.icm.scripting.scripts.IScript
import be.uantwerpen.msdl.icm.scripting.scripts.JavaBasedScript
import be.uantwerpen.msdl.icm.scripting.scripts.PythonScript

class ScriptExecutionManager {

	val public static String PYTHON_EXTENSION = "py"
	val public static String JAVA_EXTENSION = "java"

	val pythonExecutor = new RuntimeScriptExecutor
	val javaExecutor = new JavaBasedScriptExecutor

	def execute(IScript script) {
		switch (script) {
			JavaBasedScript: javaExecutor.execute(script)
			PythonScript: pythonExecutor.execute(script)
		}
	}
}
