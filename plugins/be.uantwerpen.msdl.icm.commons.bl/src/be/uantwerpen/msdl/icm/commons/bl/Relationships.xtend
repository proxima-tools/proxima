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

package be.uantwerpen.msdl.icm.commons.bl

import be.uantwerpen.msdl.processmodel.properties.Attribute
import be.uantwerpen.msdl.processmodel.properties.Capability
import be.uantwerpen.msdl.processmodel.properties.Property
import be.uantwerpen.msdl.processmodel.properties.Relationship
import be.uantwerpen.msdl.processmodel.properties.RelationshipDirection
import be.uantwerpen.msdl.processmodel.properties.RelationshipSubject
import java.util.HashMap

class Relationships {

	def isSimpleRelationship(Relationship relationship) {
		if(relationship.isConstraint || relationship.isPropertyDefinitionRelationship ||
			relationship.isHigherOrderRelationship) return false

		var typeMap = new HashMap<Class<? extends RelationshipSubject>, Integer>

		for (subject : relationship.relationshipLink.map[r|r.subject]) {
			if (typeMap.containsKey(subject.class)) {
				var count = typeMap.get(subject.class)
				count++
			} else {
				typeMap.put(subject.class, 1)
			}
		}

		return typeMap.entrySet.size == 1
	}

	def isPropertyDefinitionRelationship(Relationship relationship) {
		if(!(relationship.relationshipLink.size == 2)) return false
		val hasProperty = relationship.relationshipLink.map[rl|rl.subject].exists[s|s instanceof Property]
		val hasAttribute = relationship.relationshipLink.map[rl|rl.subject].exists[s|s instanceof Attribute]
		return hasProperty && hasAttribute
	}

	def isHigherOrderRelationship(Relationship relationship) {
		return relationship.relationshipLink.exists [ link |
			link.subject instanceof Relationship
		]
	}

	def isConstraint(Relationship relationship) {
		if (relationship.relationshipLink.empty) {
			return false;
		} else if (relationship.relationshipLink.size > 1) { // FIXME: this sort of relationshiplink counting may be buggy all over the code because of the containment reference is added to the source
			return false
		} else if (!relationship.relationshipLink.head.direction.equals(RelationshipDirection::UNDIRECTED)) {
			return false
		}

		return true
	}

	def isCapabilityConstraint(Relationship relationship) {
		if (!isConstraint(relationship)) {
			return false
		}
		val subject = relationship.relationshipLink.head.subject
		if (!(subject instanceof Capability)) {
			return false
		}
		return true
	}

	def isAttributeConstraint(Relationship relationship) {
		val subject = relationship.relationshipLink.head.subject
		if (!(subject instanceof Attribute)) {
			return false
		}
		return true
	}
}
