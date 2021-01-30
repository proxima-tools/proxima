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

package org.proxima.modeling.services

import org.proxima.commons.bl.Relationships
import org.proxima.ftg.Formalism
import org.proxima.ftg.FormalismTransformationGraph
import org.proxima.ftg.MatlabScript
import org.proxima.ftg.PythonScript
import org.proxima.ftg.Script
import org.proxima.ftg.Transformation
import org.proxima.pm.Activity
import org.proxima.pm.Final
import org.proxima.pm.Initial
import org.proxima.pm.Process
import org.proxima.properties.Attribute
import org.proxima.properties.IntentType
import org.proxima.properties.Precision
import org.proxima.properties.PropertyModel
import org.proxima.properties.Relationship
import org.proxima.properties.RelationshipDirection
import org.proxima.properties.RelationshipLink
import org.proxima.properties.RelationshipSubject
import com.google.common.base.Strings
import com.google.common.collect.Lists

class Validation {

	private extension val Relationships = new Relationships

	new() {
	}

	/**
	 * Naming rules
	 */
	def formalismRequiresName(Formalism formalism) {
		!formalism.name.nullOrEmpty
	}

	def transformationRequiresName(Transformation transformation) {
		!transformation.name.nullOrEmpty
	}

	def formalismNameUnique(Formalism formalism) {
		if(formalism.name.nullOrEmpty){
			return false
		}
		val ftg = formalism.eContainer as FormalismTransformationGraph
		!ftg.formalism.exists [ otherFormalism |
			!otherFormalism.equals(formalism) && otherFormalism.name.equalsIgnoreCase(formalism.name)
		]
	}

	def transformationNameUnique(Transformation transformation) {
		if(transformation.name.nullOrEmpty){
			return false
		}
		val ftg = transformation.eContainer as FormalismTransformationGraph
		!ftg.transformation.exists [ otherTransformation |
			!otherTransformation.equals(transformation) &&
				otherTransformation.name.equalsIgnoreCase(transformation.name)
		]
	}

	/**
	 * Topology rules
	 */
	def initNotDetached(Initial initNode) {
		initNode.controlIn.empty && initNode.controlOut.length == 1
	}

	def finalNotDetached(Final finalNode) {
		!finalNode.controlIn.empty && finalNode.controlOut.empty
	}

	def noDetachedActivity(Activity activity) {
		!activity.controlIn.empty && !activity.controlOut.empty
	}

	def initNodeExists(Process process) {
		process.node.exists[n|n instanceof Initial]
	}

	def finalNodeExists(Process process) {
		process.node.exists[n|n instanceof Final]
	}

	def processHasActivities(Process process) {
		process.node.exists[n|n instanceof Activity]
	}


////////////////CURRENTLY NOT USED////////////////

	public def consistentScriptExtension(Transformation transformation) {
		if(transformation.definition === null) return true
		if(!(transformation.definition instanceof Script)) return true

		val script = transformation.definition as Script

		switch script {
			PythonScript: return script.location.endsWith('.py')
			MatlabScript: return script.location.endsWith('.m')
		}
	}

	public def formulaOnlyInL3Relationship(Relationship relationship) {
		if (relationship.formula !== null) {
			return relationship.precision.equals(Precision::L3)
		}
		return true
	}

	public def L3EvaluationRequired(Relationship relationship) {
		if (relationship.precision.equals(Precision::L3)) {
			return (relationship.formula !== null) || (relationship.intent.exists[i|i.type.equals(IntentType::EVAL)]
		)
		} else
			return true
	}

	public def uniqueAttributeNames(RelationshipSubject relationshipSubject) {
		val propertyModel = relationshipSubject.eContainer as PropertyModel
		val subjects = Lists::newArrayList
		#[propertyModel.attribute, propertyModel.capability, propertyModel.relationship, propertyModel.property].forEach [ subject |
			subjects.addAll(subject)
		]

		return !subjects.filter[subject|(subject.name !== null && !subject.name.empty)].exists [ subject |
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

	public def directedL3RelationshipLink(RelationshipLink relationshipLink) {
		if ((relationshipLink.eContainer as Relationship).precision.equals(Precision::L3)) {
			val direction = relationshipLink.direction
			return direction.equals(RelationshipDirection::UNDIRECTED)
		} else {
			return true
		}
	}

	public def malformedFormedAliasList(Attribute attribute) {
		val listFormatPattern = "(((\\s)*[a-zA-Z0-9_-]+(\\s)*:(\\s)*[a-zA-Z0-9_-]+(\\s)*)(\\s)*;(\\s)*)*((\\s)*[a-zA-Z0-9_-]+(\\s)*:(\\s)*[a-zA-Z0-9_-]+(\\s)*)"
		if (Strings::isNullOrEmpty(attribute.aliases)) {
			return true
		}
		return attribute.aliases.trim.matches(listFormatPattern)
	}

/*
 * TODO shall we group by read-in/modify-out? 
 */
/*public def ambiguousAttributeDefinition(Intent intent) {
 * 	if (intent.type.equals(IntentType::EVAL)) {
 * 		return true
 * 	}
 * 	val dataIn = intent.activity.dataFlowFrom
 * 	val dataOut = intent.activity.dataFlowTo
 * 	val objects = (dataIn + dataOut).map[d|d as Object]

 * 	val tools = objects.map[o|(o.typedBy as Formalism).implementedBy].flatten.groupBy[it]

 * 	val toolSelectionIsUnambiguous = tools.size <= 1

 * 	if (toolSelectionIsUnambiguous) {
 * 		return true
 * 	}

 * 	return intent.object !== null
 }*/
}
