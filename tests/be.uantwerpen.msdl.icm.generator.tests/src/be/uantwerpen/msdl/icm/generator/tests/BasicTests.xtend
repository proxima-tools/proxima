package be.uantwerpen.msdl.icm.generator.tests

import be.uantwerpen.msdl.icm.generator.Generator
import be.uantwerpen.msdl.icm.tests.base.ProcessFileBasedTest
import org.junit.Test

class BasicTests extends ProcessFileBasedTest {
	
	@Test
	def void run(){
		new Generator().doGenerate(processModel)
	}	
}