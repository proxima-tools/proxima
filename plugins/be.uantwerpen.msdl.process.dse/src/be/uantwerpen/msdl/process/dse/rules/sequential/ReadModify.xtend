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

package be.uantwerpen.msdl.process.dse.rules.sequential

import be.uantwerpen.msdl.icm.queries.inconsistencies.util.UnmanagedReadModify2Processor
import be.uantwerpen.msdl.icm.queries.inconsistencies.util.UnmanagedReadModify3Processor
import be.uantwerpen.msdl.icm.queries.inconsistencies.util.UnmanagedReadModifyProcessor
import be.uantwerpen.msdl.process.dse.rules.RuleGroup
import be.uantwerpen.msdl.processmodel.cost.CostType
import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.processmodel.pm.Process
import be.uantwerpen.msdl.processmodel.properties.IntentType
import be.uantwerpen.msdl.processmodel.properties.Property
import org.eclipse.viatra.dse.api.DSETransformationRule
import be.uantwerpen.msdl.icm.queries.inconsistencies.util.UnmanagedModifyModifySequentialProcessor

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
	val readModifyReorder = new DSETransformationRule(
		unmanagedReadModify,
		new UnmanagedReadModifyProcessor() {
			override process(Activity activity1, Property property1, Activity activity2, Property property2) {
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
			}
		}
	)

	/**
	 * Check property
	 */
	val readModifyAugmentWithCheck = new DSETransformationRule(
		unmanagedReadModify2,
		new UnmanagedReadModify2Processor() {
			override process(Activity activity1, Property property1, Activity activity2, Property property2) {
				createDecision(activity2, property1, activity1)
			}
		}
	)

	val readModifyAugmentWithContract = new DSETransformationRule(
		unmanagedReadModify3,
		new UnmanagedReadModify3Processor() {
			override process(Activity activity1, Property property1, Activity activity2, Property property2) {
				createContract(activity1, #[property1], activity1)
			}
		}
	)
	
	val modifyModifyAugmentWithContract = new DSETransformationRule(
		unmanagedModifyModifySequential,
		new UnmanagedModifyModifySequentialProcessor() {
			override process(Activity activity1, Property property1, Activity activity2, Property property2) {
				createContract(activity1, #[property1], activity1)
			}
		}
	)
}
