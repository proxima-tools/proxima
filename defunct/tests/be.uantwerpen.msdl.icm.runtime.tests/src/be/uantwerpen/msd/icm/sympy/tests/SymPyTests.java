package be.uantwerpen.msd.icm.sympy.tests;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;

import org.junit.Test;

public class SymPyTests {

	@Test
	public void run() throws IOException{
//		Properties props = new Properties();
////		props.put("python.home", "lib");
//		props.put("python.console.encoding", "UTF-8"); // Used to prevent: console: Failed to install '': java.nio.charset.UnsupportedCharsetException: cp0.
//		props.put("python.security.respectJavaAccessibility", "false"); // don't respect java accessibility, so that we can access protected members on subclasses
//		props.put("python.import.site", "false");
////		props.put("python.home", "c:\\Program Files\\Python\\Python35\\Lib");
//
//		Properties preprops = System.getProperties();
//
//		PythonInterpreter.initialize(preprops, props, new String[0]);
//
//		PythonInterpreter interpreter = new PythonInterpreter();		
//		
//		interpreter.exec(Scripts.script3);
//		
//		interpreter.close();
		
		File f = File.createTempFile("test", ".py");
		f.deleteOnExit();
		BufferedWriter out = new BufferedWriter(new FileWriter(f));
		out.write(Scripts.script1);
		out.close();
		
		System.out.println(f.getAbsolutePath());
		
		Runtime runtime = Runtime.getRuntime();
		
		Process p = runtime.exec("python " + f.getAbsolutePath());
		BufferedReader in = new BufferedReader(new InputStreamReader(p.getInputStream()));
		String retval = in.readLine();
		
		System.out.println(retval);
		
		if(retval.equalsIgnoreCase("false")){
			System.err.println("INCONSISTENCY DETECTED");
		}else{
			System.out.println("OK");
		}
		
		File f2 = File.createTempFile("test", ".py");
		f2.deleteOnExit();
		BufferedWriter out2 = new BufferedWriter(new FileWriter(f2));
		out2.write(Scripts.script1b);
		out2.close();
		
		System.out.println(f2.getAbsolutePath());
		
		Process p2 = runtime.exec("python " + f2.getAbsolutePath());
		BufferedReader in2 = new BufferedReader(new InputStreamReader(p2.getInputStream()));
		String retval2 = in2.readLine();
		
		System.out.println(retval2);
		
		if(retval2.equalsIgnoreCase("false")){
			System.err.println("INCONSISTENCY DETECTED");
		}else{
			System.out.println("OK");
		}
	}
}
