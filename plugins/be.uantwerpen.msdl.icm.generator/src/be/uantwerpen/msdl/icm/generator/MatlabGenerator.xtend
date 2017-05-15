package be.uantwerpen.msdl.icm.generator

import be.uantwerpen.msdl.processmodel.ProcessModel
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Paths
import org.apache.log4j.Logger
import org.eclipse.xtend.lib.annotations.Accessors

class MatlabGenerator {
	
	val PLACEHOLDER = "%iteration-gen%"

	@Accessors(NONE) val Logger logger = Logger.getLogger(this.class)

	def doGenerate(ProcessModel processModel) {

		logger.debug("generating MATLAB artifacts")

		val path = Paths.get("c:\\Users\\steve\\Documents\\MATLAB\\ManualSolutionGen.m")
		val charset = StandardCharsets.UTF_8
		val content = new String(Files.readAllBytes(path), charset)

		val newContent = content.replaceFirst(PLACEHOLDER, processModel.generateIterations)
		Files.write(path, newContent.getBytes(charset));
	}

	def String generateIterations(ProcessModel model) {
		"test"
	}

}
