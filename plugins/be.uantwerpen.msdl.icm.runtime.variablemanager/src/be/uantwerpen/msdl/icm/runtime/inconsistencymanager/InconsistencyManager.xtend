package be.uantwerpen.msdl.icm.runtime.inconsistencymanager

import be.uantwerpen.msdl.icm.runtime.variablemanager.model.Relationship2
import be.uantwerpen.msdl.processmodel.properties.Relationship

class InconsistencyManager {

	def static reportError(Relationship relationship, Relationship2 relationship2) {
		System.err.println(
			String::format("Inconsistency detected at Relationship (%s) #%s with formula %s.",
				relationship.precision.literal, relationship.id, relationship.formula.definition))
	}

}
