package be.uantwerpen.msdl.icm.runtime.variablemanager.model

import com.google.common.collect.Lists
import java.util.List
import net.objecthunter.exp4j.Expression
import org.eclipse.xtend.lib.annotations.Accessors

class Relationship2 {
	@Accessors(PUBLIC_GETTER, PRIVATE_SETTER) List<Expression> expressions = Lists::newArrayList

	new(List<Expression> expressions) {
		this.expressions = expressions
	}

	new(Expression expression) {
		this.expressions += expression
	}

	new(Expression... expression) {
		this.expressions += expression
	}

	def addExpression(Expression expression) {
		this.expressions += expression
	}

	def addExpressions(List<Expression> expressions) {
		this.expressions += expressions
	}
}
