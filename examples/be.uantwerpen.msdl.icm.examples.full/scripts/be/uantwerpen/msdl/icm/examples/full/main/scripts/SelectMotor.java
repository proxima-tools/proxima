package be.uantwerpen.msdl.icm.examples.full.main.scripts;

import org.apache.log4j.Level;
import java.util.Map;
import com.google.common.collect.Maps;

import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager;
import be.uantwerpen.msdl.icm.runtime.scripting.scripts.JavaBasedScript;

public class SelectMotor extends JavaBasedScript{
	
	private Map<Object, Object> parameters = Maps.newHashMap();
	
	//Constructor
	public SelectMotor() {
	}
	
	@Override
	public void run() {
		logger.setLevel(Level.DEBUG);
		logger.debug("Executing " + this.getClass().getSimpleName());
		
		ChangeValue changeValue = new ChangeValue();
		
		changeValue.runWithParameters(parameters);
	}
}
