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

import org.eclipse.emf.common.util.EMap

class ParameterizedExecutor {

	val BYNUMBER_NAME_PATTERN = "\\%\\{args\\[i\\].name\\}\\%"
	val BYNUMBER_VALUE_PATTERN = "\\%\\{args\\[i\\].value\\}\\%"
	val BYNAME_NAME_PATTERN = "\\%\\{args\\['n'\\].name\\}\\%"
	val BYNAME_VALUE_PATTERN = "\\%\\{args\\['n'\\].value\\}\\%"

	def resolveParameters(String command, EMap<String, String> parameters) {
		var String newCommand = ""

		for (parameter : parameters) {
			val key = parameter.key
			val value = parameter.value
			val index = parameters.indexOfKey(key)

			newCommand = command.replaceAll(BYNUMBER_NAME_PATTERN.replace('i', index.toString), key)
			newCommand = newCommand.replaceAll(BYNUMBER_VALUE_PATTERN.replace('i', index.toString), value)
			newCommand = newCommand.replaceAll(BYNAME_NAME_PATTERN.replaceFirst('n', key), key)
			newCommand = newCommand.replaceAll(BYNAME_VALUE_PATTERN.replaceFirst('n', key), value)
		}

		newCommand
	}
}
