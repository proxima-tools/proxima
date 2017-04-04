package be.uantwerpen.msdl.icm.runtime.api;

import be.uantwerpen.msdl.processmodel.pm.AutomatedActivity;

public abstract class JavaBasedScript implements Runnable {
	private AutomatedActivity automatedActivity;

	public AutomatedActivity getAutomatedActivity() {
		return automatedActivity;
	}

	public void setAutomatedActivity(AutomatedActivity automatedActivity) {
		this.automatedActivity = automatedActivity;
	}
}
