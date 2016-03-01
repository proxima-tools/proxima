package be.uantwerpen.msdl.process.dse.objectives.soft

import be.uantwerpen.msdl.icm.queries.processrewrite.ProcessRewrite
import org.eclipse.viatra.dse.api.DesignSpaceExplorer
import org.eclipse.viatra.dse.objectives.Comparators
import org.eclipse.viatra.dse.objectives.impl.WeightedQueriesSoftObjective

class SoftObjectives {

	val extension ProcessRewrite processRewrite = ProcessRewrite::instance

	def addConstraints(DesignSpaceExplorer dse) {
		objectives.forEach [ objective |
			dse.addObjective(objective)
		]
	}

	def objectives() {
		#[
			cheapestProcessObjective,
			consistencyObjective
		]
	}

	val consistencyObjective = new WeightedQueriesSoftObjective("consistencyObjective").withConstraint(readModifySharedProperty, 10).
		withComparator(Comparators.LOWER_IS_BETTER).withLevel(1)
	val cheapestProcessObjective = new CheapestProcessSoftObjective().withComparator(Comparators.LOWER_IS_BETTER).
		withLevel(1)
}
