/*******************************************************************************
 * Copyright (c) 2016 Istvan David
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *    Istvan David - initial API and implementation
 *******************************************************************************/

package be.uantwerpen.msdl.process.dse.objectives.hard

import be.uantwerpen.msdl.icm.queries.validation.Validation
import org.eclipse.viatra.dse.api.DesignSpaceExplorer
import org.eclipse.viatra.dse.objectives.impl.ConstraintsObjective
import org.eclipse.viatra.dse.objectives.impl.ModelQueriesGlobalConstraint
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
			globalConstraint
		]
	}

	def objectives() {
		#[
			validationObjectives
		]
	}

	val globalConstraint = new ModelQueriesGlobalConstraint("globalConstraints1")
		.withConstraint(initNodeWithControlIn)
		.withConstraint(finalNodeWithControlOut)
		.withType(ModelQueryType::NO_MATCH)

	val validationObjectives = new ConstraintsObjective("validProcess")
		.withHardConstraint(initNodeWithInvalidNumberOfControlOut, ModelQueryType::NO_MATCH)
		.withHardConstraint(initNodeWithControlIn, ModelQueryType::NO_MATCH)
		.withHardConstraint(finalNodeWithInvalidNumberOfIns, ModelQueryType::NO_MATCH)
		.withHardConstraint(finalNodeWithControlOut, ModelQueryType::NO_MATCH)
		.withHardConstraint(forkNodeWithInvalidNumberOfIns, ModelQueryType::NO_MATCH)
		.withHardConstraint(forkNodeWithInvalidNumberOfOuts, ModelQueryType::NO_MATCH)
		.withHardConstraint(joinNodeWithInvalidNumberOfIns,ModelQueryType::NO_MATCH)
		.withHardConstraint(joinNodeWithInvalidNumberOfOuts, ModelQueryType::NO_MATCH)
		.withHardConstraint(decisionNodeWithInvalidNumberOfIns, ModelQueryType::NO_MATCH)
		.withHardConstraint(decisionNodeWithInvalidNumberOfOuts, ModelQueryType::NO_MATCH)
		.withHardConstraint(activityWithInvalidNumberOfControlIn, ModelQueryType::NO_MATCH)
		.withHardConstraint(activityWithInvalidNumberOfControlOut, ModelQueryType::NO_MATCH)
		.withHardConstraint(controlFlowWithInvalidNumberOfControlFrom, ModelQueryType::NO_MATCH)
		.withHardConstraint(controlFlowWithInvalidNumberOfControlTo, ModelQueryType::NO_MATCH)
//		.withHardConstraint(redundantControlFlows,ModelQueryType::NO_MATCH)
		.withHardConstraint(finalNotReachableFromNode, ModelQueryType::NO_MATCH)
		.withHardConstraint(initDoesNotReachNode, ModelQueryType::NO_MATCH).withLevel(0)
}
