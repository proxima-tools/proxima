package be.uantwerpen.msdl.icm.generator

import be.uantwerpen.msdl.processmodel.ProcessModel
import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.processmodel.pm.Initial
import be.uantwerpen.msdl.processmodel.pm.Node
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Paths
import org.apache.log4j.Logger
import org.eclipse.xtend.lib.annotations.Accessors
import be.uantwerpen.msdl.processmodel.pm.Final
import be.uantwerpen.msdl.processmodel.pm.AutomatedActivity
import be.uantwerpen.msdl.processmodel.ftg.MatlabScript

class MatlabGenerator {

	val PLACEHOLDER = "%iteration-gen%"

	@Accessors(NONE) val Logger logger = Logger.getLogger(this.class)

	def doGenerate(ProcessModel processModel) {

		logger.debug("generating MATLAB artifacts")

		val location = processModel.codeGenProperties.get("location").replace("\\", "\\\\")

		val path = Paths.get(location)
		val charset = StandardCharsets.UTF_8
		val content = new String(Files.readAllBytes(path), charset)

		val newContent = content.replaceFirst(PLACEHOLDER, processModel.generateIterations)
		Files.write(path, newContent.getBytes(charset));
	}

	def String generateIterations(ProcessModel model) {
		var text = ''''''
		var Node current = model.init
		while(!(current.next instanceof Final)){
			current = current.next
			if(current instanceof AutomatedActivity){
				val path = Paths.get(((current as AutomatedActivity).typedBy.definition as MatlabScript).location)
				val charset = StandardCharsets.UTF_8
				val content = new String(Files.readAllBytes(path), charset)
				text += "\n"
				text += content
				text += "\n"
			}
		}
		
		text
	}

	def Initial getInit(ProcessModel processModel) {
		processModel.process.head.node.filter[n|n instanceof Initial].head as Initial
	}

	def Node getNext(Node node) {
		node.controlOut.head.to
	}

}
