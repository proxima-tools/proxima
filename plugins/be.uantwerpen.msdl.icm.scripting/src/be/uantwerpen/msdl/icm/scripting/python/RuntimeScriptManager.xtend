package be.uantwerpen.msdl.icm.scripting.python

import java.io.BufferedReader
import java.io.InputStreamReader
import be.uantwerpen.msdl.icm.scripting.IExecutor

class RuntimeScriptManager implements IExecutor {
	
	override execute(String script) {
		val p = Runtime.getRuntime().exec("python " + script);
		val in = new BufferedReader(new InputStreamReader(p.getInputStream()));
		System.out.println(in.readLine);
	}
}
