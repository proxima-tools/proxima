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

package be.uantwerpen.msdl.icm.tooling.ui.commands

import be.uantwerpen.msdl.processmodel.ProcessModel
import java.io.File
import java.io.FileWriter

class Generator {

	private FileWriter writer

	def doGenerate(ProcessModel processModel) {

		println("generating file")

		writer = new FileWriter(new File("C:\\", "processmodel.java"))

		writer.append('''
			package processmodel;
			
			public class ProcessModel2{
				
			}
		''')

		writer.close()
	}

}
