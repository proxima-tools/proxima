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

package be.uantwerpen.msdl.process.dse.objectives.soft

import be.uantwerpen.msdl.icm.queries.inconsistencies.UnmanagedPatterns
import org.eclipse.viatra.dse.api.DesignSpaceExplorer
import org.eclipse.viatra.dse.objectives.Comparators
import org.eclipse.viatra.dse.objectives.impl.ConstraintsObjective

class SoftObjectives {

	val extension UnmanagedPatterns unmanagedPatterns = UnmanagedPatterns::instance

	def addConstraints(DesignSpaceExplorer dse) {
		objectives.forEach [ objective |
			dse.addObjective(objective)
		]
	}

	def objectives() {
		#[
			consistencyObjective.withLevel(0),
			cheapestProcessObjective.withLevel(1)
		]

	}

	val consistencyObjective = new ConstraintsObjective().withSoftConstraint("consistencyObjective",
		unmanagedReadModify, 10d).withComparator(Comparators.LOWER_IS_BETTER)

	val cheapestProcessObjective = new CheapestProcessSoftObjective().withComparator(Comparators.LOWER_IS_BETTER)
}
