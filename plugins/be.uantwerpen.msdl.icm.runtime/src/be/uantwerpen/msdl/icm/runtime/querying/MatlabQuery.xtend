package be.uantwerpen.msdl.icm.runtime.querying

import be.uantwerpen.msdl.icm.runtime.scripting.connection.MatlabConnectionManager
import be.uantwerpen.msdl.processmodel.properties.Attribute
import be.uantwerpen.msdl.processmodel.properties.impl.MatlabAttributeDefinitionImpl

class MatlabQuery extends MatlabAttributeDefinitionImpl implements IExecutable {

	private var Attribute attribute;

	new(Attribute attribute) {
		this.attribute = attribute
	}

	override execute() {
		try {
			val matlabEngine = MatlabConnectionManager::matlabEngine;
			if (!attribute.aliases.empty) {
				for (alias : attribute.aliases.split(',')) {
					val aliasQueryResult = matlabEngine.getVariable(alias)
					if (aliasQueryResult !== null) {
						return aliasQueryResult
					}
				}
			}
			matlabEngine.getVariable(attribute.name)
		} catch (Exception ex) {
			return null
		}
	}
}
