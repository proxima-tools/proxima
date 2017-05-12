package be.uantwerpen.msdl.icm.examples.full.main.scripts;

import org.apache.log4j.Level;
import java.util.Map;

import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager;
import be.uantwerpen.msdl.icm.scripting.scripts.JavaBasedScript;

public class ChangeValue extends JavaBasedScript{
	
	public ChangeValue() {
		logger.setLevel(Level.DEBUG);
		logger.debug("Executing " + this.getClass().getSimpleName());
	}
	
	@Override
	public void run() {
		//TODO Auto-generated definition
	}
	
	public void runWithParameters(Map<Object, Object> parameters) {
		//TODO Handle parameters
		
		this.run();
	}
}
