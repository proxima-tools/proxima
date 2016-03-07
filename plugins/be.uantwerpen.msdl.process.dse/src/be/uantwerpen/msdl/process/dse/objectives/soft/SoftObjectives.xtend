package be.uantwerpen.msdl.process.dse.objectives.soft

import org.eclipse.viatra.dse.api.DesignSpaceExplorer
import org.eclipse.viatra.dse.objectives.Comparators
import org.eclipse.viatra.dse.objectives.impl.WeightedQueriesSoftObjective
import be.uantwerpen.msdl.icm.queries.inconsistencies.InconsistencyPatterns

class SoftObjectives {

	val extension InconsistencyPatterns inconsistencyPatterns = InconsistencyPatterns::instance

	def addConstraints(DesignSpaceExplorer dse) {
		objectives.forEach [ objective |
			dse.addObjective(objective)
		]
	}

	def objectives() {
		#[
			consistencyObjective.withLevel(1),
			cheapestProcessObjective.withLevel(2)
		]
	}

	val consistencyObjective = new WeightedQueriesSoftObjective("consistencyObjective")
		.withConstraint(readModifySharedProperty, 1)
		.withComparator(Comparators.LOWER_IS_BETTER)
	
	val cheapestProcessObjective = new CheapestProcessSoftObjective()
		.withComparator(Comparators.LOWER_IS_BETTER)
}
