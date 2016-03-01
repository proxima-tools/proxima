package be.uantwerpen.msdl.process.dse.simulator

import be.uantwerpen.msdl.metamodels.process.ProcessModel
import be.uantwerpen.msdl.metamodels.process.RatioScale

class Simulator {

	private ProcessModel processModel

	new(ProcessModel processModel) {
		this.processModel = processModel
	}
	
	def canSimulate(){
		true
	}

	def simulate() {
		processModel.costModel.cost.filter[cost | cost instanceof RatioScale].map[cost | cost as RatioScale].fold(0.0)[sum, nextCost | sum + nextCost.value]
	}
}
