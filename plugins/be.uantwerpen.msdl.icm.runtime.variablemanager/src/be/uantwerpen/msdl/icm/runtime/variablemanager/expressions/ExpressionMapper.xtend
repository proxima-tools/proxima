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

package be.uantwerpen.msdl.icm.runtime.variablemanager.expressions

import be.uantwerpen.msdl.icm.runtime.variablemanager.model.Relationship2
import be.uantwerpen.msdl.processmodel.properties.Relationship
import com.google.common.base.Preconditions
import com.google.common.collect.Maps
import com.google.common.collect.Sets
import java.util.List
import java.util.Map
import java.util.Set
import java.util.regex.Pattern
import net.objecthunter.exp4j.ExpressionBuilder

class ExpressionMapper {

	def Map<Relationship, Relationship2> map(List<Relationship> relationships) {
		var Map<Relationship, Relationship2> translatedRelationships = Maps::newHashMap

		for (relationship : relationships) {
			val expression = extractExpression(relationship.formula.definition)
			translatedRelationships.put(relationship, new Relationship2(expression))
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
