package be.uantwerpen.msdl.icm.scripting.scripts;

import org.apache.log4j.Logger;

import be.uantwerpen.msdl.processmodel.pm.AutomatedActivity;

public abstract class JavaBasedScript implements IScript, Runnable {
    
    protected Logger logger = Logger.getLogger(this.getClass().getCanonicalName());
    
	private AutomatedActivity automatedActivity;

	public AutomatedActivity getAutomatedActivity() {
		return automatedActivity;
	}

	public void setAutomatedActivity(AutomatedActivity automatedActivity) {
		this.automatedActivity = automatedActivity;
	}
}
