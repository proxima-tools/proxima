package be.uantwerpen.msdl.icm.runtime.querying.toolselection

import be.uantwerpen.msdl.processmodel.ftg.Formalism
import be.uantwerpen.msdl.processmodel.ftg.Tool
import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.processmodel.pm.Object
import be.uantwerpen.msdl.processmodel.properties.Attribute
import be.uantwerpen.msdl.processmodel.properties.PropertyModel

class ToolSelectionHelper {

	def Tool selectTool(Attribute attribute, Activity activity) {
		val intent = (attribute.eContainer as PropertyModel).intent.findFirst [ i |
			i.activity.equals(activity) && i.subject.equals(attribute)
		]

		// if intent's object is set
		if (intent.object !== null) {
			return intent.object.selectTool
		}

		// otherwise figure out the required tool
		val dataIn = intent.activity.dataFlowFrom
		val dataOut = intent.activity.dataFlowTo
		val objects = (dataIn + dataOut).map[d|d as Object]

		val tools = objects.map[o|(o.typedBy as Formalism).implementedBy].flatten.groupBy[it].keySet

		if (tools.size != 1) {
			throw new IllegalArgumentException("Ambiguous tool/formalism/object definition.")
		}

		tools.head
	}

	def Tool selectTool(Object object) {
		(object.typedBy as Formalism).implementedBy.head
	}
}
