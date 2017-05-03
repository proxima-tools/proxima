package be.uantwerpen.msdl.icm.simulink.tests;

import com.mathworks.engine.MatlabEngine;

public class SimulinkConnection {
	public static void main(String[] args) throws Exception {
        MatlabEngine eng = MatlabEngine.startMatlab();
        System.out.println(eng);
        double[] a = {2.0 ,4.0, 6.0};
        double[] roots = eng.feval("sqrt", a);
        for (double d : roots) {
			System.out.println(d);
		}
        
        eng.close();
    }
}
