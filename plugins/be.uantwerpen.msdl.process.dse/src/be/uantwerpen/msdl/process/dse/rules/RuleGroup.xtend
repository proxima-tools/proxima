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

package be.uantwerpen.msdl.process.dse.rules

import be.uantwerpen.msdl.icm.queries.general.GeneralPatterns
import be.uantwerpen.msdl.icm.queries.general.util.ParallelActivitiesProcessor
import be.uantwerpen.msdl.icm.queries.inconsistencies.InconsistencyPatterns
import be.uantwerpen.msdl.icm.queries.inconsistencies.UnmanagedPatterns
import be.uantwerpen.msdl.processmodel.cost.CostType
import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.processmodel.pm.Node
import be.uantwerpen.msdl.processmodel.pm.Process
import be.uantwerpen.msdl.processmodel.properties.IntentType
import be.uantwerpen.msdl.processmodel.properties.Property
import java.util.List
import org.eclipse.viatra.dse.api.DSETransformationRule
import org.eclipse.viatra.dse.api.DesignSpaceExplorer
import org.eclipse.viatra.query.runtime.api.impl.BaseMatcher
import org.eclipse.viatra.query.runtime.api.impl.BasePatternMatch
import be.uantwerpen.msdl.process.dse.rules.sequential.ReadModify
import be.uantwerpen.msdl.icm.queries.general.util.SequentialActivitiesDirectProcessor

abstract class RuleGroup {

	protected val contractCost = 1;
	protected val checkCost = 1;

	protected val extension InconsistencyPatterns inconsistencyPatterns = InconsistencyPatterns::instance
	protected val extension UnmanagedPatterns unmanagedPatterns = UnmanagedPatterns::instance
	protected val extension GeneralPatterns generalPatterns = GeneralPatterns::instance
	protected val extension PropertiesFactory2 propertiesFactory = new PropertiesFactory2
	protected val extension PmFactory2 pmFactory = new PmFactory2
	protected val extension CostFactory2 costFactory = new CostFactory2

	public def addTransformationRules(DesignSpaceExplorer dse) {
		(rules
			//+ generalRules
		).
			forEach [ rule |
				dse.addTransformationRule(rule)
			]
	}

	abstract protected def List<DSETransformationRule<? extends BasePatternMatch, ? extends BaseMatcher<? extends BasePatternMatch>>> rules()

	def generalRules() {
		#[ 
//			 sequenceNodes,
//			parallelizeNodes
		]
	}

	/**
	 * Organize independent nodes into a sequence
	 */
	val sequenceNodes = new DSETransformationRule(
		parallelActivities,
		new ParallelActivitiesProcessor() {
			override process(Activity activity1, Activity activity2) {
				val previousControl1To = activity1.controlOut.head.to
				val previousControl2From = activity2.controlIn.head.from

				val process = (activity1.eContainer as Process)

				process.controlFlow.remove(activity1.controlOut.head)
				process.controlFlow.remove(activity2.controlIn.head)
				
				process.createControlFlow(activity1, activity2)
			}
		}
	)

//	/**
//	 * Organize independent nodes into a parallel structure
//	 */
	val parallelizeNodes = new DSETransformationRule(
		sequentialActivitiesDirect,
		new SequentialActivitiesDirectProcessor() {
			override process(Activity activity1, Activity activity2) {
				val process = (activity1.eContainer as Process)
				val fork = process.createFork;
				val join = process.createJoin;

				// control inputs of activity1 and activity2 should be redirected to the fork
				fork.controlIn += activity1.controlIn
				fork.controlIn += activity2.controlIn

				// control outputs of activity1 and activity2 should be redirected from the join
				join.controlOut += activity1.controlOut
				join.controlOut += activity2.controlOut

				// wave activities into the fork-join structure
				#[activity1, activity2].forEach [ activity |
					process.createControlFlow(fork, activity)
					process.createControlFlow(activity, join)
				]
			}
		}
	)
	
	def createDecision(Activity activity, Property propertyToCheck, Node loopTarget) {
		val process = activity.eContainer as Process

		val decision = process.createDecision(propertyToCheck.name + "?")

		// these are gonna be the OK nodes from the Decision node
		activity.controlOut.forEach [ cf |
			cf.name = "OK"
		]
		decision.controlOut.addAll(activity.controlOut)
		activity.controlOut.removeAll(decision.controlOut)

		val checkActivity = process.createManualActivity("check" + propertyToCheck.name)
		checkActivity.createCost(checkCost, CostType::COST_PER_TIME) // TODO this may be corrupted with the new cost hierarchy (CostFactor)
		createIntent(checkActivity, propertyToCheck, IntentType::CHECK_PROPERTY)

		// connecting Activity2 with the check activity and that with the Decision 
		process.createControlFlow(activity, checkActivity)
		process.createControlFlow(checkActivity, decision)

		val controlNO = process.createFeedback(decision, loopTarget)
		controlNO.name = "NO"
	}

	def createContract(Node node, List<Property> properties, Activity activity) {
		val process = node.eContainer as Process

		val contractActivity = process.createManualActivity("contract")
		contractActivity.createCost(contractCost, CostType::COST_PER_TIME)

		properties.forEach [ property |
			createIntent(contractActivity, property, IntentType::CONTRACT)
		]
		contractActivity.controlIn.addAll(node.controlIn)
		process.createControlFlow(contractActivity, node)
		
		val i = 1
	}
}
