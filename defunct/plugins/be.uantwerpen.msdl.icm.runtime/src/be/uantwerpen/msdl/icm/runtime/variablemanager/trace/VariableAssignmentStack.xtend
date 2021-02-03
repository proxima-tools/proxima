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

package be.uantwerpen.msdl.icm.runtime.variablemanager.trace

import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager
import be.uantwerpen.msdl.processmodel.pm.AutomatedActivity
import com.google.common.collect.Lists
import java.util.List

class VariableAssignmentStack {
	List<AssigmentRecord> stack = Lists::newArrayList

	def add(AssigmentRecord assigmentRecord) {
		this.stack.add(assigmentRecord)
	}

	def undo(int steps) {
		val records = stack.reverse.take(steps)
		records.forEach [ record |
			val variable = VariableManager.instance.variableStore.variables.findFirst [ v |
				v.name.equals(record.variableModification.variableName)
			]
			variable.value = record.variableModification.previousValue
		]
	}

	def undoUntil(AutomatedActivity activity) {
		val index = stack.reverse.indexOf(activity)
		undo(index)
	}
}
