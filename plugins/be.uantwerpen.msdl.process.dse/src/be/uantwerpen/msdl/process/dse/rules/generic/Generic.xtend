/*******************************************************************************
 * Copyright (c) 2016 Istvan David
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *    Istvan David - initial API and implementation
 *******************************************************************************/

package be.uantwerpen.msdl.process.dse.rules.generic

import be.uantwerpen.msdl.icm.queries.general.GeneralPatterns
import be.uantwerpen.msdl.icm.queries.general.util.SoftControlFlowBetweenActivitiesProcessor
import be.uantwerpen.msdl.metamodels.process.Activity
import be.uantwerpen.msdl.metamodels.process.ControlFlow
import be.uantwerpen.msdl.metamodels.process.Process
import be.uantwerpen.msdl.process.dse.rules.RuleGroup
import org.eclipse.viatra.dse.api.DSETransformationRule

class Generic extends RuleGroup {

	protected val extension GeneralPatterns generalPatterns = GeneralPatterns::instance

	override rules() {
		#[
			deleteSoftControlFlow
		]
	}

	/**
	 * Control flow patterns
	 */
	val deleteSoftControlFlow = new DSETransformationRule(
		softControlFlowBetweenActivities,
		new SoftControlFlowBetweenActivitiesProcessor() {
			override process(Activity activity1, Activity activity2, ControlFlow controlFlow, Process process) {
				process.controlFlow.remove(controlFlow)
			}
		}
	)

}
