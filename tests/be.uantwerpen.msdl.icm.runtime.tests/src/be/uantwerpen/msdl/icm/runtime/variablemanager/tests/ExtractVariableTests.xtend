package be.uantwerpen.msdl.icm.runtime.variablemanager.tests

import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager
import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableStore
import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.Relation
import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.SplitEquation
import be.uantwerpen.msdl.processmodel.properties.PropertiesFactory
import be.uantwerpen.msdl.processmodel.properties.RelationshipDirection
import org.junit.After
import org.junit.Before
import org.junit.Test

import static org.junit.Assert.*

class ExtractVariableTests {

	private VariableManager variableManager
	private VariableStore variableStore

	@Before
	def void setUp() {
		variableManager = VariableManager.instance
		variableManager.setup(PropertiesFactory.eINSTANCE.createPropertyModel)
		variableStore = variableManager.variableStore
	}

	@After
	def void tearDown() {
		variableStore = null
		variableManager = null
	}

	@Test
	def void attributeTest() {
		variableStore.variables.clear

		val testVariables = #["__a_", "b", "c"]

		val splitEquation = new SplitEquation(String::format("%s + %s", testVariables.get(0), testVariables.get(1)),
			Relation::LT, String::format("%s", testVariables.get(2)))
		variableManager.extractVariablesAndEquations(splitEquation, PropertiesFactory.eINSTANCE.createRelationship)

		// variables
		testVariables.forEach [ testVar |
			assertTrue(variableStore.variables.exists[v|v.name.equals(testVar)])
		]
		assertTrue(!variableStore.variables.exists[v|!(testVariables.contains(v.name))])

		// equations
		assertTrue(variableStore.equations.size == 1)
		assertTrue(variableStore.equations.contains(splitEquation))

		// associations
		testVariables.forEach [ testVar |
			assertTrue(variableStore.variablesInEquations.keySet.exists[v|v.name.equals(testVar)])
		]
		assertTrue(!variableStore.variablesInEquations.keySet.exists[v|!(testVariables.contains(v.name))])
		variableStore.variablesInEquations.values.forEach [ v |
			assertTrue(v.size == 1)
			assertTrue(v.head.equals(splitEquation))
		]
	}

	@Test
	def void capabilityTest() {
		variableManager.variableStore.variables.clear

		val testCapabilities = #["x"]
		val testTypedAttributes = #["a", "b"]
		val splitEquation = new SplitEquation("x", Relation::GT, "0")

		val extension factory = PropertiesFactory.eINSTANCE

		val relationship = createRelationship
		// Ensure relationship is a constraint
		val relationshipLink = createRelationshipLink
		relationship.relationshipLink += relationshipLink
		relationshipLink.direction = RelationshipDirection::UNDIRECTED
		// Ensure it's a CAPABILITY constraint
		val capability = createCapability
		relationshipLink.subject = capability
		capability.name = "x"
		// Add typing
		val attributeA = createAttribute
		val attributeB = createAttribute
		attributeA.typedBy = capability
		attributeA.name = "a"
		attributeB.typedBy = capability
		attributeB.name = "b"

		variableManager.extractEquationsForCapabilities(splitEquation, relationship)

		// variables
		assertTrue(variableStore.variables.empty)

		// equations
		assertTrue(variableStore.equations.size == 2)
		assertTrue(variableStore.equations.exists[eq|eq.lhs.contains("a")])
		assertTrue(variableStore.equations.exists[eq|eq.lhs.contains("b")])

		// associations
		testTypedAttributes.forEach [ testAttr |
			assertTrue(variableStore.variablesInEquations.keySet.exists[v|v.name.equals(testAttr)])
		]
		assertTrue(!variableStore.variablesInEquations.keySet.exists[v|!(testTypedAttributes.contains(v.name))])
		variableStore.variablesInEquations.entrySet.forEach [ entry |
			assertTrue(entry.value.size == 1)
			assertTrue(entry.value.head.toString.contains(entry.key.name))
		]
	}
}
