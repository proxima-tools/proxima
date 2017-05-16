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

package be.uantwerpen.msdl.icm.scripting.execution

import be.uantwerpen.msdl.icm.scripting.scripts.MatlabScript
import java.io.BufferedReader
import java.io.File
import java.io.FileReader
import matlabcontrol.MatlabProxy
import org.eclipse.emf.common.util.EMap

class MatlabExecutor extends ParameterizedExecutor {

	def execute(MatlabScript script, MatlabProxy matlabProxy, EMap<String, String> parameters) {
		val file = new File(script.scriptLocation)

		try {
			val bufferedReader = new BufferedReader(new FileReader(file))
			var String line = ""

			while ((line = bufferedReader.readLine()) != null) {
				//resolve parameters in the next line of the script
				line = line.resolveParameters(parameters)
				
				//execute command
				matlabProxy.eval(line)
				
				//update variable store
				line.extractAssignments
			}
		} catch (Exception e) {
			e.printStackTrace
		}
	}

}
