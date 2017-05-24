package be.uantwerpen.msdl.icm.simulink.tests;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;
import java.util.concurrent.RejectedExecutionException;

import org.junit.Test;

import com.mathworks.engine.MatlabEngine;

public class MatlabEvalTest {

	@Test
	public void run() throws IllegalArgumentException, IllegalStateException, InterruptedException,
			RejectedExecutionException, ExecutionException {
		Future<MatlabEngine> eng = MatlabEngine.startMatlabAsync();
		MatlabEngine matlabEngine = eng.get();

//		matlabEngine.eval(Templates.function().toString());

		matlabEngine.eval("addpath('D:\\GitHub\\msdl\\ICM\\examples\\be.uantwerpen.msdl.icm.cases.demo\\matlab');"
				+ ""
				+ "MotorDB = motorDBSetup();");

		Object object = matlabEngine.getVariableAsync("MotorDB").get();

		System.out.println(object);
		matlabEngine.close();
	}
}
