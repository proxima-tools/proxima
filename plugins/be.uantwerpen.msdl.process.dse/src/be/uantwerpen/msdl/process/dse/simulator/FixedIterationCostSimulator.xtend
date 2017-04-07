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

package be.uantwerpen.msdl.process.dse.simulator

import be.uantwerpen.msdl.icm.queries.simulator.util.CostInCircleQuerySpecification
import be.uantwerpen.msdl.icm.queries.simulator.util.TimeQuerySpecification
import be.uantwerpen.msdl.processmodel.ProcessModel
import be.uantwerpen.msdl.processmodel.cost.Cost
import be.uantwerpen.msdl.processmodel.cost.CostFactor
import be.uantwerpen.msdl.processmodel.cost.CostType
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.icm.queries.simulator.util.CostForPresenceQuerySpecification

class FixedIterationCostSimulator {

	private static final int DEFAULT_ITERATION_NUMBER = 5

	private ProcessModel processModel
	private ViatraQueryEngine queryEngine
	private int iterations

	new(ProcessModel processModel, ViatraQueryEngine queryEngine) {
		this(processModel, queryEngine, DEFAULT_ITERATION_NUMBER)
	}

	new(ProcessModel processModel, ViatraQueryEngine queryEngine, int iterations) {
		this.processModel = processModel
		this.queryEngine = queryEngine
		this.iterations = iterations
	}

	def canSimulate() {
		true
	}

	def simulate() {
		val timeCosts = queryEngine.getMatcher(TimeQuerySpecification.instance).allMatches

		var timeBasedCosts = 0.0

		for (time : timeCosts) {
			val cost = time.cost
			timeBasedCosts += cost.calculateTimeBasedCost
		}

		val costsInLoops = queryEngine.getMatcher(CostInCircleQuerySpecification.instance).allMatches;

		for (costInLoop : costsInLoops) {
			val cost = costInLoop.cost
			if ((cost.eContainer as CostFactor).type.equals(CostType::TIME)) {
				timeBasedCosts += cost.calculateTimeBasedCost(DEFAULT_ITERATION_NUMBER-1)
			}
		}
		
		val costsForPresence = queryEngine.getMatcher(CostForPresenceQuerySpecification.instance).allMatches
		
		var singlePresenceCosts = 0.0
		
		for(costForPresence : costsForPresence){
			singlePresenceCosts += costForPresence.cost.value 
		}

		val cumulativeCosts = timeBasedCosts+singlePresenceCosts
		
		cumulativeCosts
	}

	private def calculateTimeBasedCost(Cost cost) {
		cost.calculateTimeBasedCost(1)
	}

	private def calculateTimeBasedCost(Cost cost, int times) {
		var value = 0.0
		val costItem = cost.costItem
		if(costItem instanceof Activity){
			val allocations = (costItem as Activity).allocation
			for(allocation : allocations){
				val resourceUnitPrice = allocation.resource.cost.findFirst [c |
					(c.eContainer as CostFactor).type.equals(CostType::COST_PER_TIME)
				]
				if(resourceUnitPrice!=null){
					value += cost.value * resourceUnitPrice.value * times
				}
			}
		}
		value
	}
}
