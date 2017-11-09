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
import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.SplitEquation
import com.google.common.collect.Lists
import java.util.List

class ScriptTemplates2 {
	public static def generateSymPyScript(
		VariableStore variableStore) '''
		from __future__ import division
		from sympy import *
		from sympy.solvers.inequalities import solve_poly_inequality
		
		#Variables and symbols
		vars = symbols("«FOR variable : variableStore.variables SEPARATOR ' '»«variable.name»«ENDFOR»")
		«FOR variable : variableStore.variables SEPARATOR ', '»«variable.name»«ENDFOR»= vars
		
		#Equations
		eqs = [«FOR equation : variableStore.equations.withSubstitutions(variableStore) SEPARATOR ', '»«equation.toSymPyString»«ENDFOR»]
		
		«««		#Substitutions
«««		«getEquations(variableStore)»

		# all solutions for each var:
		for var in vars: # solve for every var
		    print("SOLVING FOR: " + str(var))
		    solution = solve(eqs, var) # this is the system of inequations, and substitutions will be executed in this variable
		    equations = filter(lambda c : isinstance(c, Eq), solution.args) # these are equations that are candidates for substitution; we only use equations, not inequations
		    final_equations = tuple() # equations will be added here that are part of the final solution, but are no candidate (anymore) for substitutions
		    while True: # still possibities for substitutions
		        # first select one of the substitution candidates
		        try:
		            equation = next(equations)
		        except StopIteration: # no more possibities for substitutions
		            break
		        # if the equation is in terms of the var (i.e., of the form "var = ..."), then it must be part of the final solutions
		        if equation.args[0] == var:
		            final_equations += (equation,)
		        # to substitute, we need all forms of the equation, solved for each of the variables except for the one we are looking for
		        # e.g., the equation mt = mb + mp + mm has the following substitution_equations for mt (in dict form):
		        #    [{mb : mt - mp - mm} , {mp : mt - mb - mm} , {mm : mt - mb - mp}]
		        # each of these equations can be used for substitution, by substituting resp. mb, mp or mm
		        substitution_equations = filter(lambda s : s != [], [solve([equation], symbol) for symbol in filter(lambda v : v != var, vars)])
		        # now substitute using each of the substitution equations
		        for substitution_equation in substitution_equations:
		            symbol = list(substitution_equation.keys())[0]
		            value = substitution_equation[symbol]
		            # go over all statements in the system to try to substitute
		            for statement in filter(lambda c : not c == equation, solution.args):
		                print("can we substitute " + str(substitution_equation) + " in " + str(statement) + "? --> ", end='')
		                new_statement = statement.subs({symbol: value})
		                # if a substitution occurred
		                if new_statement != statement:
		                    print(str(new_statement) + ".")
		                    # replace equation in solution
		                    solution = And(tuple(filter(lambda e : not e == statement, solution.args)) + (new_statement,))
		                    print("updated solution: " + str(solution))
		                else:
		                    print("No.")
		        # the current equation is now applied, so it should be removed to solution, so that we can find a different substitution candidate next iteration of the while loop
		        solution = And(tuple(filter(lambda e : not e == equation, solution.args)))
		        print("updated solution: " + str(solution))
		        equations = filter(lambda c : isinstance(c, Eq), solution.args)
		    # the final solution consists of the remaining solutions, and the saved equations in terms of var
		    # we solve the final solution again, just to make sure that it's in its simplified form
		    print("final solution:" + str(solve(And(solution.args + final_equations), var)))
		    print("")
	'''

	private static def withSubstitutions(List<SplitEquation> equations, VariableStore variableStore) {
		val List<SplitEquation> substitutedEquations = Lists::newArrayList(equations)

		for (key : variableStore.variablesInEquations.filter[variable, eqs|variable.bound].keySet) {
			val newEq = new SplitEquation(key.name, Relation::EQ, variableStore.variables.findFirst [ variable |
				variable.name.equals(key.name)
			].value.doubleValue.toString)
			substitutedEquations += newEq
		}

		substitutedEquations
	}

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
				var eq2 = eq
				eq2.lhs = eq2.lhs.replace(entry.key.name, variableStore.variables.findFirst [ variable |
					variable.name.equals(entry.key.name)
				].value.toString)
				eq2.rhs = eq2.rhs.replace(entry.key.name, variableStore.variables.findFirst [ variable |
					variable.name.equals(entry.key.name)
				].value.toString)
				substitutions += eq2
			}
		}

		substitutions
	}

	private static def getEquationName(SplitEquation equation, VariableStore variableStore) {
		if (equation.name.empty) {
			"eq" + variableStore.equations.indexOf(equation)
		} else {
			equation.name
		}
	}
}
