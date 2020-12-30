package org.proxima.modeling.services.tests.validation

import be.uantwerpen.msdl.proxima.processmodel.ftg.FtgFactory
import java.util.Arrays
import java.util.Collection
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.junit.runners.Parameterized.Parameters

import static org.junit.Assert.assertFalse
import static org.junit.Assert.assertTrue

@RunWith(typeof(Parameterized))
class ValidationRequiredNameTests extends ValidationTests {

	@Parameters
	def static Collection<Object[]> failData() {
		return Arrays.asList(
			#[#[null, Outcome::FAIL], #["", Outcome::FAIL], #["someName", Outcome::PASS]]
		);
	}

	String name
	Outcome expectedOutcome

	new(String nameParameter, Outcome expectedOutcomeParameter) {
		name = nameParameter
		expectedOutcome = expectedOutcomeParameter
	}

	@Test
	def void testFormalismRequiresName() {
		val formalism = FtgFactory.eINSTANCE.createFormalism
		formalism.name = name

		if (expectedOutcome.equals(Outcome::PASS)) {
			assertTrue(validation.formalismRequiresName(formalism))
		} else if (expectedOutcome.equals(Outcome::PASS)) {
			assertFalse(validation.formalismRequiresName(formalism))
		}
	}

	@Test
	def void testTransformationRequiresName() {
		val transformation = FtgFactory.eINSTANCE.createTransformation
		transformation.name = name

		if (expectedOutcome.equals(Outcome::PASS)) {
			assertTrue(validation.transformationRequiresName(transformation))
		} else if (expectedOutcome.equals(Outcome::PASS)) {
			assertFalse(validation.transformationRequiresName(transformation))
		}
	}
}
