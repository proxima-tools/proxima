package be.uantwerpen.msdl.icm.examples.full.main.scripts;

import org.apache.log4j.Level;
import java.util.Map;
import com.google.common.collect.Maps;

import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager;
import be.uantwerpen.msdl.icm.scripting.scripts.JavaBasedScript;

public class A1 extends JavaBasedScript{
	
	private Map<Object, Object> parameters = Maps.newHashMap();
	
	//Constructor
	public A1() {
		parameters.put("platformMass", "100");
	}
	
	@Override
	public void run() {
		logger.setLevel(Level.DEBUG);
		logger.debug("Executing " + this.getClass().getSimpleName());
		
		ChangeValue changeValue = new ChangeValue();
		
		changeValue.runWithParameters(parameters);
	}
}
