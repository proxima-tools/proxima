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
import be.uantwerpen.msdl.processmodel.ftg.JavaBasedActivityDefinition
import be.uantwerpen.msdl.processmodel.ftg.Transformation
import be.uantwerpen.msdl.processmodel.pm.AutomatedActivity
import com.google.common.base.Joiner
import java.io.File
import java.io.FileWriter
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.xtend.lib.annotations.Accessors

class Generator {

	@Accessors(NONE) val Logger logger = Logger.getLogger(this.class)
	@Accessors(NONE) var String location
	@Accessors(NONE) var String rootPackage
	@Accessors(NONE) var String fullPath

	def doGenerate(ProcessModel processModel) {
		logger.level = Level::DEBUG
		logger.debug("generating artifacts")

		val l = processModel.codeGenProperties.get("location")

		location = if (l !== null) {
			l.replace("\\", "\\\\")
		} else {
			val srcgenFolder = processModel.eResource.URI.trimSegments(2).appendSegment("src-gen")
			srcgenFolder.toString.substring(srcgenFolder.toString.indexOf(':')).substring(2).replace("/", "\\\\") // XXX
		}

		rootPackage = processModel.codeGenProperties.get("rootPackage")
		fullPath = location.appendToPath(rootPackage)

		processModel.generateScripts
	}

	private def generateScripts(ProcessModel processModel) {
		logger.debug("generating scripts")

		val ftg = processModel.ftg
		if (ftg === null) {
			return
		}

		ftg.transformation.filter[transformation|transformation.definition instanceof JavaBasedActivityDefinition].
			forEach [ t |
				t.generateScript
			]

		val pm = processModel.process
		if (pm === null) {
			return
		}

		pm.head.node.filter[node|node instanceof AutomatedActivity].map[node|node as AutomatedActivity].filter [ activity |
			activity.typedBy !== null && activity.typedBy.definition instanceof JavaBasedActivityDefinition
		].forEach [ activity |
			activity.generateScript
		]
	}

	private def generateScript(Transformation transformation) {
		logger.debug(String::format("generating script for transformation %s", transformation.name))

		val path = fullPath.appendToPath('scripts')

		val file = new File(path, transformation.name.toFirstUpper + ".java")
		file.parentFile.mkdirs
		val writer = new FileWriter(file)

		val className = transformation.name.toFirstUpper

		writer.append('''
			package «rootPackage».scripts;
			
			import org.apache.log4j.Level;
			import java.util.Map;
			
			import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager;
			import be.uantwerpen.msdl.icm.runtime.scripting.scripts.JavaBasedScript;
			
			public class «className» extends JavaBasedScript{
				
				public «className»() {
					logger.setLevel(Level.DEBUG);
					logger.debug("Executing " + this.getClass().getSimpleName());
				}
				
				@Override
				public void run() {
					//TODO Auto-generated definition
				}
				
				public void runWithParameters(Map<Object, Object> parameters) {
					//TODO Handle parameters
					
					this.run();
				}
			}
		''')

		writer.close()
	}

	private def generateScript(AutomatedActivity activity) {
		if (activity.typedBy == null) {
			return
		}
		logger.debug(String::format("generating script for activity %s", activity.name))

		val path = fullPath.appendToPath('scripts')

		val file = new File(path, activity.name.toFirstUpper + ".java")
		file.parentFile.mkdirs
		val writer = new FileWriter(file)

		val className = activity.name.toFirstUpper
		val typeClassName = activity.typedBy.name.toFirstUpper
		val typeInstanceName = activity.typedBy.name.toFirstLower

		writer.append('''
			package «rootPackage».scripts;
			
			import org.apache.log4j.Level;
			import java.util.Map;
			import com.google.common.collect.Maps;
			
			import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager;
			import be.uantwerpen.msdl.icm.runtime.scripting.scripts.JavaBasedScript;
			
			public class «className» extends JavaBasedScript{
				
				private Map<Object, Object> parameters = Maps.newHashMap();
				
				//Constructor
				public «className»() {
					«IF !activity.executionParameters.empty»
						«FOR parameter : activity.executionParameters»
							parameters.put("«parameter.key»", "«parameter.value»");
						«ENDFOR»
					«ENDIF»
				}
				
				@Override
				public void run() {
					logger.setLevel(Level.DEBUG);
					logger.debug("Executing " + this.getClass().getSimpleName());
					
					«typeClassName» «typeInstanceName» = new «typeClassName»();
					
					«typeInstanceName».runWithParameters(parameters);
				}
			}
		''')

		writer.close()
	}

	private def appendToPath(String path, String suffix) {
		Joiner.on("\\\\").join(path, suffix.replace(".", "\\\\"))
	}
}
