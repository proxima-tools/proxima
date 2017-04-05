package be.uantwerpen.msdl.icm.scripting.python

import be.uantwerpen.msdl.icm.scripting.scripts.PythonScript
import java.io.BufferedReader
import java.io.InputStreamReader

class RuntimeScriptExecutor  {

	def execute(PythonScript script) {
		val p = Runtime.getRuntime().exec("python " + script.scriptLocation);
		val in = new BufferedReader(new InputStreamReader(p.getInputStream()));
		System.out.println(in.readLine);
	}
}
