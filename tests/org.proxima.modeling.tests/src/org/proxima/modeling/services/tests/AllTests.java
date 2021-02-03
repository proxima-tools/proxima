package org.proxima.modeling.services.tests;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;
import org.proxima.modeling.services.tests.services.LinkUnsetTests;
import org.proxima.modeling.services.tests.validation.ValidationRequiredNameTests;
import org.proxima.modeling.services.tests.validation.ValidationTopologyTests;
import org.proxima.modeling.services.tests.validation.ValidationUniqueNameTests;

@RunWith(Suite.class)
@SuiteClasses({ LinkUnsetTests.class, ValidationRequiredNameTests.class, ValidationTopologyTests.class,
		ValidationUniqueNameTests.class, })
public class AllTests {

}
