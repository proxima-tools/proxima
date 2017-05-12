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
import be.uantwerpen.msdl.processmodel.ftg.MatlabScript
import be.uantwerpen.msdl.processmodel.ftg.PythonScript
import be.uantwerpen.msdl.processmodel.ftg.Transformation
import be.uantwerpen.msdl.processmodel.properties.Precision
import be.uantwerpen.msdl.processmodel.properties.PropertyModel
import be.uantwerpen.msdl.processmodel.properties.Relationship
import be.uantwerpen.msdl.processmodel.properties.RelationshipDirection
import be.uantwerpen.msdl.processmodel.properties.RelationshipLink
import be.uantwerpen.msdl.processmodel.properties.RelationshipSubject
import com.google.common.collect.Lists
import be.uantwerpen.msdl.processmodel.ftg.Script

class Validation {

	private extension val Relationships = new Relationships

	new() {
	}

	public def consistentScriptExtension(Transformation transformation) {
		if(transformation.definition==null) return true
		if(!(transformation.definition instanceof Script)) return true
		
		val script = transformation.definition as Script
		
		switch script {
			PythonScript: return script.location.endsWith('.py')
			MatlabScript: return script.location.endsWith('.m')
		}
	}

	public def formulaOnlyInL3Relationship(Relationship relationship) {
		if (relationship.formula != null) {
			return relationship.precision.equals(Precision::L3)
		}
		return true
	}

	public def uniqueAttributeNames(RelationshipSubject relationshipSubject) {
		val propetyModel = relationshipSubject.eContainer as PropertyModel
		val subjects = Lists::newArrayList
		#[propetyModel.attribute, propetyModel.capability, propetyModel.relationship, propetyModel.property].forEach [ subject |
			subjects.addAll(subject)
		]

		return !subjects.filter[subject|!subject.name.empty].exists [ subject |
			subject.name.equalsIgnoreCase(relationshipSubject.name) && subject != relationshipSubject
		]
	}

	public def validRelationship(Relationship relationship) {
		if (relationship.isConstraint) {
			return true // checked in a separate rule
		} else if (relationship.isPropertyDefinitionRelationship) {
			return true // checked in a separate rule
		}

		// TODO add validation logic if required
		return true
	}

	public def validConstraint(Relationship relationship) {
		if (relationship.constraint) {
			return relationship.capabilityConstraint || relationship.attributeConstraint
		}

		// else don't care
		return true
	}

	public def validPropertyDefinitionRelationship(Relationship relationship) {
		if (relationship.isPropertyDefinitionRelationship) {
			// TODO add validation logic if required
			return true
		}

		// else don't care
		return true
	}

	public def noDirectedRelationshipLinks(RelationshipLink relationshipLink) {
		return relationshipLink.direction.equals(RelationshipDirection::UNDIRECTED)
	}

}
