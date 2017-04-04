package be.uantwerpen.msdl.icm.runtime.variablemanager.tests

import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager
import be.uantwerpen.msdl.icm.runtime.variablemanager.model.Relationship
import net.objecthunter.exp4j.Expression
import net.objecthunter.exp4j.ExpressionBuilder
import org.junit.After
import org.junit.Before
import org.junit.Test
import be.uantwerpen.msdl.icm.runtime.variablemanager.operators.Operators

class VariableTests {

	extension VariableManager variableManager = new VariableManager

	private var Expression total
	private var Expression platform
	private var Expression motor
	private var Expression battery
	private var Relationship relationship

	@Before
	def void setUp() {
		total = new ExpressionBuilder("platform + motor + battery").variables("platform", "motor", "battery").build
		platform = new ExpressionBuilder("total - (motor + battery)").variables("total", "motor", "battery").build
		motor = new ExpressionBuilder("total - (platform + battery)").variables("total", "platform", "battery").build
		battery = new ExpressionBuilder("total - (platform + motor)").variables("total", "platform", "motor").build

		relationship = new Relationship(total, platform, motor, battery)
		variableManager.addRelationship(relationship)
	}

	@After
	def void tearDown() {
		total = null
		platform = null
		motor = null
		battery = null
		relationship = null
	}

	@Test
	def void expressionTest() {
		println("expression tests")
		setVariable("platform", 100);
		setVariable("motor", 10);
//		setVariable("battery", 5);
		setVariable("total", 150);
		val result = evaluate(relationship);

		System.out.println(result.getVariableName() + " = " + result.getValue());
	}
	
	@Test
	def void operatorTest() {
		println("operator tests")
		val Expression exp = new ExpressionBuilder("a = 10").operator(Operators::eq).variables("a").build
		exp.setVariable("a", 10)
		val result = exp.evaluate

		System.out.println(result)
	}
}
