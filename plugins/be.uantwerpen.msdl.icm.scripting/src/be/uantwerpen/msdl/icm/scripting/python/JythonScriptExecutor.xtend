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

package be.uantwerpen.msdl.icm.scripting.python

import be.uantwerpen.msdl.icm.scripting.scripts.PythonScript
import java.util.Properties
import org.python.util.PythonInterpreter

class JythonScriptExecutor {

	def execute(PythonScript script) {

		val props = new Properties();
		props.put("python.home", "lib");
		props.put("python.console.encoding", "UTF-8"); // Used to prevent: console: Failed to install '': java.nio.charset.UnsupportedCharsetException: cp0.
		props.put("python.security.respectJavaAccessibility", "false"); // don't respect java accessibility, so that we can access protected members on subclasses
		props.put("python.import.site", "false");

		val preprops = System.getProperties();

		PythonInterpreter.initialize(preprops, props, #[]);

		val interp = new PythonInterpreter();
		interp.execfile(script.scriptLocation);
	}
}
