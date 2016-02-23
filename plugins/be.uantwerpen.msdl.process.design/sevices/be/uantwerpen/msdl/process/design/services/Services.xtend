package be.uantwerpen.msdl.process.design.services

import be.uantwerpen.msdl.metamodels.process.Activity
import be.uantwerpen.msdl.metamodels.process.IntentType
import be.uantwerpen.msdl.metamodels.process.Node
import be.uantwerpen.msdl.metamodels.process.Process
import be.uantwerpen.msdl.metamodels.process.ProcessModel
import com.google.common.collect.Lists
import com.google.common.collect.Sets
import java.util.Set

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
			node.dataFlowFrom.contains(activity) && !node.dataFlowTo.contains(activity)
		].fold(Lists::newArrayList) [ list, node |
			list.addAll(node.dataFlowTo)
			list
		]
	}

	/**
	 * Collects property-based dependencies for a given activity.
	 */
	public def getPropertyDependencies(Activity activity) {
		var process = activity.eContainer as Process
		var processModel = process.eContainer as ProcessModel

		processModel.intent.filter [ intent |
			intent.activity.equals(activity)
		].fold(Lists::newArrayList) [ list, intent |
			list.addAll(intent.propertyOfIntent.intentOfProperty.filter [ intent2 |
				!intent2.equals(intent)
			].filter [ intent2 |
				dependencyImplications.contains(new Pair(intent.type, intent2.type)) &&
					followedBy(intent.activity, intent2.activity)
			].map [ x |
				x.activity
			])
			list
		]
	}

	val dependencyImplications = #[new Pair(IntentType.MODIFY, IntentType.READ)]

	def boolean followedBy(Node node1, Node node2) {
		node1.collectSubsequentNodes.contains(node2)
	}

	def Set<Node> collectSubsequentNodes(Node node) {
		collectSubsequentNodes(node, Sets::newHashSet)
	}

	def Set<Node> collectSubsequentNodes(Node node, Set<Node> subsequentNodes) {
		val newNodes = Sets::newHashSet

		node.toControlFlow.forEach [ controlFlow |
			controlFlow.toNode.filter [ n |
				!subsequentNodes.contains(n)
			].forEach [ n |
				newNodes.add(n)
			]
		]

		subsequentNodes.addAll(newNodes)

		if (newNodes.size > 0) {
			for (n : newNodes) {
				n.collectSubsequentNodes(subsequentNodes)
			}
		}

		subsequentNodes
	}
}
