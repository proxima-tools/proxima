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

import be.uantwerpen.msdl.icm.queries.inconsistencies.util.Unmanaged2Processor
import be.uantwerpen.msdl.icm.queries.inconsistencies.util.Unmanaged3Processor
import be.uantwerpen.msdl.icm.queries.inconsistencies.util.UnmanagedProcessor
import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.processmodel.pm.Process
import be.uantwerpen.msdl.processmodel.properties.Property
import be.uantwerpen.msdl.process.dse.rules.RuleGroup
import org.eclipse.viatra.dse.api.DSETransformationRule
import be.uantwerpen.msdl.processmodel.properties.IntentType
import be.uantwerpen.msdl.processmodel.cost.CostType

class ReadModify extends RuleGroup {

	override rules() {
		#[
			readModifyReorder,
			readModifyAugmentWithCheck,
			readModifyAugmentWithContract
		]
	}

	/**
	 * Reordering
	 */
	val readModifyReorder = new DSETransformationRule(
		unmanaged,
		new UnmanagedProcessor() {
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
		unmanaged2,
		new Unmanaged2Processor() {
			override process(Activity activity1, Property property1, Activity activity2, Property property2) {

				val process = activity1.eContainer as Process

				val decision = process.createDecision(property1.name + "?")

				// these are gonna be the OK nodes from the Decision node
				activity2.controlOut.forEach [ cf |
					cf.name = "OK"
				]
				decision.controlOut.addAll(activity2.controlOut)
				activity2.controlOut.removeAll(decision.controlOut)

				val checkActivity = process.createManualActivity("check" + property1.name)
				checkActivity.createCost(checkCost, CostType::COST_PER_TIME)	//TODO this may be corrupted with the new cost hierarchy (CostFactor)

				createIntent(checkActivity, property1, IntentType::CHECK)

				// connecting Activity2 with the check activity and that with the Decision 
				process.createControlFlow(activity2, checkActivity)
				process.createControlFlow(checkActivity, decision)

				val controlNO = process.createControlFlow(decision, activity1)
				controlNO.name = "NO"
			}
		}
	)

	val readModifyAugmentWithContract = new DSETransformationRule(
		unmanaged3,
		new Unmanaged3Processor() {
			override process(Activity activity1, Property property1, Activity activity2, Property property2) {
				val process = activity1.eContainer as Process
				
				val contractActivity = process.createManualActivity("contract")
				contractActivity.createCost(contractCost, CostType::COST_PER_TIME)
				
				createIntent(contractActivity, property1, IntentType::CONTRACT)
				
				contractActivity.controlIn.addAll(activity1.controlIn)
				process.createControlFlow(contractActivity, activity1)
			}
		}
	)
}
