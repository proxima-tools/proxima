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

package be.uantwerpen.msdl.process.dse.rules.parallel

import be.uantwerpen.msdl.process.dse.rules.RuleGroup

class ParallelModify extends RuleGroup {

	override rules() {
		#[
//			makeSequential,
			addContract
		]
	}

//	// TODO unamanged4..5..6..
//	val addChecks = new DSETransformationRule(
//		unmanagedModifyModify,
//		new UnmanagedModifyModifyProcessor() {
//			override process(Activity activity1, Property property1, Activity activity2, Property property2) {
//				// createDecision(activity1, property2, )
//				// TODO
//			}
//		}
//	)
	val addContract = batchTransformationRuleFactory.createRule(unmanagedModifyModifyParallel).name("").action [
		createContract(fork, #[property1, property2], activity1)
	].build

//	val makeSequential = new DSETransformationRule(
//		unmanagedModifyModify3,
//		new UnmanagedModifyModify3Processor() {
//			override process(Activity activity1, Property property1, Activity activity2, Property property2) {
//				val process = activity1.eContainer as Process
//
//				val join = process.createJoin
//				val ins1 = activity1.controlIn
//				val ins2 = activity2.controlIn
//				join.controlIn.addAll(ins1)
//				activity1.controlIn.removeAll(ins1)
//				join.controlIn.addAll(ins2)
//				activity2.controlIn.removeAll(ins2)
//				process.createControlFlow(join, activity1)
//				
//				val fork = process.createFork
//				val outs1 = activity1.controlOut
//				val outs2 = activity2.controlOut
//				fork.controlOut.addAll(outs1)
//				activity1.controlOut.removeAll(outs1)
//				fork.controlOut.addAll(outs2)
//				activity2.controlOut.removeAll(outs2)
//				process.createControlFlow(activity2, fork)
//				
//				process.createControlFlow(activity1, activity2)
//			}
//		}
//	)
}
