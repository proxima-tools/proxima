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

package org.proxima.commons.bl

import be.uantwerpen.msdl.proxima.processmodel.properties.Attribute
import be.uantwerpen.msdl.proxima.processmodel.properties.Capability
import be.uantwerpen.msdl.proxima.processmodel.properties.Property
import be.uantwerpen.msdl.proxima.processmodel.properties.Relationship
import be.uantwerpen.msdl.proxima.processmodel.properties.RelationshipSubject
import java.util.HashMap

class Relationships {
	
	/**
	 * Ordinary relationships work on homogeneous subject sets.
	 */
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
	
	/**
	 * Connects a property with something else. (Either an attribute or a Relationship.)
	 */
	def isPropertyDefinitionRelationship(Relationship relationship) {
		if(!(relationship.relationshipLink.size == 2)) return false
		val hasProperty = relationship.relationshipLink.map[rl|rl.subject].exists[s|s instanceof Property]
		val hasNoProperty = relationship.relationshipLink.map[rl|rl.subject].exists[s|!(s instanceof Property)]
		return hasProperty && hasNoProperty
	}
	
	/**
	 * HOR: each link refers to another Relationships.
	 */
	def isHigherOrderRelationship(Relationship relationship) {
		return relationship.relationshipLink.forall [ link |
			link.subject instanceof Relationship
		]
	}
	
	/**
	 * Constraint: only one subject. It's either a Capability constraint or an Attribute constraint.
	 */
	def isConstraint(Relationship relationship) {
		if (relationship.relationshipLink.empty) {
			return false;
		} else if (relationship.relationshipLink.size > 1) {
			return false
		}

		return true
	}
	
	/**
	 * Capability constraint: only one capability.
	 */
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
	
	/**
	 * Capability constraint: only one attribute.
	 */
	def isAttributeConstraint(Relationship relationship) {
		if (!isConstraint(relationship)) {
			return false
		}
		val subject = relationship.relationshipLink.head.subject
		if (!(subject instanceof Attribute)) {
			return false
		}
		return true
	}
}
