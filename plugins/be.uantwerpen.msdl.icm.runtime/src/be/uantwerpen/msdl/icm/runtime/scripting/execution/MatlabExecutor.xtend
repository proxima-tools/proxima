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

package be.uantwerpen.msdl.icm.runtime.scripting.execution

import be.uantwerpen.msdl.icm.runtime.scripting.connection.MatlabConnectionManager
import be.uantwerpen.msdl.icm.runtime.scripting.scripts.MatlabScript
import java.io.BufferedReader
import java.io.File
import java.io.FileReader
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Paths
import matlabcontrol.MatlabProxy
import org.eclipse.emf.common.util.EMap
import org.eclipse.xtend.lib.annotations.Accessors

enum ExecutionMode {
	NORMAL,
	HEADLESS
}

class MatlabExecutor extends ParameterizedExecutor {
	@Accessors(NONE) val DEFAULT_MODE = ExecutionMode::HEADLESS

	def execute(MatlabScript script, MatlabProxy matlabProxy, EMap<String, String> parameters,
		ExecutionMode executionMode) {
		switch (executionMode) {
			case NORMAL: executeWithGui(script, matlabProxy, parameters)
			case HEADLESS: executeHeadless(script, matlabProxy, parameters)
		}
	}

	def execute(MatlabScript script, MatlabProxy matlabProxy, EMap<String, String> parameters) {
		execute(script, matlabProxy, parameters, DEFAULT_MODE)
	}

	private def executeHeadless(MatlabScript script, MatlabProxy matlabProxy, EMap<String, String> parameters) {
		val path = Paths.get(script.scriptLocation)
		val charset = StandardCharsets.UTF_8
		val rawContent = new String(Files.readAllBytes(path), charset)

		// resolve parameters in the next line of the script
		val content = rawContent.resolveParameters(parameters)

		// execute command
		val matlabEngine = MatlabConnectionManager::matlabEngine
		matlabEngine.eval(content)

	// update variable store
//			line.extractAssignments FIXME
		//TODO Searching for potential attributes may be necessary here when dealing with long/complex scripts. Narrowing down the scope to MODIFY intents seems like a good idea. 
	}

	private def executeWithGui(MatlabScript script, MatlabProxy matlabProxy, EMap<String, String> parameters) {
		val file = new File(script.scriptLocation)

		try {
			val bufferedReader = new BufferedReader(new FileReader(file))
			var String line = ""

			while ((line = bufferedReader.readLine()) !== null) {
				// resolve parameters in the next line of the script
				line = line.resolveParameters(parameters)

				// execute command
				matlabProxy.eval(line)

				// update variable store
				line.extractAssignments
			}
		} catch (Exception e) {
			e.printStackTrace
		}
	}
	
	public def openTool(){
		
	}

}
