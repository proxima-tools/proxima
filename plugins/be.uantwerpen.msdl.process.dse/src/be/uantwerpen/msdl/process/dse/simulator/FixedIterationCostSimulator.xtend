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

package be.uantwerpen.msdl.process.dse.simulator

import be.uantwerpen.msdl.icm.queries.simulator.util.CostInCircleQuerySpecification
import be.uantwerpen.msdl.icm.queries.simulator.util.CostQuerySpecification
import be.uantwerpen.msdl.metamodels.process.Cost
import be.uantwerpen.msdl.metamodels.process.ProcessModel
import be.uantwerpen.msdl.metamodels.process.RatioScale
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine

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
		val singleCosts = queryEngine.getMatcher(CostQuerySpecification.instance).allMatches;
		val costsInLoops = queryEngine.getMatcher(CostInCircleQuerySpecification.instance).allMatches;

		singleCosts.map [ match |
			match.cost
		].sum(1) + costsInLoops.map [ match |
			match.cost
		].sum(iterations - 1)
	}

	private def sum(Iterable<Cost> costs, int times) {
		costs.filter [ cost |
			cost instanceof RatioScale
		].map [ cost |
			cost as RatioScale
		].fold(0.0) [ sum, nextCost |
			sum + nextCost.value * times
		]
	}
}
