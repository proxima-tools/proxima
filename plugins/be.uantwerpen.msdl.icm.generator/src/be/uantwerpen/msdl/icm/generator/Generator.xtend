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

package be.uantwerpen.msdl.icm.generator

import be.uantwerpen.msdl.processmodel.ProcessModel
import com.google.common.base.Joiner
import com.google.common.collect.Sets
import java.io.File
import java.io.FileWriter
import java.util.Set
import java.util.regex.Pattern

class Generator {

	private FileWriter writer

	def doGenerate(ProcessModel processModel) {

		println("generating file")

		val location = processModel.codeGenProperties.get("location").replace("\\", "\\\\")
		val rootPackage = processModel.codeGenProperties.get("rootPackage")
		val fullPath = Joiner.on("\\\\").join(location, rootPackage.replace(".", "\\\\"))

		val file = new File(fullPath, "EnactmentConfiguration.java")
		file.parentFile.mkdirs
		writer = new FileWriter(file)

		writer.append('''
			package «rootPackage»;
			
			public class EnactmentConfiguration{
				«FOR v : processModel.extractVariables»
					public double «v»;
				«ENDFOR»
			}
		''')

		writer.close()
	}

	def extractVariables(ProcessModel processModel) {
		var Set<String> variables = Sets::newHashSet
		for (relationship : processModel.propertyModel.relationship) {
			variables += relationship.formula.definition.extractVariables
		}
		variables
	}

	// FIXME this is almost a duplicate of be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.ExpressionMapper.xtend#extractExpression
	def extractVariables(String formulaDefinition) {
		val lhs = formulaDefinition.split('=').head
		val rhs = formulaDefinition.split('=').last

		var Set<String> variables = Sets::newHashSet
		val matches = Pattern.compile("[a-zA-Z_]+[a-zA-Z0-9_]*").matcher(lhs + " " + rhs)
		while (matches.find) {
			variables += matches.group
		}
		variables
	}

}
