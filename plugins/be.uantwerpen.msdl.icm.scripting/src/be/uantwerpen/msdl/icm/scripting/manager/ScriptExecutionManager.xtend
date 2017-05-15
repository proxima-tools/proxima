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

import be.uantwerpen.msdl.icm.scripting.execution.JavaExecutor
import be.uantwerpen.msdl.icm.scripting.execution.MatlabExecutor
import be.uantwerpen.msdl.icm.scripting.execution.PythonExecutor
import be.uantwerpen.msdl.icm.scripting.scripts.IScript
import be.uantwerpen.msdl.icm.scripting.scripts.JavaBasedScript
import be.uantwerpen.msdl.icm.scripting.scripts.MatlabScript
import be.uantwerpen.msdl.icm.scripting.scripts.PythonScript
import matlabcontrol.MatlabProxy
import org.eclipse.emf.common.util.EMap

class ScriptExecutionManager {

	val public static String PYTHON_EXTENSION = "py"
	val public static String JAVA_EXTENSION = "java"
	val public static String MATLAB_EXTENSION = "m"

	val pythonExecutor = new PythonExecutor
	val javaExecutor = new JavaExecutor
	val matlabExecutor = new MatlabExecutor

	private MatlabProxy matlabProxy;

	new(MatlabProxy matlabProxy) {
		this.matlabProxy = matlabProxy;
	}

	def execute(IScript script, EMap<String, String> parameters) {
		switch (script) {
			JavaBasedScript: javaExecutor.execute(script)
			PythonScript: pythonExecutor.execute(script)
			MatlabScript: matlabExecutor.execute(script, matlabProxy, parameters)
		}
	}
}
