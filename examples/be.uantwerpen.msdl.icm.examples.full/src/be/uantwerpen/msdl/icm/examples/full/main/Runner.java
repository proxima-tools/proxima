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

package be.uantwerpen.msdl.icm.examples.full.main;

import java.io.File;
import java.util.List;

import org.junit.Test;

import com.google.common.collect.Lists;

import be.uantwerpen.msdl.icm.examples.full.main.scripts.A1;
import be.uantwerpen.msdl.icm.examples.full.main.scripts.A2;
import be.uantwerpen.msdl.icm.examples.full.main.scripts.A3;
import be.uantwerpen.msdl.icm.examples.full.main.scripts.A4;
import be.uantwerpen.msdl.icm.runtime.CommandInterpreter;
import be.uantwerpen.msdl.icm.runtime.EnactmentManager;
import be.uantwerpen.msdl.icm.runtime.scripting.scripts.IScript;

public class Runner {

	private static final String TEST_FILE_LOCATION =
			 "D:\\workspaces\\runtime-New_configuration-neon3-runtime1\\test\\process1.processmodel";
//			"processes\\attributetest.processmodel";

	@Test
	public void run() {
		EnactmentManager enactmentManager = new EnactmentManager(new File(TEST_FILE_LOCATION), getScripts());
		new CommandInterpreter(enactmentManager).interpret();
	}

	// TODO this could be replaced by a smart factory via some generative method
	private List<Class<? extends IScript>> getScripts() {
		List<Class<? extends IScript>> scripts = Lists.newArrayList();

		scripts.add(A1.class);
		scripts.add(A2.class);
		scripts.add(A3.class);
		scripts.add(A4.class);

		return scripts;
	}
}
