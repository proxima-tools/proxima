package be.uantwerpen.msdl.process.design.services

import be.uantwerpen.msdl.metamodels.process.Activity
import be.uantwerpen.msdl.metamodels.process.Identifiable
import be.uantwerpen.msdl.metamodels.process.IntentType
import be.uantwerpen.msdl.metamodels.process.Language
import be.uantwerpen.msdl.metamodels.process.Node
import be.uantwerpen.msdl.metamodels.process.Object
import be.uantwerpen.msdl.metamodels.process.Process
import be.uantwerpen.msdl.metamodels.process.ProcessModel
import be.uantwerpen.msdl.metamodels.process.PropertyLink
import com.google.common.collect.Lists
import com.google.common.collect.Sets
import java.util.Set
import java.util.UUID

/**
 * Services for the editor
 * 
 * @author Istvan David
 */
class Services {
	new() {
	}

	public def getId(Identifiable identifiable) {
		UUID.randomUUID.toString
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
	 * TODO make this transitive among constraints as well
	 */
	public def getPropertyDependencies(Activity activity) {
		var process = activity.eContainer as Process
		var processModel = process.eContainer as ProcessModel

		processModel.intent.filter [ intent |
			intent.activity.equals(activity)
		] // .forEach [ intent |
//			println("input intent: " + intent)
//			println(intent.subjectOfIntent)
//			intent.subjectOfIntent.intent.filter [ i2 |
//				!i2.equals(intent)
//			].forEach[i3 |
//				println(i3)
//			]
//		]
		.fold(Lists::newArrayList) [ list, intent |
//			println("input intent: " + intent)
			list.addAll(intent.subjectOfIntent.intent // TODO here, it should be made transitive over the P-map
			.filter [ intent2 |
				!intent2.equals(intent)
			].filter [ intent2 |
				dependencyImplications.contains(new Pair(intent.type, intent2.type)) &&
					followedBy(intent.activity, intent2.activity)
			].map [ x |
				x.activity
			])
//			println("resulting list: " + list)
			list
		]
	}

	val dependencyImplications = #[new Pair(IntentType.READ, IntentType.MODIFY)]

	def boolean followedBy(Node node1, Node node2) {
//		println("testing followedby relationship")
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

	// FIXME: it's not clear yet what do we want to show here, deprecated until further development
	@Deprecated
	def getLinkedProperty(PropertyLink propertyLink) {
		val linkedElement = propertyLink.eContainer

		val linkedProperties = Lists::newArrayList

		switch linkedElement {
			Object:
				// if there's a related activity and the object's typing language is linked to the same property
				linkedElement.typedBy.propertyLink.forEach [ pl |
					linkedProperties += pl.linkedProperty
				]
			Language:
				linkedProperties += propertyLink.linkedProperty
		}

		linkedProperties
	}
}
