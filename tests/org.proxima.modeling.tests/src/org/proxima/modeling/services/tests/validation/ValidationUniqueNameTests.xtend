package org.proxima.modeling.services.tests.validation

import org.proxima.ftg.FtgFactory
import java.util.Arrays
import java.util.Collection
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized
import org.junit.runners.Parameterized.Parameters

import static org.junit.Assert.assertFalse
import static org.junit.Assert.assertTrue

@RunWith(typeof(Parameterized))
class ValidationUniqueNameTests extends ValidationTests {

	@Parameters
	def static Collection<Object[]> failData() {
		return Arrays.asList(
			#[#[null, null, Outcome::FAIL], #[null, "", Outcome::FAIL], #["", "", Outcome::FAIL],
				#["someName", "someName", Outcome::FAIL], #["someName", "someOtherName", Outcome::PASS]]
		);
	}

	String name1
	String name2
	Outcome expectedOutcome

	new(String name1Parameter, String name2Parameter, Outcome expectedOutcomeParameter) {
		name1 = name1Parameter
		name2 = name2Parameter
		expectedOutcome = expectedOutcomeParameter
	}

	@Test
	def void testFormalismNameUniqueNullName() {
		val ftg = FtgFactory.eINSTANCE.createFormalismTransformationGraph

		val formalism1 = FtgFactory.eINSTANCE.createFormalism
		ftg.formalism.add(formalism1)

		val formalism2 = FtgFactory.eINSTANCE.createFormalism
		ftg.formalism.add(formalism2)

		if (expectedOutcome.equals(Outcome.FAIL)) {
			formalism1.name = name1
			formalism2.name = name2
			assertFalse(validation.formalismNameUnique(formalism1))
			assertFalse(validation.formalismNameUnique(formalism2))
			formalism1.name = name2
			formalism2.name = name1
			assertFalse(validation.formalismNameUnique(formalism1))
			assertFalse(validation.formalismNameUnique(formalism2))
		} else if (expectedOutcome.equals(Outcome.PASS)) {
			formalism1.name = name1
			formalism2.name = name2
			assertTrue(validation.formalismNameUnique(formalism1))
			assertTrue(validation.formalismNameUnique(formalism2))
			formalism1.name = name2
			formalism2.name = name1
			assertTrue(validation.formalismNameUnique(formalism1))
			assertTrue(validation.formalismNameUnique(formalism2))
		}
	}

	@Test
	def void testTransformationNameUniqueNullName() {
		val ftg = FtgFactory.eINSTANCE.createFormalismTransformationGraph

		val transformation1 = FtgFactory.eINSTANCE.createTransformation
		ftg.transformation.add(transformation1)

		val transformation2 = FtgFactory.eINSTANCE.createTransformation
		ftg.transformation.add(transformation2)

		if (expectedOutcome.equals(Outcome.FAIL)) {
			transformation1.name = name1
			transformation2.name = name2
			assertFalse(validation.transformationNameUnique(transformation1))
			assertFalse(validation.transformationNameUnique(transformation2))
			transformation1.name = name2
			transformation2.name = name1
			assertFalse(validation.transformationNameUnique(transformation1))
			assertFalse(validation.transformationNameUnique(transformation2))
		} else if (expectedOutcome.equals(Outcome.PASS)) {
			transformation1.name = name1
			transformation2.name = name2
			assertTrue(validation.transformationNameUnique(transformation1))
			assertTrue(validation.transformationNameUnique(transformation2))
			transformation1.name = name2
			transformation2.name = name1
			assertTrue(validation.transformationNameUnique(transformation1))
			assertTrue(validation.transformationNameUnique(transformation2))
		}
	}

}
