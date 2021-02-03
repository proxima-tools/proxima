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

import be.uantwerpen.msdl.icm.runtime.scripting.scripts.PythonScript
import java.io.BufferedReader
import java.io.InputStreamReader

class PythonExecutor {

	def execute(PythonScript script) {
		val p = Runtime.getRuntime().exec("python " + script.getScriptLocation);
		val in = new BufferedReader(new InputStreamReader(p.getInputStream()));
		System.out.println(in.readLine);
	}
}
