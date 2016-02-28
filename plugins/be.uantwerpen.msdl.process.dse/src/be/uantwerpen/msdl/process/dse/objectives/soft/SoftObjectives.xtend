package be.uantwerpen.msdl.process.dse.objectives.soft

import org.eclipse.viatra.dse.api.DesignSpaceExplorer
import org.eclipse.viatra.dse.objectives.Comparators

class SoftObjectives {

	def addConstraints(DesignSpaceExplorer dse) {
		objectives.forEach [ objective |
			dse.addObjective(objective)
		]
	}

	def objectives() {
		#[
			cheapestProcessObjective
		]
	}

	val cheapestProcessObjective = new CheapestProcessSoftObjective().withComparator(Comparators.LOWER_IS_BETTER).
		withLevel(1)
}
