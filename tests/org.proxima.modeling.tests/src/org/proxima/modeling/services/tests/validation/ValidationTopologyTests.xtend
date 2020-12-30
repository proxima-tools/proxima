package org.proxima.modeling.services.tests.validation

import be.uantwerpen.msdl.proxima.modeling.services.Validation
import be.uantwerpen.msdl.proxima.processmodel.pm.PmFactory
import org.junit.After
import org.junit.Before
import org.junit.Test

import static org.junit.Assert.assertFalse
import static org.junit.Assert.assertTrue

class ValidationTopologyTests {

	var Validation validation

	@Before
	def void setUp() {
		validation = new Validation()
	}

	@After
	def void tearDown() {
		validation = null
	}

	@Test
	def void testInitNotDetachedNonEmptyInputs() {
		val init = PmFactory.eINSTANCE.createInitial
		val controlFlow = PmFactory.eINSTANCE.createControlFlow
		init.controlIn.add(controlFlow)
		assertFalse(validation.initNotDetached(init))
	}

	@Test
	def void testInitNotDetachedControlOuts() {
		val init = PmFactory.eINSTANCE.createInitial

		assertFalse(validation.initNotDetached(init))

		val controlFlow = PmFactory.eINSTANCE.createControlFlow
		init.controlOut.add(controlFlow)
		assertTrue(validation.initNotDetached(init))

		val controlFlow2 = PmFactory.eINSTANCE.createControlFlow
		init.controlOut.add(controlFlow2)
		assertFalse(validation.initNotDetached(init))
	}

	@Test
	def void testFinalNotDetachedNonEmptyOutputs() {
		val final = PmFactory.eINSTANCE.createFlowFinal
		val controlFlow = PmFactory.eINSTANCE.createControlFlow
		final.controlOut.add(controlFlow)
		assertFalse(validation.finalNotDetached(final))
	}

	@Test
	def void testFinalNotDetachedControlOuts() {
		val final = PmFactory.eINSTANCE.createFlowFinal

		assertFalse(validation.finalNotDetached(final))

		val controlFlow = PmFactory.eINSTANCE.createControlFlow
		final.controlIn.add(controlFlow)
		assertTrue(validation.finalNotDetached(final))

		val controlFlow2 = PmFactory.eINSTANCE.createControlFlow
		final.controlIn.add(controlFlow2)
		assertTrue(validation.finalNotDetached(final))
	}

	@Test
	def void testNoDetachedActivity() {
		val activity = PmFactory.eINSTANCE.createManualActivity

		assertFalse(validation.noDetachedActivity(activity))

		val controlFlow = PmFactory.eINSTANCE.createControlFlow
		activity.controlIn.add(controlFlow)
		assertFalse(validation.noDetachedActivity(activity))

		val controlFlow2 = PmFactory.eINSTANCE.createControlFlow
		activity.controlOut.add(controlFlow2)
		assertTrue(validation.noDetachedActivity(activity))
	}

	@Test
	def void testInitNodeExists() {
		val process = PmFactory.eINSTANCE.createProcess

		assertFalse(validation.initNodeExists(process))

		val init = PmFactory.eINSTANCE.createInitial
		process.node.add(init)
		assertTrue(validation.initNodeExists(process))
	}

	@Test
	def void testFinalNodeExists() {
		val process = PmFactory.eINSTANCE.createProcess

		assertFalse(validation.finalNodeExists(process))

		val final = PmFactory.eINSTANCE.createFlowFinal
		process.node.add(final)
		assertTrue(validation.finalNodeExists(process))
	}

	@Test
	def void testProcessHasActivities() {
		val process = PmFactory.eINSTANCE.createProcess

		assertFalse(validation.processHasActivities(process))

		val activity = PmFactory.eINSTANCE.createManualActivity
		process.node.add(activity)
		assertTrue(validation.processHasActivities(process))
	}
}
