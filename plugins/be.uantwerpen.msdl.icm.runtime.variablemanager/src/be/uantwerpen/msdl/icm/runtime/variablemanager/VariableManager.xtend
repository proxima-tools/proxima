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

import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.Relation
import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.ResultType
import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.SplitEquation
import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.Variable
import be.uantwerpen.msdl.processmodel.properties.PropertyModel
import be.uantwerpen.msdl.processmodel.properties.Relationship
import com.google.common.base.Preconditions
import com.google.common.collect.Lists
import com.google.common.collect.Sets
import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.File
import java.io.FileWriter
import java.io.InputStreamReader
import java.util.List
import java.util.Set
import java.util.regex.Pattern
import org.eclipse.xtend.lib.annotations.Accessors
import org.apache.log4j.Logger
import org.apache.log4j.Level

class VariableManager {
	
	private Logger logger = Logger.getLogger(this.class)
	
	val VARIABLE_PATTERN = "[a-zA-Z]+[a-zA-Z0-9]*"
	val INCONSISTENCY_ERROR_MSG = "AttributeError: 'EmptySet' object has no attribute 'evalf'"
	val INCONCLUSIVE_ERROR_MSG = "inequality has more than one symbol of interest"
	val INCONSISTENCY_MSG = "false"

	static VariableManager instance
	@Accessors(PUBLIC_GETTER) VariableStore variableStore

	public static def getInstance() {
		if (instance == null) {
			instance = new VariableManager		
		}

		instance
	}

	public def setup(PropertyModel propertyModel) {
		this.variableStore = new VariableStore(propertyModel)

		propertyModel.relationship.forEach [ relationship |
			val splitEquation = relationship.formula.definition.trasformEquation
			extractVariablesAndEquations(splitEquation, relationship)
		]
		
		this.logger.level = Level::DEBUG
	}

	private def SplitEquation trasformEquation(String equation) {
		Preconditions::checkNotNull(this.variableStore)

		val sanitizedEquation = equation.replace(' ', '')

		if (sanitizedEquation.contains('<=')) { // Le
			val split = sanitizedEquation.split('<=')
			return new SplitEquation(split.head, Relation::LE, split.last)
		} else if (sanitizedEquation.contains('<') && !sanitizedEquation.contains('=')) { // Lt
			val split = sanitizedEquation.split('<')
			return new SplitEquation(split.head, Relation::LT, split.last)
		} else if (sanitizedEquation.contains('>=')) { // Ge
			val split = sanitizedEquation.split('>=')
			return new SplitEquation(split.head, Relation::GE, split.last)
		} else if (sanitizedEquation.contains('>') && !sanitizedEquation.contains('=')) { // Gt
			val split = sanitizedEquation.split('>')
			return new SplitEquation(split.head, Relation::GT, split.last)
		} else if (sanitizedEquation.contains('=') && !sanitizedEquation.contains('<') &&
			!sanitizedEquation.contains('>')) { // Eq
			val split = sanitizedEquation.split('=')
			return new SplitEquation(split.head, Relation::EQ, split.last)
		}
	}

	def extractVariablesAndEquations(SplitEquation splitEquation, Relationship relationship) {
		Preconditions::checkNotNull(this.variableStore)

		// Variables
		var Set<Variable> variables = Sets::newHashSet
		val matches = Pattern.compile(VARIABLE_PATTERN).matcher(splitEquation.toString)
		while (matches.find) {
			variables.add(new Variable(matches.group, null))
		}
		variableStore.addVariables(variables)

		// Equations
		variableStore.addEquation(splitEquation, relationship)

		// Connection
		variableStore.associateEquationsWithVariables(splitEquation, variables)
	}

	def setVariable(String variableName, Double value) {
		Preconditions::checkNotNull(this.variableStore)

		variableStore.setVariable(variableName, value)
		evaluateExpressions();
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
}
