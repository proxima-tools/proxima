package be.uantwerpen.msdl.icm.runtime.variablemanager

import be.uantwerpen.msdl.icm.runtime.variablemanager.model.Relationship2
import be.uantwerpen.msdl.icm.runtime.variablemanager.model.Result
import be.uantwerpen.msdl.processmodel.properties.Relationship
import com.google.common.collect.Lists
import com.google.common.collect.Sets
import java.util.List
import java.util.Set
import net.objecthunter.exp4j.Expression
import org.eclipse.xtend.lib.annotations.Accessors
import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.ExpressionMapper

class VariableManager {

	@Accessors(PUBLIC_GETTER) List<Relationship2> relationships = Lists::newArrayList

	new() {
	}

	new(List<Relationship> relationships) {
		this.relationships = new ExpressionMapper().map(relationships)
	}

	def addRelationship(Relationship2 relationship) {
		relationships += relationship
	}

	def setVariable(String variableName, double value) {
		relationships.forEach [ r |
			r.expressions.forEach [ e |
				e.variableNames.forEach [ v |
					if (v.equals(variableName)) {
						e.setVariable(variableName, value)
					}
				]
			]
		]
	}

	def evaluate(Relationship2 relationship) throws Exception {
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

	def unboundVariables(Expression expression, Relationship2 relationship) {
		var List<String> unboundVariables = Lists::newArrayList

		for (variableName : relationship.variableNames) {
			if (!expression.variables.containsKey(variableName)) {
				unboundVariables.add(variableName);
			}
		}

		return unboundVariables;
	}

	def getVariableNames(Relationship2 relationship) {
		var Set<String> variables = Sets::newHashSet
		for (expression : relationship.expressions) {
			variables.addAll(expression.variableNames)
		}
		variables
	}

}
