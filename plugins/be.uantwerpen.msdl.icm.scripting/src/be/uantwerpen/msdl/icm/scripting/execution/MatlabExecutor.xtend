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

package be.uantwerpen.msdl.icm.scripting.execution

import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager
import be.uantwerpen.msdl.icm.scripting.scripts.MatlabScript
import java.io.BufferedReader
import java.io.File
import java.io.FileReader
import java.util.regex.Pattern
import matlabcontrol.MatlabProxy
import org.eclipse.emf.common.util.EMap

class MatlabExecutor extends ParameterizedExecutor {

	val ASSIGNMENT = "varname\\s*=\\s*[0-9]*"

	def execute(MatlabScript script, MatlabProxy matlabProxy, EMap<String, String> parameters) {
		val file = new File(script.scriptLocation)

		try {
			val bufferedReader = new BufferedReader(new FileReader(file))
			var String line = ""

			while ((line = bufferedReader.readLine()) != null) {
				line = line.resolveParameters(parameters)

				matlabProxy.eval(line)

				line.extractAssignments
			}
		} catch (Exception e) {
			e.printStackTrace
		}
	}

	def extractAssignments(String line) {
		val variableManager = VariableManager.instance

		for (variable : variableManager.variableStore.variables) {
			val pattern = ASSIGNMENT.replace('varname', variable.name)
			val matches = Pattern.compile(pattern).matcher(line)
			while (matches.find) {
				val split = matches.group.split("=").toList
				val varname = split.head
				val value = new Double(split.last)

				variableManager.setVariable(varname, value)
			}
		}
	}

}
