package be.uantwerpen.msdl.process.dse.simulator

import be.uantwerpen.msdl.metamodels.process.ProcessModel

class Simulator {

	private ProcessModel processModel

	new(ProcessModel processModel) {
		this.processModel = processModel
	}
	
	def canSimulate(){
		true
	}

	def simulate() {
		0.0
	}
}
