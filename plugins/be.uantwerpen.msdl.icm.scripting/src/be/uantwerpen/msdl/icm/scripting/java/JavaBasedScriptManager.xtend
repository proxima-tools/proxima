package be.uantwerpen.msdl.icm.scripting.java

import be.uantwerpen.msdl.icm.scripting.IExecutor

class JavaBasedScriptManager implements IExecutor {

	override execute(String script) {
		println("executing java-based script " + script)

		val className = script.split('\\.').reverse.get(1).split('\\\\').last

		val clazz = Class.forName("be.uantwerpen.msdl.icm.test.data.scripts." + className);
		val runnable = clazz.newInstance() as Runnable

		runnable.run

//		// Compile source file.
//		val compiler = ToolProvider.getSystemJavaCompiler()
//		compiler.run(null, null, null, script)
//
//		// Load and instantiate compiled class.
//		val classLoader = URLClassLoader.newInstance(#[new URL("..\\be.uantwerpen.msdl.icm.test.data\\scripts")])
//		val cls = Class.forName("a1.class", true, classLoader); // Should print "hello".
//		val instance = cls.newInstance(); // Should print "world".
//		System.out.println(instance); // Should print "test.Test@hashcode".
	}
}
