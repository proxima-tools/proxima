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
			// TODO lift alias handling to a more abstract level where it's independent from the service being queried
			if (attribute.aliases !== null) {
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
