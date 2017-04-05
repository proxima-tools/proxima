package be.uantwerpen.msdl.icm.scripting.scripts;

import be.uantwerpen.msdl.processmodel.pm.AutomatedActivity;

public abstract class JavaBasedScript implements IScript, Runnable {
	private AutomatedActivity automatedActivity;

	public AutomatedActivity getAutomatedActivity() {
		return automatedActivity;
	}

	public void setAutomatedActivity(AutomatedActivity automatedActivity) {
		this.automatedActivity = automatedActivity;
	}
}
