package be.uantwerpen.msdl.icm.scripting;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.StringWriter;

import javax.script.ScriptContext;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;
import javax.script.SimpleScriptContext;

public class FileBasedTest {
	public static void main(String args[]) throws FileNotFoundException, ScriptException {
		StringWriter writer = new StringWriter(); //ouput will be stored here

	    ScriptEngineManager manager = new ScriptEngineManager();
	    ScriptContext context = new SimpleScriptContext();

	    context.setWriter(writer); //configures output redirection
	    ScriptEngine engine = manager.getEngineByName("python");
	    engine.eval(new FileReader("test1.py"), context);
	    System.out.println(writer.toString()); 
	}

}
