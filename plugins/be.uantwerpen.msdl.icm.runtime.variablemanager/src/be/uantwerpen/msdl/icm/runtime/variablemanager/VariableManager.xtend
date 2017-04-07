package be.uantwerpen.msdl.icm.runtime.variablemanager

import be.uantwerpen.msdl.icm.runtime.inconsistencymanager.InconsistencyManager
import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.ExpressionMapper
import be.uantwerpen.msdl.icm.runtime.variablemanager.model.Relationship2
import be.uantwerpen.msdl.icm.runtime.variablemanager.model.Result
import be.uantwerpen.msdl.processmodel.properties.Relationship
import com.google.common.collect.Lists
import com.google.common.collect.Maps
import com.google.common.collect.Sets
import java.util.List
import java.util.Map
import java.util.Set
import net.objecthunter.exp4j.Expression
import org.eclipse.xtend.lib.annotations.Accessors

class VariableManager {
	private static VariableManager instance

	@Accessors(PUBLIC_GETTER) Map<Relationship, Relationship2> relationships = Maps::newHashMap

	def public static getInstance() {
		if (instance == null) {
			instance = new VariableManager
		}
		instance
	}

	private new() {
	}

	def addRelationships(List<Relationship> relationships) {
		this.relationships = new ExpressionMapper().map(relationships)
	}

	def addRelationship(Relationship relationship, Relationship2 relationship2) {
		this.relationships.put(relationship, relationship2)
	}

	def setVariable(String variableName, double value) {
		for (relationship : relationships.values) {
			for (expression : relationship.expressions) {
				for (varName : expression.variableNames) {
					if (varName.equals(variableName)) {
						expression.setVariable(variableName, value)
					}
				}
			}
		}
		checkExpressions()
	}

	def checkExpressions() {
		relationships.entrySet.forEach [ entry |
			entry.value.expressions.forEach [ e |
				if (e.validate.errors == null || e.validate.errors.empty) {
					if (e.evaluate != 0.0) {
						InconsistencyManager.reportError(entry.key, entry.value)
					}
				}
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

	def getBoundVariables() {
		var vars = Maps::newHashMap
		for (entry : relationships.entrySet) {
			for (expression : entry.value.expressions) {
				vars.putAll(expression.userVariables)
			}
		}

		vars
	}
}
