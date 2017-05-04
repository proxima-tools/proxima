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

import be.uantwerpen.msdl.icm.commons.bl.Relationships
import be.uantwerpen.msdl.processmodel.properties.Relationship
import be.uantwerpen.msdl.processmodel.properties.RelationshipLink
import be.uantwerpen.msdl.processmodel.properties.RelationshipDirection

class Validation {

	private extension val Relationships = new Relationships

	new() {
	}

	public def validConstraint(Relationship relationship) {
		if (relationship.constraint) {
			return relationship.capabilityConstraint || relationship.attributeConstraint
		}
		return true
	}
	
	public def noDirectedRelationshipLinks(RelationshipLink relationshipLink){
		return relationshipLink.direction.equals(RelationshipDirection::UNDIRECTED)
	}

}
