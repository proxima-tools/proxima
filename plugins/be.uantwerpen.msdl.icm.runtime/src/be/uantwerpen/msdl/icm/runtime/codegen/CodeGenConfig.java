package be.uantwerpen.msdl.icm.runtime.codegen;

public class CodeGenConfig {
	private static CodeGenConfig instance;

	private String location;
	private String rootPackage;

	private CodeGenConfig() {
	}

	public static CodeGenConfig instance() {
		if (instance == null) {
			instance = new CodeGenConfig();
		}

		return instance;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getLocation() {
		return location;
	}

	public void setRootPackage(String rootPackage) {
		this.rootPackage = rootPackage;
	}

	public String getRootPackage() {
		return rootPackage;
	}
}
