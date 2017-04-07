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

package be.uantwerpen.msdl.icm.scripting.manager

import be.uantwerpen.msdl.icm.scripting.java.JavaBasedScriptExecutor
import be.uantwerpen.msdl.icm.scripting.python.RuntimeScriptExecutor
import be.uantwerpen.msdl.icm.scripting.scripts.IScript
import be.uantwerpen.msdl.icm.scripting.scripts.JavaBasedScript
import be.uantwerpen.msdl.icm.scripting.scripts.PythonScript

class ScriptExecutionManager {

	val public static String PYTHON_EXTENSION = "py"
	val public static String JAVA_EXTENSION = "java"

	val pythonExecutor = new RuntimeScriptExecutor
	val javaExecutor = new JavaBasedScriptExecutor

	def execute(IScript script) {
		switch (script) {
			JavaBasedScript: javaExecutor.execute(script)
			PythonScript: pythonExecutor.execute(script)
		}
	}
}
