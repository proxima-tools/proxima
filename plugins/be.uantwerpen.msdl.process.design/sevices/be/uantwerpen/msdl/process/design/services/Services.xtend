package be.uantwerpen.msdl.process.design.services

import be.uantwerpen.msdl.metamodels.process.Activity
import be.uantwerpen.msdl.metamodels.process.Process
import be.uantwerpen.msdl.metamodels.process.ProcessModel
import com.google.common.collect.Lists

/**
 * Services for the editor
 * 
 * @author Istvan David
 */
class Services {
	new() {
	}

	/**
	 * Collects data dependencies for a given activity.
	 */
	public def getDataDependencies(Activity activity) {
		var process = activity.eContainer as Process

		process.node.filter [ node |
			node.dataFlowFrom.contains(activity)
		].fold(Lists::newArrayList) [ list, node |
			list.addAll(node.dataFlowTo)
			list
		]
	}

	/**
	 * Collects property-based dependencies for a given activity.
	 * TODO only the appropriate pairs of intents should be considered, e.g. read-modify
	 */
	public def getPropertyDependencies(Activity activity) {
		var process = activity.eContainer as Process
		var processModel = process.eContainer as ProcessModel

		processModel.intent.filter [ intent |
			intent.activity.equals(activity)
		].fold(Lists::newArrayList) [ list, intent |
			list.addAll(intent.propertyOfIntent.intentOfProperty.filter [ intent2 |
				!intent2.equals(intent)
			].map[x|x.activity])
			list
		]
	}
}
