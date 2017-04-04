package be.uantwerpen.msdl.icm.runtime.variablemanager.model

import org.eclipse.xtend.lib.annotations.Accessors

class Result {
	@Accessors(PUBLIC_GETTER) String variableName
	@Accessors(PUBLIC_GETTER) double value

	new(String variableName, double value) {
		this.variableName = variableName;
		this.value = value;
	}
}
