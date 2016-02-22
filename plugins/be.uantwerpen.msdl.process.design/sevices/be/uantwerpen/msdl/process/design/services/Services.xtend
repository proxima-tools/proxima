package be.uantwerpen.msdl.process.design.services

import be.uantwerpen.msdl.metamodels.process.Activity
import com.google.common.collect.Lists
import be.uantwerpen.msdl.metamodels.process.ProcessModel

class Services {
	new() {
	}

	public def getControlDependencies(Activity activity) {
		val list = Lists::newArrayList()

		var process = activity.eContainer as be.uantwerpen.msdl.metamodels.process.Process

		process.controlFlow.filter [ cf |
			cf.fromNode.contains(activity)
		].forEach [ cf |
			list.addAll(cf.toNode)
		]

		return list
	}

	public def getDataDependencies(Activity activity) {
		val list = Lists::newArrayList()
		var process = activity.eContainer as be.uantwerpen.msdl.metamodels.process.Process

		process.node.filter [ node |
			node.dataFlowFrom.contains(activity)
		].forEach [ node |
			list.addAll(node.dataFlowTo)
		]

		return list
	}

	public def getPropertyDependencies(Activity activity) {
		val list = Lists::newArrayList()

		var process = activity.eContainer as be.uantwerpen.msdl.metamodels.process.Process
		var processModel = process.eContainer as ProcessModel

		processModel.intent.filter [ intent |
			intent.activity.equals(activity)
		].forEach [ intent |
			intent.propertyOfIntent.intentOfProperty.filter [ intent2 |
				!intent2.equals(intent)
			].forEach [ intent2 |
				list.addAll(intent2.activity)
			]
		]

		return list
	}
}
