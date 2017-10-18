/*******************************************************************************
 * Copyright (c) 2016-2017 Istvan David
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *    Istvan David - initial API and implementation
 *******************************************************************************/

package be.uantwerpen.msdl.icm.generator

import be.uantwerpen.msdl.processmodel.ProcessModel
import be.uantwerpen.msdl.processmodel.ftg.MatlabScript
import be.uantwerpen.msdl.processmodel.pm.AutomatedActivity
import be.uantwerpen.msdl.processmodel.pm.Decision
import be.uantwerpen.msdl.processmodel.pm.Final
import be.uantwerpen.msdl.processmodel.pm.Initial
import be.uantwerpen.msdl.processmodel.pm.Node
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

		val location = processModel.codeGenProperties.get("location").replace("\\", "\\\\")

		val path = Paths.get(location)
		val charset = StandardCharsets.UTF_8
		val content = new String(Files.readAllBytes(path), charset)
		val decision = processModel.process.head.node.filter[n|n instanceof Decision].head as Decision;
		val repeat = decision.repeat

		val newContent = content.replaceFirst(PLACEHOLDER, processModel.generateIterations(repeat))
		Files.write(path, newContent.getBytes(charset));
	}

	def String generateIterations(ProcessModel model, int repeat) {
		var i = 0;
		var text = ''''''
		for (; i < repeat; i++) {
			text += "\n\n\n"
			text += '''%ITERATION '''
			text += i+1
			text += '''%'''
			text += "\n"
			var Node current = model.init
			while (!(current.next instanceof Final)) {
				current = current.next
				if (current instanceof AutomatedActivity) {
					if (((current as AutomatedActivity).typedBy.definition instanceof MatlabScript)) {
						val path = Paths.get(
							((current as AutomatedActivity).typedBy.definition as MatlabScript).location)
						val charset = StandardCharsets.UTF_8
						val content = new String(Files.readAllBytes(path), charset)
						text += "\n"
						text += content
						text += "\n"
					}
				}
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
