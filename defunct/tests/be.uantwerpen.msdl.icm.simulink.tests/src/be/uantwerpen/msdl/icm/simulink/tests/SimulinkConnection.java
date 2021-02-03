package be.uantwerpen.msdl.icm.simulink.tests;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

import org.junit.Test;

import matlabcontrol.MatlabConnectionException;
import matlabcontrol.MatlabInvocationException;
import matlabcontrol.MatlabProxy;
import matlabcontrol.MatlabProxyFactory;

public class SimulinkConnection {

	@Test
	public void run() throws MatlabConnectionException, MatlabInvocationException, FileNotFoundException, IOException {
		// MatlabEngine eng = MatlabEngine.startMatlab();
		// System.out.println(eng);
		// double[] a = {2.0 ,4.0, 6.0};
		// double[] roots = eng.feval("sqrt", a);
		// for (double d : roots) {
		// System.out.println(d);
		// }
		//
		// eng.close();
		MatlabProxyFactory factory = new MatlabProxyFactory();
		MatlabProxy proxy = factory.getProxy();

		File file = new File("scripts\\script.m");

		proxy.eval("disp('start processing 1')");

		try (BufferedReader br = new BufferedReader(new FileReader(file))) {
			String line;
			while ((line = br.readLine()) != null) {
				proxy.eval("disp('" + line + "')");
				proxy.eval(line);
			}
		}

		proxy.eval("disp('end of processing 2')");

		Object x = proxy.getVariable("x");
		Object y = proxy.getVariable("y");

		System.out.println(x);
		System.out.println(y);

		file = new File("scripts\\script2.m");

		proxy.eval("disp('start processing 2')");

		try (BufferedReader br = new BufferedReader(new FileReader(file))) {
			String line;
			while ((line = br.readLine()) != null) {
				proxy.eval("disp('" + line + "')");
				proxy.eval(line);
			}
		}

		proxy.eval("disp('end of processing 2')");

		Object z = proxy.getVariable("z");

		System.out.println(z);

		proxy.eval("disp('hello world')");

		proxy.disconnect();

		proxy.exit();

	}
}
