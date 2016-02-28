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
