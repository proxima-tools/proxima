package be.uantwerpen.msdl.icm.examples.full.main.scripts;

import java.util.Map;
import java.util.Map.Entry;

import org.apache.log4j.Level;

import be.uantwerpen.msdl.icm.runtime.scripting.scripts.JavaBasedScript;
import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager;

public class ChangeValue extends JavaBasedScript {

	public ChangeValue() {
		logger.setLevel(Level.DEBUG);
		logger.debug("Executing " + this.getClass().getSimpleName());
	}

	@Override
	public void run() {
		// TODO Auto-generated definition
	}

	public void runWithParameters(Map<Object, Object> parameters) {
		for (Entry<Object, Object> entry : parameters.entrySet()) {
			VariableManager.getInstance().setVariable(entry.getKey().toString(),
					Double.parseDouble(entry.getValue().toString()));
		}

		this.run();
	}
}
