/*******************************************************************************
 * Copyright (c) 2016-2017 Istvan David
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *    Istvan David - initial API and implementation
 *******************************************************************************/

package be.uantwerpen.msdl.process.design.services

import be.uantwerpen.msdl.processmodel.ProcessModel
import be.uantwerpen.msdl.processmodel.base.Identifiable
import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.processmodel.pm.Node
import be.uantwerpen.msdl.processmodel.pm.Process
import be.uantwerpen.msdl.processmodel.properties.Intent
import be.uantwerpen.msdl.processmodel.properties.IntentType
import be.uantwerpen.msdl.processmodel.properties.PropertyModel
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

	public def parseInt(String string) {
		Integer::parseInt(string)
	}

	public def getReadIntents(Activity activity) {
		activity.intent.filter [ Intent i |
			i.type.equals(IntentType::READ)
		].properties
	}

	public def getModifyIntents(Activity activity) {
		activity.intent.filter [ Intent i |
			i.type.equals(IntentType::MODIFY)
		].properties
	}

	public def getCheckIntents(Activity activity) {
		activity.intent.filter [ Intent i |
			i.type.equals(IntentType::CHECK_PROPERTY)
		].properties
	}

	public def getContractIntents(Activity activity) {
		activity.intent.filter [ Intent i |
			i.type.equals(IntentType::CONTRACT)
		].properties
	}

	def getProperties(Iterable<Intent> intents) {
		val properties = Lists::newArrayList

		intents.forEach [ i |
			properties += i.subject
		]

		properties
	}

	public def getIntents(Activity activity) {
		(activity.eContainer as PropertyModel).intent.filter [ i |
			i.activity.equals(activity)
		]
	}

//	public def getIntents(Activity activity) {
//		val processModel = activity.eContainer.eContainer as ProcessModel
//		val intents = processModel.intent;
//		
//		processModel.propertyModel.property.filter[Property p|
//			intents.exists[i | 
//				i.activity.equals(activity) && i.subject.equals(p)
//			]
//		].toList
//		
//		/* 
//		
//		val intents = processModel.intent.filter [ i |
//			i.activity.equals(activity)
//		]
//		//.fold(Lists.newArrayList) [list, i|
//		//	list+=i
//		//]
//		
//		val properties = Lists::newArrayList
//		
//		intents.forEach[i | properties+=i.subject]
//		*/
//	}
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
//	public def getPropertyDependencies(Activity activity) {
//		var process = activity.eContainer as Process
//		var processModel = process.eContainer as ProcessModel
//
//		processModel.intent.filter [ intent |
//			intent.activity.equals(activity)
//		] // .forEach [ intent |
////			println("input intent: " + intent)
////			println(intent.subjectOfIntent)
////			intent.subjectOfIntent.intent.filter [ i2 |
////				!i2.equals(intent)
////			].forEach[i3 |
////				println(i3)
////			]
////		]
//		.fold(Lists::newArrayList) [ list, intent |
////			println("input intent: " + intent)
//			list.addAll(intent.subject.intent // TODO here, it should be made transitive over the P-map
//			.filter [ intent2 |
//				!intent2.equals(intent)
//			].filter [ intent2 |
//				dependencyImplications.contains(new Pair(intent.type, intent2.type)) &&
//					followedBy(intent.activity, intent2.activity)
//			].map [ x |
//				x.activity
//			])
////			println("resulting list: " + list)
//			list
//		]
//	}
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

		node.controlOut.forEach [ controlFlow |
			if (!subsequentNodes.contains(controlFlow.to)) {
				newNodes.add(controlFlow.to)
			}
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
//	@Deprecated
//	def getLinkedProperty(PropertyLink propertyLink) {
//		val linkedElement = propertyLink.eContainer
//
//		val linkedProperties = Lists::newArrayList
//
//		switch linkedElement {
//			Object:
//				// if there's a related activity and the object's typing language is linked to the same property
//				linkedElement.typedBy.propertyLink.forEach [ pl |
//					linkedProperties += pl.linkedProperty
//				]
//			Language:
//				linkedProperties += propertyLink.linkedProperty
//		}
//
//		linkedProperties
//	}
	def getCodeGenLocation(ProcessModel processModel) {
		processModel.codeGenProperties.get("location")
	}

	def getCodeGenRootPackage(ProcessModel processModel) {
		processModel.codeGenProperties.get("rootPackage")
	}
}
