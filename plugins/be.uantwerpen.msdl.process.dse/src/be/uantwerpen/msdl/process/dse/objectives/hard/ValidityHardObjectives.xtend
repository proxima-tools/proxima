package be.uantwerpen.msdl.process.dse.objectives.hard

import be.uantwerpen.msdl.icm.queries.validation.Validation
import org.eclipse.viatra.dse.api.DesignSpaceExplorer
import org.eclipse.viatra.dse.objectives.impl.ModelQueriesGlobalConstraint
import org.eclipse.viatra.dse.objectives.impl.ModelQueriesHardObjective
import org.eclipse.viatra.dse.objectives.impl.ModelQueryType

class ValidityHardObjectives {
	val extension Validation validationQueries = Validation::instance

	def addConstraints(DesignSpaceExplorer dse) {
//		globalConstraints.forEach [ constraint |
//			dse.addGlobalConstraint(constraint)
//		]
		objectives.forEach [ objective |
			dse.addObjective(objective)
		]
	}

	def globalConstraints() {
		#[
//		globalConstraint
		]
	}

	def objectives() {
		#[
			validationObjectives,
			globalReachability
		]
	}

	val globalConstraint = new ModelQueriesGlobalConstraint("globalConstraints1")
		.withConstraint(initNodeWithControlIn)
//		.withConstraint(finalNodeInvalidOuts)
		.withType(ModelQueryType::NO_MATCH)

	val validationObjectives = new ModelQueriesHardObjective("validProcess")
		.withConstraint(initNodeWithControlIn)
		.withConstraint(initNodeWithInvalidNumberOfControlOut)
		.withConstraint(finalNodeWithInvalidNumberOfIns)
		.withConstraint(finalNodeWithControlOut)
		.withConstraint(forkNodeWithInvalidNumberOfIns)
		.withConstraint(forkNodeWithInvalidNumberOfOuts)
		.withConstraint(joinNodeWithInvalidNumberOfIns)
		.withConstraint(joinNodeWithInvalidNumberOfOuts)
		.withConstraint(decisionNodeWithInvalidNumberOfIns)
		.withConstraint(decisionNodeWithInvalidNumberOfOuts)
		.withConstraint(activityWithInvalidNumberOfControlIn)
		.withConstraint(activityWithInvalidNumberOfControlOut)
		.withConstraint(controlFlowWithInvalidNumberOfControlFrom)
		.withConstraint(controlFlowWithInvalidNumberOfControlTo)
		.withConstraint(redundantControlFlows)
		.withType(ModelQueryType::NO_MATCH)
		.withLevel(0)

	val globalReachability = new ModelQueriesHardObjective("globalReachability").withConstraint(initReachesFinal).
		withType(ModelQueryType::ALL_MUST_HAVE_MATCH).withLevel(1)	
}
