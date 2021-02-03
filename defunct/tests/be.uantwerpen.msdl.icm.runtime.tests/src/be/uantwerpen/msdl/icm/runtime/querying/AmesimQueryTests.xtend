package be.uantwerpen.msdl.icm.runtime.querying

import be.uantwerpen.msdl.processmodel.properties.PropertiesFactory
import org.junit.After
import org.junit.Before
import org.junit.Test
import be.uantwerpen.msdl.processmodel.pm.PmFactory
import be.uantwerpen.msdl.processmodel.properties.IntentType

class AmesimQueryTests {

	@Before
	def void setUp() {
	}

	@After
	def void tearDown() {
	}

	@Test
	def void queryAttribute() {
		val activity = PmFactory.eINSTANCE.createAutomatedActivity

		val electricalModel = PmFactory.eINSTANCE.createObject
		electricalModel.name = "electricalModel"
		val otherModel = PmFactory.eINSTANCE.createObject
		otherModel.name = "otherModel"

		activity.dataFlowFrom += #[electricalModel, otherModel]

		val tmaxAttribute = PropertiesFactory.eINSTANCE.createAttribute
		tmaxAttribute.name = "maximumTorque"
		tmaxAttribute.aliases = "controlModel: p; electricalModel: Tmax"
		
		val intent = PropertiesFactory.eINSTANCE.createIntent
		intent.type = IntentType::MODIFY
		
		intent.activity = activity
		intent.subject = tmaxAttribute

		val queryResult = new AmesimQuery(tmaxAttribute, activity).execute

		if (queryResult === null) {
			println("Couldn't retrieve variable")
		} else {
			println(queryResult)
		}
	}

}
