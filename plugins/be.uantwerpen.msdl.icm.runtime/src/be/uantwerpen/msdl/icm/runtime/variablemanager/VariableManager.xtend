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

import be.uantwerpen.msdl.icm.commons.bl.Relationships
import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.Relation
import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.ResultType
import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.SplitEquation
import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.Variable
import be.uantwerpen.msdl.processmodel.properties.Capability
import be.uantwerpen.msdl.processmodel.properties.PropertyModel
import be.uantwerpen.msdl.processmodel.properties.Relationship
import com.google.common.base.Preconditions
import com.google.common.base.Strings
import com.google.common.collect.Lists
import com.google.common.collect.Sets
import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.File
import java.io.FileWriter
import java.io.InputStreamReader
import java.util.List
import java.util.Map
import java.util.Set
import java.util.regex.Pattern
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.xtend.lib.annotations.Accessors

class VariableManager {

	private Logger logger = Logger.getLogger(this.class)

	val VARIABLE_PATTERN = "[_a-zA-Z]+[_a-zA-Z0-9]*"
	val INCONSISTENCY_ERROR_MSG = "AttributeError: 'EmptySet' object has no attribute 'evalf'"
	val INCONCLUSIVE_ERROR_MSG = "inequality has more than one symbol of interest"
	val INCONSISTENCY_MSG = "false"
	val FINAL_SOLUTION = "final solution"

	private extension val Relationships = new Relationships

	static VariableManager instance
	@Accessors(PUBLIC_GETTER) VariableStore variableStore

	public static def getInstance() {
		if (instance === null) {
			instance = new VariableManager
		}

		instance
	}

	private new() {
	}

	public def setup(PropertyModel propertyModel) {
		this.variableStore = new VariableStore(propertyModel)

		// Relationships and constraints over attributes
		for (relationship : propertyModel.relationship.filter [ relationship |
			relationship.attributeConstraint || relationship.simpleRelationship
		]) {
			val splitEquation = relationship.trasformEquation
			extractVariablesAndEquations(splitEquation, relationship)
		}

		// Constraints over capabilities
		for (relationship : propertyModel.relationship.filter[relationship|relationship.capabilityConstraint]) {
			val splitEquation = relationship.trasformEquation
			extractEquationsForCapabilities(splitEquation, relationship)
		}

//TODO
//		// Higher-order relationships
//		for (relationship : propertyModel.relationship.filter[relationship|relationship.higherOrderRelationship]) {
//		}
		this.logger.level = Level::DEBUG
	}

	private def SplitEquation trasformEquation(Relationship relationship) {
		Preconditions::checkNotNull(this.variableStore)
		Preconditions::checkNotNull(relationship.formula)
		Preconditions::checkNotNull(relationship.formula.definition)

		val equation = relationship.formula.definition

		val sanitizedEquation = equation.replace(' ', '')

		var SplitEquation splitEquation

		if (sanitizedEquation.contains('<=')) { // Le
			val split = sanitizedEquation.split('<=')
			splitEquation = new SplitEquation(split.head, Relation::LE, split.last)
		} else if (sanitizedEquation.contains('<') && !sanitizedEquation.contains('=')) { // Lt
			val split = sanitizedEquation.split('<')
			splitEquation = new SplitEquation(split.head, Relation::LT, split.last)
		} else if (sanitizedEquation.contains('>=')) { // Ge
			val split = sanitizedEquation.split('>=')
			splitEquation = new SplitEquation(split.head, Relation::GE, split.last)
		} else if (sanitizedEquation.contains('>') && !sanitizedEquation.contains('=')) { // Gt
			val split = sanitizedEquation.split('>')
			splitEquation = new SplitEquation(split.head, Relation::GT, split.last)
		} else if (sanitizedEquation.contains('=') && !sanitizedEquation.contains('<') &&
			!sanitizedEquation.contains('>')) { // Eq
			val split = sanitizedEquation.split('=')
			splitEquation = new SplitEquation(split.head, Relation::EQ, split.last)
		}

		if (!Strings.isNullOrEmpty(relationship.name)) {
			splitEquation.name = relationship.name
		}

		return splitEquation
	}

	def extractVariablesAndEquations(SplitEquation splitEquation, Relationship relationship) {
		Preconditions::checkNotNull(this.variableStore)

		// Variables
		var variables = splitEquation.variables
		variableStore.addVariables(variables)

		// Equations
		variableStore.addEquation(splitEquation, relationship)

		// Connection
		variableStore.associateEquationsWithVariables(splitEquation, variables)
	}

