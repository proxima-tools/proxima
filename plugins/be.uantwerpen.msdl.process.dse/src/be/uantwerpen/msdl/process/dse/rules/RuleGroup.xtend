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
import be.uantwerpen.msdl.icm.queries.general.util.IndependentNodes2Processor
import be.uantwerpen.msdl.icm.queries.general.util.IndependentNodesProcessor
import be.uantwerpen.msdl.icm.queries.inconsistencies.InconsistencyPatterns
import be.uantwerpen.msdl.icm.queries.inconsistencies.UnmanagedPatterns
import be.uantwerpen.msdl.metamodels.process.Activity
import be.uantwerpen.msdl.metamodels.process.Process
import java.util.List
import org.eclipse.viatra.dse.api.DSETransformationRule
import org.eclipse.viatra.dse.api.DesignSpaceExplorer
import org.eclipse.viatra.query.runtime.api.impl.BaseMatcher
import org.eclipse.viatra.query.runtime.api.impl.BasePatternMatch

abstract class RuleGroup {

	protected val contractCost = 10;
	protected val checkCost = 10;

	protected val extension InconsistencyPatterns inconsistencyPatterns = InconsistencyPatterns::instance
	protected val extension UnmanagedPatterns unmanagedPatterns = UnmanagedPatterns::instance
	protected val extension GeneralPatterns generalPatterns = GeneralPatterns::instance
	protected val extension ProcessFactory2 processFactory = new ProcessFactory2

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
			sequenceNodes,
			parallelizeNodes
		]
	}

	/**
	 * Organize independent nodes into a sequence
	 */
	val sequenceNodes = new DSETransformationRule(
		independentNodes,
		new IndependentNodesProcessor() {
			override process(Activity activity1, Activity activity2, Process process) {
				process.createControlFlow(activity1, activity2)
			}

		}
	)

	/**
	 * Organize independent nodes into a parallel structure
	 */
	val parallelizeNodes = new DSETransformationRule(
		independentNodes2,
		new IndependentNodes2Processor() {
			override process(Activity activity1, Activity activity2, Process process) {
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
}
