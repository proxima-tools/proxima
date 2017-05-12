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

package be.uantwerpen.msdl.icm.scripting

import be.uantwerpen.msdl.icm.scripting.execution.PythonExecutor
import be.uantwerpen.msdl.icm.scripting.scripts.PythonScript
import org.junit.After
import org.junit.Before
import org.junit.Test

class PythonFileBasedTests {

//	private static final String TEST_FILE = "test1.py"
	private static final String TEST_FILE = "d:\\tools\\LMS\\LMS Imagine.Lab Amesim\\v1400\\amesimtest.py"

	private PythonExecutor scriptManager

	@Before
	def void setUp() {
		this.scriptManager = new PythonExecutor
	}

	@After
	def void tearDown() {
		this.scriptManager = null
	}

	@Test
	def void executeStatic() {
		scriptManager.execute(new PythonScript(TEST_FILE))
	}

}
