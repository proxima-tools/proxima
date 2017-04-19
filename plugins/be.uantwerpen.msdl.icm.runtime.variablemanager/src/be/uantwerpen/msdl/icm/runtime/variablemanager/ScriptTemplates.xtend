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

class ScriptTemplates {
	public static def generateSymPyScript(
		VariableStore variableStore) '''
		from __future__ import division
		from sympy import *
		
		#Variables and symbols
		«FOR variable : variableStore.variables»
			«variable.name» = symbols('«variable.name»')
		«ENDFOR»
		
		#Equations
		«FOR equation : variableStore.equations»
			eq«variableStore.equations.indexOf(equation)» = «equation.toSymPyString»
		«ENDFOR»
		
		#Substitutions
		«getEquations(variableStore)»
		
		#Solve
		print(solve([«FOR equation : variableStore.equations SEPARATOR ', '»eq«variableStore.equations.indexOf(equation)»«ENDFOR»]))
	'''

	private static def toSymPyString(SplitEquation splitEquation) {
		switch (splitEquation.relation) {
			case LT: '''Lt(«splitEquation.lhs», «splitEquation.rhs»)'''
			case LE: '''Le(«splitEquation.lhs», «splitEquation.rhs»)'''
			case GT: '''Gt(«splitEquation.lhs», «splitEquation.rhs»)'''
			case GE: '''Ge(«splitEquation.lhs», «splitEquation.rhs»)'''
			case EQ: '''Eq(«splitEquation.lhs», «splitEquation.rhs»)'''
		}
	}

	private static def getEquations(VariableStore variableStore) {
		var substitutions = ''''''

		for (entry : variableStore.variablesInEquations.filter[variable, equations|variable.bound].entrySet) {
			for (eq : entry.value) {
				val index = variableStore.equations.indexOf(eq)
				substitutions +=
					'''eq«index» = eq«index».subs([(«entry.key.name», «variableStore.variables.findFirst[variable | variable.name.equals(entry.key.name)].value»)])
					'''
			}
		}

		substitutions
	}
}
