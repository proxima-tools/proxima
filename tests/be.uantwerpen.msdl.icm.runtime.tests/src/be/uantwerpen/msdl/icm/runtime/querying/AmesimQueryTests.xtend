package be.uantwerpen.msdl.icm.runtime.querying

import be.uantwerpen.msdl.processmodel.properties.PropertiesFactory
import org.junit.After
import org.junit.Before
import org.junit.Test

class AmesimQueryTests {

	@Before
	def void setUp() {
	}

	@After
	def void tearDown() {
	}

	@Test
	def void queryAttribute() {
		val tmaxAttribute = PropertiesFactory.eINSTANCE.createAttribute
		tmaxAttribute.name = "Tmax1"

		val queryResult = new AmesimQuery(tmaxAttribute).execute

		if (queryResult === null) {
			println("Couldn't retrieve variable")
		} else {
			println(queryResult)
		}
	}

}
