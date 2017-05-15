package be.uantwerpen.msdl.icm.scripting

import be.uantwerpen.msdl.icm.scripting.execution.ParameterizedExecutor
import org.eclipse.emf.common.util.BasicEMap
import org.junit.Test

class ParametersTest {

	@Test
	def void run() {
		val pe = new ParameterizedExecutor

		val command2 = "%{args['platformMass'].name}%=100"
		val command3 = "platformMass=%{args['platformMass'].value}%"
		val command4 = "%{args[0].name}%=%{args[0].value}%"
		
		val parameters = new BasicEMap<String, String>()
		parameters.put("platformMass", "100")
		
		println(pe.resolveParameters(command2, parameters))
		println(pe.resolveParameters(command3, parameters))
		println(pe.resolveParameters(command4, parameters))
	}
}
