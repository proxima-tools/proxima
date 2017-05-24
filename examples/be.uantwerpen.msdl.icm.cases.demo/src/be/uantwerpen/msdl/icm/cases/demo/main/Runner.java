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
package be.uantwerpen.msdl.icm.cases.demo.main;

import java.io.File;
import java.util.List;

import org.junit.Test;

import com.google.common.collect.Lists;

import be.uantwerpen.msdl.icm.cases.demo.scripts.SetInitialConditions;
import be.uantwerpen.msdl.icm.cases.demo.scripts.SimulateElectricalModel;
import be.uantwerpen.msdl.icm.runtime.CommandInterpreter;
import be.uantwerpen.msdl.icm.runtime.EnactmentManager;
import be.uantwerpen.msdl.icm.runtime.scripting.scripts.IScript;

public class Runner {

	private static final String TEST_FILE_LOCATION = "D:\\GitHub\\msdl\\ICM\\examples\\be.uantwerpen.msdl.icm.cases.demo\\process\\process.processmodel";

	@Test
	public void run() {
		EnactmentManager enactmentManager = new EnactmentManager(new File(TEST_FILE_LOCATION), getScripts());
		new CommandInterpreter(enactmentManager).interpret();
	}

	private List<Class<? extends IScript>> getScripts() {
		List<Class<? extends IScript>> scripts = Lists.newArrayList();

		scripts.add(SetInitialConditions.class);
		scripts.add(SimulateElectricalModel.class);

		return scripts;
	}
}
