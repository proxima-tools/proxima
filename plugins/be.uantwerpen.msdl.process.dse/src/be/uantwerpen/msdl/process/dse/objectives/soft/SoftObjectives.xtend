package be.uantwerpen.msdl.process.dse.objectives.soft

import be.uantwerpen.msdl.icm.queries.inconsistencies.InconsistencyPatterns
import org.eclipse.viatra.dse.api.DesignSpaceExplorer
import org.eclipse.viatra.dse.objectives.Comparators
import org.eclipse.viatra.dse.objectives.impl.ConstraintsObjective

class SoftObjectives {

	val extension InconsistencyPatterns inconsistencyPatterns = InconsistencyPatterns::instance

	def addConstraints(DesignSpaceExplorer dse) {
		objectives.forEach [ objective |
			dse.addObjective(objective)
		]
	}

	def objectives() {
		#[
			consistencyObjective
//			,//.withLevel(1),
//			cheapestProcessObjective//.withLevel(0)
		]

	}
	val consistencyObjective = new ConstraintsObjective()
		.withSoftConstraint("consistencyObjective",readModifySharedProperty, 10d)
		.withComparator(Comparators.LOWER_IS_BETTER)
	
	val cheapestProcessObjective = new CheapestProcessSoftObjective()
		.withComparator(Comparators.LOWER_IS_BETTER)
}
