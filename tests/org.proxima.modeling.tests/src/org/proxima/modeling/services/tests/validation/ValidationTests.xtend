package org.proxima.modeling.services.tests.validation

import org.proxima.modeling.services.Validation
import org.junit.Rule
import org.junit.rules.ExternalResource

abstract class ValidationTests {
	enum Outcome {
		FAIL,
		PASS
	}

	protected var Validation validation

	@Rule
	public val ExternalResource externalResource = new ExternalResource() {
		override void before() throws Throwable {
			validation = new Validation()
		}

		override void after() {
			validation = null
		}
	};
}