	def extractEquationsForCapabilities(SplitEquation splitEquation, Relationship relationship) {
		Preconditions::checkNotNull(this.variableStore)

		// Variables
		var capabilityVariables = splitEquation.variables

		var List<SplitEquation> equations = Lists::newArrayList(splitEquation)

		for (cVar : capabilityVariables) {
			val capability = relationship.relationshipLink.findFirst[link|link.subject.name.equals(cVar.name)].
				subject as Capability
			val typedAttributes = capability.types

			var newEquations = Lists::newArrayList
			var oldEquations = Sets::newHashSet

			for (oldEquation : equations) {
				for (aVar : typedAttributes) {
					val lhs = oldEquation.lhs.replace(cVar.name, aVar.name)
					val rhs = oldEquation.rhs.replace(cVar.name, aVar.name)
					val newEquation = new SplitEquation(lhs, splitEquation.relation, rhs)
					newEquations.add(newEquation)
				}
				oldEquations.add(oldEquation)
			}

			equations.addAll(newEquations)
			equations.removeAll(oldEquations)
		}

		// Equations
		for (eq : equations) {
			variableStore.addEquation(eq)
		}

		// Connection
		for (eq : equations) {
			var Set<Variable> variables = eq.variables
			variableStore.associateEquationsWithVariables(eq, variables)
		}
	}

	private def getVariables(SplitEquation splitEquation) {
		var Set<Variable> variables = Sets::newHashSet
		val matches = Pattern.compile(VARIABLE_PATTERN).matcher(splitEquation.toString)
		while (matches.find) {
			variables.add(new Variable(matches.group, null))
		}
		variables
	}

	def setVariables(Map<String, Double> values) {
		Preconditions::checkNotNull(this.variableStore)

		values.forEach [ name, value |
			variableStore.setVariable(name, value)
		]
		evaluateExpressions2();
	}

	def setVariable(String variableName, Double value) {
		Preconditions::checkNotNull(this.variableStore)

		variableStore.setVariable(variableName, value)
		evaluateExpressions2();
	}

	def evaluateExpressions() {
		Preconditions::checkNotNull(this.variableStore)

		val file = File.createTempFile("evaluateExpressions", ".py")
		file.deleteOnExit()
		val bufferedWriter = new BufferedWriter(new FileWriter(file))
		val scriptText = ScriptTemplates.generateSymPyScript(variableStore).toString
		bufferedWriter.write(scriptText)
		bufferedWriter.close();

		logger.debug(file.getAbsolutePath())
		logger.debug(scriptText)

		val runtime = Runtime.getRuntime();

		val process = runtime.exec("python " + file.getAbsolutePath());

		val bufferedReader = new BufferedReader(new InputStreamReader(process.inputStream));
		val errorReader = new BufferedReader(new InputStreamReader(process.errorStream));
		val result = evaluate(bufferedReader, errorReader)

		logger.debug(result);
	}

	def evaluateExpressions2() {
		Preconditions::checkNotNull(this.variableStore)

		val file = File.createTempFile("evaluateExpressions2", ".py")
		file.deleteOnExit()
		val bufferedWriter = new BufferedWriter(new FileWriter(file))
		val scriptText = ScriptTemplates2.generateSymPyScript(variableStore).toString
		bufferedWriter.write(scriptText)
		bufferedWriter.close();

		logger.debug(file.getAbsolutePath())
		logger.debug(scriptText)

		val runtime = Runtime.getRuntime();

		val process = runtime.exec("python " + file.getAbsolutePath());

		val bufferedReader = new BufferedReader(new InputStreamReader(process.inputStream));
		val errorReader = new BufferedReader(new InputStreamReader(process.errorStream));
		val result = evaluate2(bufferedReader, errorReader)

		logger.debug(result);
	}

	private def ResultType evaluate(BufferedReader standardReader, BufferedReader errorReader) {
		val stdLine = standardReader.readLine();
		if (stdLine != null) {
			if (stdLine.equalsIgnoreCase(INCONSISTENCY_MSG)) {
				return ResultType.INCONSISTENT;
			} else {
				return ResultType.OK;
			}
		} else if (errorReader.readLine() != null) {
			val List<String> lines = Lists::newArrayList(errorReader.lines().toArray)
			if (lines.findFirst[line|line.contains(INCONCLUSIVE_ERROR_MSG)] != null) {
				return ResultType.INCONCLUSIVE;
			} else if (lines.findFirst[line|line.contains(INCONSISTENCY_ERROR_MSG)] != null) {
				return ResultType.INCONSISTENT;
			} else {
				return ResultType.INCONCLUSIVE;
			}
		}

		throw new IllegalArgumentException();
	}

	private def ResultType evaluate2(BufferedReader standardReader, BufferedReader errorReader) {
		if (standardReader.readLine() != null) {
			val List<String> lines = Lists::newArrayList(standardReader.lines().toArray)

			for (line : lines) {
				if (line.contains(FINAL_SOLUTION)) {
					val splits = line.split(':')
					Preconditions::checkArgument(splits.size == 2)
					val message = splits.last
					if (message.equalsIgnoreCase('False')) {
						return ResultType.INCONSISTENT
					}
				}
			}
		} else if (errorReader.readLine() != null) {
			val List<String> lines = Lists::newArrayList(errorReader.lines().toArray)
			if (lines.findFirst[line|line.contains(INCONCLUSIVE_ERROR_MSG)] != null) {
				return ResultType.INCONCLUSIVE;
			} else if (lines.findFirst[line|line.contains(INCONSISTENCY_ERROR_MSG)] != null) {
				return ResultType.INCONSISTENT;
			} else {
				return ResultType.INCONCLUSIVE;
			}
		}

		return ResultType.INCONCLUSIVE;
	}
}
