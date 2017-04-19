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

package be.uantwerpen.msdl.icm.runtime.variablemanager

import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.SplitEquation
import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.Variable
import be.uantwerpen.msdl.processmodel.properties.Attribute
import be.uantwerpen.msdl.processmodel.properties.PropertyModel
import be.uantwerpen.msdl.processmodel.properties.Relationship
import com.google.common.collect.Lists
import com.google.common.collect.Maps
import com.google.common.collect.Sets
import java.util.List
import java.util.Map
import java.util.Set
import org.eclipse.xtend.lib.annotations.Accessors

class VariableStore {
	@Accessors(NONE) PropertyModel propertyModel
	@Accessors(PUBLIC_GETTER) Set<Variable> variables = Sets::newHashSet
	@Accessors(PUBLIC_GETTER) Map<Variable, Attribute> variableAttributeCorrespondance = Maps::newHashMap()
	@Accessors(PUBLIC_GETTER) List<SplitEquation> equations = Lists::newArrayList()
	@Accessors(PUBLIC_GETTER) Map<SplitEquation, Relationship> equationRelationshipCorrespondance = Maps::newHashMap()
	@Accessors(PUBLIC_GETTER) Map<Variable, Set<SplitEquation>> variablesInEquations = Maps::newHashMap()

	new(PropertyModel propertyModel) {
		this.propertyModel = propertyModel
	}

	def addVariable(Variable variable) {
		val v = variables.findFirst[v|v.equals(variable)]
		if (v != null) {
			return
		}
		variables.add(variable)
		variableAttributeCorrespondance.put(variable, propertyModel.attribute.findFirst [ attribute |
			attribute.name.equals(variable.name)
		])
	}

	def addVariable(String name, Double value) {
		addVariable(new Variable(name, value))
	}

	def addVariables(Set<Variable> variables) {
		variables.forEach [ variable |
			addVariable(variable)
		]
	}

	def setVariable(String name, Double value) {
		val variable = variables.findFirst[variable|variable.name.equals(name)]
		if (variable == null) {
			throw new IllegalArgumentException("Unknown variable")
		}
		variable.value = value
	}

	def addEquation(SplitEquation equation, Relationship relationship) {
		equations.add(equation)
		equationRelationshipCorrespondance.put(equation, relationship)
	}

	def associateEquationsWithVariables(SplitEquation equation, Set<Variable> variables) {
		variables.forEach [ v0 |
			val v = variables.findFirst[v|v.equals(v0)]
			val equationsForV = variablesInEquations.get(v)
			if (equationsForV == null) {
				variablesInEquations.put(v, Sets::newHashSet)
			}
			variablesInEquations.get(v).add(equation)
		]
	}

	def getBoundVariables() {
		variables.filter[variable|variable.isBound]
	}
}
