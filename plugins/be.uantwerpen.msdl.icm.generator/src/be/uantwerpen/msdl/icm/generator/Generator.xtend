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
import be.uantwerpen.msdl.processmodel.ftg.Transformation
import be.uantwerpen.msdl.processmodel.pm.AutomatedActivity
import com.google.common.base.Joiner
import com.google.common.collect.Sets
import java.io.File
import java.io.FileWriter
import java.util.Set
import java.util.regex.Pattern
import org.apache.log4j.Logger
import org.eclipse.xtend.lib.annotations.Accessors

class Generator {

	@Accessors(NONE) val Logger logger = Logger.getLogger(this.class)
	@Accessors(NONE) var String location
	@Accessors(NONE) var String rootPackage
	@Accessors(NONE) var String fullPath

	def doGenerate(ProcessModel processModel) {

		logger.debug("generating artifacts")

		location = processModel.codeGenProperties.get("location").replace("\\", "\\\\")
		rootPackage = processModel.codeGenProperties.get("rootPackage")
		fullPath = location.appendToPath(rootPackage)

		processModel.generateScripts
	}

	private def generateScripts(ProcessModel processModel) {
		logger.debug("generating scripts")

		val ftg = processModel.ftg
		if (ftg == null) {
			return
		}

		ftg.transformation.forEach [ t |
			t.generateScript
		]

		val pm = processModel.process
		if (pm == null) {
			return
		}

		pm.head.node.filter[node|node instanceof AutomatedActivity].forEach [ a |
			(a as AutomatedActivity).generateScript
		]
	}

	private def generateScript(Transformation transformation) {
		logger.debug(String::format("generating script for transformation %s", transformation.name))

		val path = fullPath.appendToPath('scripts')

		val file = new File(path, transformation.name.toFirstUpper + ".java")
		file.parentFile.mkdirs
		val writer = new FileWriter(file)

		writer.append('''
			package «rootPackage».scripts;
			
			import org.apache.log4j.Level;
			import java.util.List;
			
			import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager;
			import be.uantwerpen.msdl.icm.scripting.scripts.JavaBasedScript;
			
			public class «transformation.name.toFirstUpper» extends JavaBasedScript{
				@Override
				public void run() {
					logger.setLevel(Level.DEBUG);
					logger.debug("Executing " + this.getClass().getSimpleName());
					
					//TODO Auto-generated definition
				}
				
				public void runWithParameters(List<Object> parameters) {
					logger.setLevel(Level.DEBUG);
					logger.debug("Executing " + this.getClass().getSimpleName());
					
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

		writer.
			append('''
				package «rootPackage».scripts;
				
				import org.apache.log4j.Level;
				«IF !activity.executionParameters.empty»
					import com.google.common.collect.Lists;
				«ENDIF»
				
				import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager;
				import be.uantwerpen.msdl.icm.scripting.scripts.JavaBasedScript;
				
				public class «activity.name.toFirstUpper» extends JavaBasedScript{
					
					«IF !activity.executionParameters.empty»
						«FOR parameter : activity.executionParameters»
							private Object «parameter.key» = "«parameter.value»";
						«ENDFOR»
					«ENDIF»
					
					@Override
					public void run() {
						logger.setLevel(Level.DEBUG);
						logger.debug("Executing " + this.getClass().getSimpleName());
						
						«activity.typedBy.name.toFirstUpper» «activity.typedBy.name.toFirstLower» = new «activity.typedBy.name.toFirstUpper»();
						
						«IF !activity.executionParameters.empty»
							«activity.typedBy.name».runWithParameters(Lists.newArrayList(«FOR parameter : activity.executionParameters SEPARATOR ", "»«parameter.key»«ENDFOR»));
						«ELSE»
							«activity.typedBy.name».run();
						«ENDIF»
					}
				}
			''')

		writer.close()
	}

	private def appendToPath(String path, String suffix) {
		Joiner.on("\\\\").join(path, suffix.replace(".", "\\\\"))
	}

	def extractVariables(ProcessModel processModel) {
		var Set<String> variables = Sets::newHashSet
		for (relationship : processModel.propertyModel.relationship) {
			variables += relationship.formula.definition.extractVariables
		}
		variables
	}

	// FIXME this is almost a duplicate of be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.ExpressionMapper.xtend#extractExpression
	def extractVariables(String formulaDefinition) {
		val lhs = formulaDefinition.split('=').head
		val rhs = formulaDefinition.split('=').last

		var Set<String> variables = Sets::newHashSet
		val matches = Pattern.compile("[a-zA-Z_]+[a-zA-Z0-9_]*").matcher(lhs + " " + rhs)
		while (matches.find) {
			variables += matches.group
		}
		variables
	}

}
