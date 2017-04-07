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
import java.io.File
import java.util.concurrent.TimeUnit
import org.apache.log4j.Logger
import org.junit.After
import org.junit.Before

abstract class AbstractEnactmentTest {
	protected EnactmentManager enactmentManager
	protected Logger logger = Logger.getLogger("Enactment Runner")
	protected Stopwatch stopwatch
	private String testFileLocation

	new(String testFileLocation) {
		this.testFileLocation = testFileLocation
	}

	@Before
	def void setup() {
		enactmentManager = new EnactmentManager(new File(testFileLocation), null)
	}

	@After
	def void tearDown() {
		enactmentManager = null
	}

	protected def resetAndRestart(Stopwatch stopwatch) {
		stopwatch.reset.start
	}

	protected def timeElapsed() {
		stopwatch.elapsed(TimeUnit.MILLISECONDS)
	}
}
