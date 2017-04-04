package be.uantwerpen.msdl.icm.runtime.variablemanager

import be.uantwerpen.msdl.icm.runtime.variablemanager.model.Relationship
import be.uantwerpen.msdl.icm.runtime.variablemanager.model.Result
import com.google.common.collect.Lists
import java.util.List
import net.objecthunter.exp4j.Expression
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList
import java.util.Set
import com.google.common.collect.Sets

class VariableManager {

	@Accessors(PUBLIC_GETTER) List<Relationship> relationships = Lists::newArrayList

	def addRelationship(Relationship relationship) {
		relationships += relationship
	}

	def setVariable(String variableName, double value) {
		relationships.forEach [r|
			r.expressions.forEach [ e |
				e.variableNames.forEach [ v |
					if (v.equals(variableName)) {
						e.setVariable(variableName, value)
					}
				]
			]
		]
	}

	def evaluate(Relationship relationship) throws Exception {
		var Expression assignedExpression = null

		for (expression : relationship.expressions) {
			if (expression.validate.errors == null || expression.validate.errors.empty) {
				if (assignedExpression == null) {
					assignedExpression = expression
				} else {
					throw new Exception("Causality hasn't been assigned yet.")
				}
			}
		}

		if (assignedExpression == null || assignedExpression.unboundVariables(relationship).size > 1) {
			throw new Exception("Causality hasn't been assigned yet.")
		}

		return new Result(assignedExpression.unboundVariables(relationship).head, assignedExpression.evaluate)
	}
	
	def unboundVariables(Expression expression, Relationship relationship) {
		var List<String> unboundVariables = Lists::newArrayList
		
		for (variableName : relationship.variableNames) {
			if (!expression.variables.containsKey(variableName)) {
				unboundVariables.add(variableName);
			}
		}

		return unboundVariables;
	}
	
	def getVariableNames(Relationship relationship) {
		var Set<String> variables = Sets::newHashSet
		for(expression : relationship.expressions){
			variables.addAll(expression.variableNames)
		}
		variables
	}
	
}
