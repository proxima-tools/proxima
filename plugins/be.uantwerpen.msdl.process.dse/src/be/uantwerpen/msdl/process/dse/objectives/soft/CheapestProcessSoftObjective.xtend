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

package be.uantwerpen.msdl.process.dse.objectives.soft

import be.uantwerpen.msdl.process.dse.simulator.SimulationRunner
import org.eclipse.viatra.dse.base.ThreadContext
import org.eclipse.viatra.dse.objectives.impl.BaseObjective

class CheapestProcessSoftObjective extends BaseObjective {

	private static val DEFAULT_NAME = "CheapestProcessSoftObjective"
	private SimulationRunner simulationRunner

	new() {
		super(DEFAULT_NAME)
	}

	override createNew() {
		val objective = new CheapestProcessSoftObjective();
		objective.setLevel(level);
		objective
	}

	override getFitness(ThreadContext context) {
		simulationRunner.runSimulation
		simulationRunner.cost
	}

	override init(ThreadContext context) {
		simulationRunner = SimulationRunner.create(context)
	}

	override isHardObjective() {
		false
	}

	override satisifiesHardObjective(Double fitness) {
		true
	}

}
