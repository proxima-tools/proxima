package be.uantwerpen.msdl.process.dse

import be.uantwerpen.msdl.icm.queries.processrewrite.ProcessRewrite
import be.uantwerpen.msdl.icm.queries.validation.Validation
import org.eclipse.viatra.dse.api.DesignSpaceExplorer
import org.eclipse.viatra.dse.objectives.Comparators
import org.eclipse.viatra.dse.objectives.impl.ModelQueriesHardObjective
import org.eclipse.viatra.dse.objectives.impl.ModelQueryType
import org.eclipse.viatra.dse.objectives.impl.WeightedQueriesSoftObjective

class Constraints {

	val extension ProcessRewrite processRewriteQueries = ProcessRewrite::instance
	val extension Validation validationQueries = Validation::instance

	def addConstraints(DesignSpaceExplorer dse) {
//		globalConstraints.forEach [ constraint |
//			dse.addGlobalConstraint(constraint)
//		]
		hardObjectives.forEach [ objective |
			dse.addObjective(objective)
		]
		softObjectives.forEach [ objective |
			dse.addObjective(objective)
		]
	}

	def globalConstraints() {
		#[
//			globalConstraint
		]
	}

	def hardObjectives() {
		#[
			validationObjectives
//			,validationObjectives2
			,
			globalReachability
//			initNodeControl,
//			finalNodeControl
		]
	}

	def softObjectives() {
		#[parallelizationObjective]
	}

//	val globalConstraint = new ModelQueriesGlobalConstraint("globalConstraints1")
//		.withConstraint(initNodeInvalidIns)
//		.withConstraint(finalNodeInvalidOuts)
//		.withType(ModelQueryType::NO_MATCH)

	val validationObjectives = new ModelQueriesHardObjective("validProcess")
		.withConstraint(initNodeWithControlIn)
		.withConstraint(initNodeWithInvalidNumberOfControlOut)
		.withConstraint(finalNodeWithInvalidNumberOfIns)
		.withConstraint(finalNodeWithControlOut)
//		.withConstraint(forkNodeInOutRulesInvalid)
//		.withConstraint(joinNodeInOutRulesInvalid)
//		.withConstraint(decisionNodeInOutRulesInvalid)
		.withConstraint(activityWithInvalidNumberOfControlIn)
		.withConstraint(activityWithInvalidNumberOfControlOut)
		.withType(ModelQueryType::NO_MATCH)
	
	val globalReachability = new ModelQueriesHardObjective("globalReachability")
		.withConstraint(initReachesFinal)
		.withType(ModelQueryType::ALL_MUST_HAVE_MATCH)

//	val stronglyConnectedGraph = new ModelQueriesHardObjective("stronglyConnectedGraph").withConstraint(
//		activityIsNotUsedInTheProcess).withType(ModelQueryType.NO_MATCH)
//	val initNodeControl = new ModelQueriesHardObjective("initNodeControl").withConstraint(initNodeHasOneControlOutput).
//		withType(ModelQueryType.ALL_MUST_HAVE_MATCH)
//
//	val finalNodeControl = new ModelQueriesHardObjective("finalNodeControl").withConstraint(
//		finalNodeHasAtLeastOneControlInput).withType(ModelQueryType.ALL_MUST_HAVE_MATCH)
	val parallelizationObjective = new WeightedQueriesSoftObjective("maxForkOut").withConstraint(forkOutControl, 1).
		withComparator(Comparators.HIGHER_IS_BETTER)

}
