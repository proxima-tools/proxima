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

package be.uantwerpen.msdl.icm.runtime

import com.google.common.base.Stopwatch
import org.apache.log4j.Level
import org.junit.Test

class EnactmentTest extends AbstractEnactmentTest {

	private static final val TEST_FILE_LOCATION = "..\\be.uantwerpen.msdl.icm.test.data\\processes\\process1.processmodel"

	new() {
		super(TEST_FILE_LOCATION)
	}

	@Test
	def void execute() {
		logger.level = Level::DEBUG
		logger.debug("setting up engine")
		stopwatch = Stopwatch.createStarted()

		// execute
		logger.debug("Ready")
		new CommandInterpreter(enactmentManager).interpret

		// finish
		stopwatch.resetAndRestart
		logger.debug("Process finished.")
	}
}
