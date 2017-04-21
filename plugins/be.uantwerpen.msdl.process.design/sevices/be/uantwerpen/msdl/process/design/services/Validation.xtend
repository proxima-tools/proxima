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

import be.uantwerpen.msdl.processmodel.properties.Attribute
import be.uantwerpen.msdl.processmodel.properties.Capability
import be.uantwerpen.msdl.processmodel.properties.Relationship
import be.uantwerpen.msdl.processmodel.properties.RelationshipDirection

class Validation {
	new() {
	}

	public def validConstraint(Relationship relationship) {
		if (relationship.constraint) {
			return relationship.capabilityConstraint || relationship.attributeConstraint
		}
		return true
	}

	private def isConstraint(Relationship relationship) {
		if (relationship.relationshipLink.size > 1) {
			return false
		} else if (!relationship.relationshipLink.head.direction.equals(RelationshipDirection::UNDIRECTED)) {
			return false
		}

		return true
	}

	private def isCapabilityConstraint(Relationship relationship) {
		if (!isConstraint(relationship)) {
			return false
		}
		val subject = relationship.relationshipLink.head.subject
		if (!(subject instanceof Capability)) {
			return false
		}
		return true
	}

	private def isAttributeConstraint(Relationship relationship) {
		val subject = relationship.relationshipLink.head.subject
		if (!(subject instanceof Attribute)) {
			return false
		}
		return true
	}
}
