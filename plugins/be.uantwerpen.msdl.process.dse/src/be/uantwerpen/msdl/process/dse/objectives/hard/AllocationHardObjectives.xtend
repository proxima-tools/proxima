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

import be.uantwerpen.msdl.icm.queries.allocation.Allocation
import org.eclipse.viatra.dse.api.DesignSpaceExplorer
import org.eclipse.viatra.dse.objectives.impl.ConstraintsObjective
import org.eclipse.viatra.dse.objectives.impl.ModelQueryType

class AllocationHardObjectives {
	val extension Allocation = Allocation::instance

	def addConstraints(DesignSpaceExplorer dse) {
		objectives.forEach [ objective |
			dse.addObjective(objective)
		]
	}

	def objectives() {
		#[
			allocationObjectives
		]
	}

	val allocationObjectives = new ConstraintsObjective("validAllocation").withHardConstraint(unAllocatedActivity,
		ModelQueryType::NO_MATCH).withLevel(0)
}
