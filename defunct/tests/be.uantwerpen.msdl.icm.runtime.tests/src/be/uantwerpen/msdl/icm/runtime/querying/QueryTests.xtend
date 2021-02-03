package be.uantwerpen.msdl.icm.runtime.querying

import be.uantwerpen.msdl.processmodel.pm.PmFactory
import be.uantwerpen.msdl.processmodel.properties.PropertiesFactory
import org.junit.After
import org.junit.Before
import org.junit.Test
import be.uantwerpen.msdl.processmodel.properties.IntentType

class QueryTests {

	@Before
	def void setUp() {
	}

	@After
	def void tearDown() {
	}

	@Test
	def void queryAttribute() {
		val activity = PmFactory.eINSTANCE.createAutomatedActivity

		val matlabModel = PmFactory.eINSTANCE.createObject
		matlabModel.name = "mechanicalModel"
		val otherModel = PmFactory.eINSTANCE.createObject
		otherModel.name = "otherModel"

		activity.dataFlowFrom += #[matlabModel, otherModel]

		val platformMassAttribute = PropertiesFactory.eINSTANCE.createAttribute
		platformMassAttribute.name = "platformMass"
		platformMassAttribute.aliases = "controlModel: p; mechanicalModel: MassP"
		
		val intent = PropertiesFactory.eINSTANCE.createIntent
		intent.type = IntentType::MODIFY
		
		intent.activity = activity
		intent.subject = platformMassAttribute		

		val queryResult = new MatlabQuery(platformMassAttribute, activity).execute

		if (queryResult === null) {
			println("Couldn't retrieve variable")
		} else {
			println(queryResult)
		}
	}

}
