package be.uantwerpen.msdl.icm.simulink.tests

import com.mathworks.engine.MatlabEngine
import org.junit.Test

class ConnectionManagerTest {

	@Test
	public def void run() {
		val engine = MatlabEngine.startMatlab

		var engineIDs = MatlabEngine.findMatlab
		println(if (!engineIDs.empty) {
			engineIDs.head
		} else {
			'no shared session'
		})

		engine.eval("matlab.engine.shareEngine('engine001')")

		engineIDs = MatlabEngine.findMatlab
		println(if (!engineIDs.empty) {
			engineIDs.head
		} else {
			'no shared session'
		})

		engine.close

		engineIDs = MatlabEngine.findMatlab
		println(if (!engineIDs.empty) {
			engineIDs.head
		} else {
			'no shared session'
		})
		val engine2 = MatlabEngine.connectMatlab('engine001')

		engineIDs = MatlabEngine.findMatlab
		println(if (!engineIDs.empty) {
			engineIDs.head
		} else {
			'no shared session'
		})
	}
}
