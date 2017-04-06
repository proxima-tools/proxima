package be.uantwerpen.msdl.icm.runtime.variablemanager.expressions

import be.uantwerpen.msdl.icm.runtime.variablemanager.model.Relationship2
import be.uantwerpen.msdl.processmodel.properties.Relationship
import com.google.common.base.Preconditions
import com.google.common.collect.Lists
import com.google.common.collect.Sets
import java.util.List
import java.util.Set
import java.util.regex.Pattern
import net.objecthunter.exp4j.ExpressionBuilder

class ExpressionMapper {

	def List<Relationship2> map(List<Relationship> relationships) {
		var List<Relationship2> translatedRelationships = Lists::newArrayList

		for (relationship : relationships) {
			val expression = extractExpression(relationship.formula.definition)
			translatedRelationships += new Relationship2(expression)
		}

		translatedRelationships
	}

	def extractExpression(String formulaDefinition) {
		val lhs = formulaDefinition.split('=').head
		val rhs = formulaDefinition.split('=').last

		Preconditions::checkArgument(Integer.parseInt(rhs.trim) == 0);

		var Set<String> variables = Sets::newHashSet
		val matches = Pattern.compile("[a-zA-Z]+[a-zA-Z0-9]*").matcher(lhs)
		while (matches.find) {
			variables += matches.group
		}

		new ExpressionBuilder(lhs).variables(variables).build();
	}
}
