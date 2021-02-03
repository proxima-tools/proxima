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

package be.uantwerpen.msdl.process.dse.rules.generic

import be.uantwerpen.msdl.icm.queries.general.GeneralPatterns
import be.uantwerpen.msdl.process.dse.rules.RuleGroup

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
	val deleteSoftControlFlow = batchTransformationRuleFactory.createRule(softControlFlowBetweenActivities).name(
		"Delete soft ctrl flow").action [
		process.controlFlow.remove(controlFlow)
	].build
}
