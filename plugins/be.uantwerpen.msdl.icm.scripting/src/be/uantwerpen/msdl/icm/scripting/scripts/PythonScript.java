package be.uantwerpen.msdl.icm.scripting.scripts;

public class PythonScript implements IScript {

	private String scriptLocation;

	public PythonScript(String scriptLocation) {
		this.scriptLocation = scriptLocation;
	}

	public String getScriptLocation() {
		return scriptLocation;
	}
}
