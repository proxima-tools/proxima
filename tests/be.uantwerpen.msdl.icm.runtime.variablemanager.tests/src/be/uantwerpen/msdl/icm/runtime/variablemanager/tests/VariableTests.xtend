package be.uantwerpen.msdl.icm.runtime.variablemanager.tests

import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager
import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.ExpressionMapper
import be.uantwerpen.msdl.icm.runtime.variablemanager.model.Relationship2
import be.uantwerpen.msdl.icm.runtime.variablemanager.operators.Operators
import be.uantwerpen.msdl.processmodel.properties.PropertiesFactory
import net.objecthunter.exp4j.Expression
import net.objecthunter.exp4j.ExpressionBuilder
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test

class VariableTests {

	extension VariableManager variableManager = VariableManager.instance

	private var Expression total
	private var Expression platform
	private var Expression motor
	private var Expression battery
	private var Relationship2 relationship

	@Before
	def void setUp() {
		total = new ExpressionBuilder("platform + motor + battery").variables("platform", "motor", "battery").build
		platform = new ExpressionBuilder("total - (motor + battery)").variables("total", "motor", "battery").build
		motor = new ExpressionBuilder("total - (platform + battery)").variables("total", "platform", "battery").build
		battery = new ExpressionBuilder("total - (platform + motor)").variables("total", "platform", "motor").build

		relationship = new Relationship2(total, platform, motor, battery)
		variableManager.addRelationship(PropertiesFactory.eINSTANCE.createRelationship, relationship)
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

	@Test
	def void mappingTest() {
		val mapper = new ExpressionMapper
		val vars = mapper.extractExpression("a + b - c = 0")

		Assert.assertEquals("a", vars.variableNames.get(0))
		Assert.assertEquals("b", vars.variableNames.get(1))
		Assert.assertEquals("c", vars.variableNames.get(2))
	}
}
