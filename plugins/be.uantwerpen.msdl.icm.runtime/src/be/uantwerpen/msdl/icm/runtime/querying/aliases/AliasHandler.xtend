package be.uantwerpen.msdl.icm.runtime.querying.aliases

import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.processmodel.pm.Object
import be.uantwerpen.msdl.processmodel.properties.Attribute
import com.google.common.base.Strings

class AliasHandler {
	val String LIST_SEPARATOR = ";"
	val String ALIAS_SEPARATOR = ":"

	def String getQueryableName(Attribute attribute, Activity activity) {
		if (Strings.isNullOrEmpty(attribute.aliases)) {
			//no alias -> look for the original name
			return attribute.name
		} else {
			val aliases = attribute.aliases.trim.split(LIST_SEPARATOR)

			val inputObjects = activity.dataFlowFrom.map[n|n as Object]

			for (alias : aliases) {
				for (inputObject : inputObjects) {
					val aliasObjectName = alias.trim.split(ALIAS_SEPARATOR).head.trim
					if (inputObject.name.equalsIgnoreCase(aliasObjectName)) {
						// model's name found in alias list, should look for the specific name
						return alias.trim.split(ALIAS_SEPARATOR).last.trim
					}
				}
			}
			
			// model's name not found in the alias list, go with the original name
			return attribute.name
		}
	}
}
