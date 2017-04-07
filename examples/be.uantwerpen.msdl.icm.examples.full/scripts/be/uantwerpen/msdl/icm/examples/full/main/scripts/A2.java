package be.uantwerpen.msdl.icm.examples.full.main.scripts;

import org.apache.log4j.Level;

import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager;
import be.uantwerpen.msdl.icm.scripting.scripts.JavaBasedScript;

public class A2 extends JavaBasedScript {

    @Override
    public void run() {
        logger.setLevel(Level.DEBUG);

        logger.debug("Executing " + this.getClass().getSimpleName());

        logger.debug(String.format("Setting variable %s to value %d", "batteryMass", 10));

        VariableManager.getInstance().setVariable("batteryMass", 10);
    }
}
