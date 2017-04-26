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
import be.uantwerpen.msdl.processmodel.properties.Relationship
import be.uantwerpen.msdl.processmodel.properties.RelationshipDirection
import org.osgi.resource.Capability

class Relationships {
	def isConstraint(Relationship relationship) {
		if (relationship.relationshipLink.empty) {
			return false;
		} else if (relationship.relationshipLink.size > 1) {
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
