package be.uantwerpen.msdl.icm.examples.full.main.scripts;

import org.apache.log4j.Level;

import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager;
import be.uantwerpen.msdl.icm.scripting.scripts.JavaBasedScript;

public class A3 extends JavaBasedScript {

    @Override
    public void run() {
        logger.setLevel(Level.DEBUG);

        logger.debug("Executing " + this.getClass().getSimpleName());

        logger.debug(String.format("Setting variable %s to value %d", "motorMass", 50));

        VariableManager.getInstance().setVariable("motorMass", 50);
    }
}
