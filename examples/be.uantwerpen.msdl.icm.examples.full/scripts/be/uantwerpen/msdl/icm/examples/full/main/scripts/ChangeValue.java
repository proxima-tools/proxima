package be.uantwerpen.msdl.icm.examples.full.main.scripts;

import java.util.Map;
import java.util.Map.Entry;

import org.apache.log4j.Level;

import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager;
import be.uantwerpen.msdl.icm.scripting.scripts.JavaBasedScript;

public class ChangeValue extends JavaBasedScript {
	@Override
	public void run() {
		logger.setLevel(Level.DEBUG);
		logger.debug("Executing " + this.getClass().getSimpleName());

		// TODO Auto-generated definition
	}

	public void runWithParameters(Map<Object, Object> parameters) {
		logger.setLevel(Level.DEBUG);
		logger.debug("Executing " + this.getClass().getSimpleName());

		for (Entry<Object, Object> entry : parameters.entrySet()) {
			VariableManager.getInstance().setVariable(entry.getKey().toString(),
					Double.parseDouble(entry.getValue().toString()));
		}

		this.run();
	}
}
