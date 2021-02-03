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

package be.uantwerpen.msdl.process.dse.rules.sequential

import be.uantwerpen.msdl.process.dse.rules.RuleGroup

class ReadModify extends RuleGroup {

	override rules() {
		#[
			readModifyReorder,
			readModifyAugmentWithCheck,
			readModifyAugmentWithContract,
			modifyModifyAugmentWithContract
		]
	}

	/**
	 * Reordering
	 */
	val readModifyReorder = batchTransformationRuleFactory.createRule(unmanagedReadModify).name("Reordering").action [
		val tmp = createManualActivity("tmp");

		tmp.controlIn.addAll(activity1.controlIn)
		activity1.controlIn.removeAll(tmp.controlIn)

		tmp.controlOut.addAll(activity1.controlOut)
		activity1.controlOut.removeAll(tmp.controlOut)

		activity1.controlIn.addAll(activity2.controlIn)
		activity2.controlIn.removeAll(activity1.controlIn)

		activity1.controlOut.addAll(activity2.controlOut)
		activity2.controlOut.removeAll(activity1.controlOut)

		activity2.controlIn.addAll(tmp.controlIn)
		tmp.controlIn.removeAll(activity2.controlIn)

		activity2.controlOut.addAll(tmp.controlOut)
		tmp.controlOut.removeAll(activity2.controlOut)
	].build

	/**
	 * Check property
	 */
	val readModifyAugmentWithCheck = batchTransformationRuleFactory.createRule(unmanagedReadModify2).name(
		"Check property").action [
		createDecision(activity2, property1, activity1)
	].build

	val readModifyAugmentWithContract = batchTransformationRuleFactory.createRule(unmanagedReadModify3).name(
		"Check-modify with Contract").action [
		createContract(activity1, #[property1], activity1)
	].build

	val modifyModifyAugmentWithContract = batchTransformationRuleFactory.createRule(unmanagedModifyModifySequential).
		name("Modify-modify with Contract").action [
			createContract(activity1, #[property1], activity1)
		].build
}
