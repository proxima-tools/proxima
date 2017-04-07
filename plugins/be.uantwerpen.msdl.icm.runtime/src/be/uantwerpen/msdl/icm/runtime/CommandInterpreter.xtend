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

import be.uantwerpen.msdl.icm.runtime.variablemanager.VariableManager
import be.uantwerpen.msdl.processmodel.base.NamedElement
import be.uantwerpen.msdl.processmodel.pm.Final
import java.io.BufferedReader
import java.io.InputStreamReader
import org.apache.log4j.Level
import org.apache.log4j.Logger

class CommandInterpreter {
	public static final String ATONCE_COMMAND = "atonce"
	public static final String PREP_COMMAND = "prepare"
	public static final String RUN_COMMAND = "run"
	public static final String FINISH_COMMAND = "finish"
	public static final String STEP_COMMAND = "step"
	public static final String FINAL_COMMAND = "final"
	public static final String EXIT_COMMAND = "exit"
	public static final String VARDUMP_COMMAND = "vardump"

	private Logger logger = Logger.getLogger("Interpreter")
	private EnactmentManager enactmentManager

	new(EnactmentManager enactmentManager) {
		this.enactmentManager = enactmentManager
	}

	def interpret() {
		logger.level = Level::DEBUG

		val reader = new BufferedReader(new InputStreamReader(System.in))

		do {
			logger.debug("Available activities: " + enactmentManager.availableActivities.fold("") [ result, activity |
				switch activity {
					NamedElement: result.concat("\n\t").concat((activity as NamedElement).name)
					Final: result.concat("\n\t Final")
				}
			])

			logger.debug("Ready activities: " + enactmentManager.readyActivities.fold("") [ result, activity |
				result.concat("\n\t").concat((activity as NamedElement).name)
			])

			print("> ")
			val input = reader.readLine()

			switch input {
				case input.toLowerCase.startsWith(ATONCE_COMMAND): {
					logger.debug(String.format("Running process at once."))
					enactmentManager.runAtOnce
				}
				case input.toLowerCase.startsWith(PREP_COMMAND): {
					val activity = input.split(" ", 2).toList.get(1)
					logger.debug(String.format("Preparing activity %s.", activity))
					enactmentManager.prepareActivity(activity)
				}
				case input.toLowerCase.startsWith(RUN_COMMAND): {
					val activity = input.split(" ", 2).toList.get(1)
					logger.debug(String.format("Executing activity %s.", activity))
					enactmentManager.runActivity(activity)
				}
				case input.toLowerCase.startsWith(FINISH_COMMAND): {
					val activity = input.split(" ", 2).toList.get(1)
					logger.debug(String.format("Finishing activity %s.", activity))
					enactmentManager.finishActivity(activity)
				}
				case input.toLowerCase.equals(STEP_COMMAND): {
					logger.debug(String.format("Preparing, executing and finishing randomly."))
					enactmentManager.stepActivity()
				}
				case input.toLowerCase.startsWith(STEP_COMMAND): {
					val activity = input.split(" ", 2).toList.get(1)
					logger.debug(String.format("Preparing, executing and finishing activity %s.", activity))
					enactmentManager.stepActivity(activity)
				}
				case input.toLowerCase.equals(FINAL_COMMAND): {
					logger.debug(String.format("Preparing, executing and finishing process."))
					enactmentManager.finalStep
				}
				case input.toLowerCase.equals(VARDUMP_COMMAND): {
					logger.debug(String.format("Dumping bound variables."))
					VariableManager.instance.boundVariables.entrySet.forEach [ entry |
						println(entry.key + "=" + entry.value)
					]
				}
				case input.toLowerCase.equals(EXIT_COMMAND): {
					logger.debug("Exiting.")
					return
				}
				default: {
					logger.debug("Unknown command.");
				}
			}
		// enactmentManager.maintain  //Use this line if maintenance is done in a batch-fashion
		} while (true && !enactmentManager.processFinished);
	}

}
