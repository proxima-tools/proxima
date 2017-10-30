package be.uantwerpen.msdl.icm.runtime.querying

import be.uantwerpen.msdl.icm.runtime.querying.aliases.AliasHandler
import be.uantwerpen.msdl.icm.runtime.scripting.connection.MatlabConnectionManager
import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.processmodel.properties.Attribute
import be.uantwerpen.msdl.processmodel.properties.impl.MatlabAttributeDefinitionImpl
import org.eclipse.xtend.lib.annotations.Accessors

class MatlabQuery extends MatlabAttributeDefinitionImpl implements IExecutable {

	private static extension val AliasHandler aliasHandler = new AliasHandler()

	@Accessors(PRIVATE_GETTER, PRIVATE_SETTER) private val Attribute attribute;
	@Accessors(PRIVATE_GETTER, PRIVATE_SETTER) private val Activity activity;

	new(Attribute attribute, Activity activity) {
		this.attribute = attribute
		this.activity = activity
	}

	override execute() {
		try {
			val matlabEngine = MatlabConnectionManager::matlabEngine;
			val queryableName = attribute.getQueryableName(activity)
			matlabEngine.getVariable(queryableName)
		} catch (Exception ex) {
			return null
		}
	}
}
