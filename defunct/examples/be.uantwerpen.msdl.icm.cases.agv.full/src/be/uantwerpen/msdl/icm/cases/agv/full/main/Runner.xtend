package be.uantwerpen.msdl.icm.cases.agv.full.main

import be.uantwerpen.msdl.icm.runtime.CommandInterpreter
import be.uantwerpen.msdl.icm.runtime.EnactmentManager
import be.uantwerpen.msdl.icm.runtime.scripting.scripts.IScript
import com.google.common.collect.Lists
import java.io.File
import java.util.List
import org.junit.Test

class Runner {
	private static final val String TEST_FILE_LOCATION = "D:\\GitHub\\msdl\\ICM\\examples\\be.uantwerpen.msdl.icm.cases.demo\\process\\process.processmodel"

	@Test
	def void run() {
		val enactmentManager = new EnactmentManager(new File(TEST_FILE_LOCATION), getScripts());
		new CommandInterpreter(enactmentManager).interpret();
	}

	private def List<Class<? extends IScript>> getScripts() {
		Lists::newArrayList
	}
}
