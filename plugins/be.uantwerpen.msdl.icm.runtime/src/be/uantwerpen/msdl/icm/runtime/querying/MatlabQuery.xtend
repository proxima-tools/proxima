package be.uantwerpen.msdl.icm.runtime.querying

import be.uantwerpen.msdl.processmodel.pm.Object
import be.uantwerpen.msdl.processmodel.properties.impl.AttributeDefinitionImpl

class MatlabQuery extends AttributeDefinitionImpl {

	private var Object object;
	
	new(Object object){
		this.object = object
	}

	def attribute(String name) {
		return null
	}


}

class Test {
	val m = new MatlabQuery(null).attribute("platformMass")
}
