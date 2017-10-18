package be.uantwerpen.msdl.icm.runtime.querying

import be.uantwerpen.msdl.processmodel.properties.PropertiesFactory
import org.junit.After
import org.junit.Before
import org.junit.Test

class QueryTests {

	@Before
	def void setUp() {
	}

	@After
	def void tearDown() {
	}

	@Test
	def void queryAttribute() {
		val platformMassAttribute = PropertiesFactory.eINSTANCE.createAttribute
		platformMassAttribute.name = "platformMass"

		val queryResult = new MatlabQuery(platformMassAttribute).execute

		if (queryResult === null) {
			println("Couldn't retrieve variable")
		} else {
			println(queryResult)
		}
	}

}
