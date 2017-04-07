/*******************************************************************************
 * Copyright (c) 2016-2017 Istvan David
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *    Istvan David - initial API and implementation
 *******************************************************************************/

package be.uantwerpen.msdl.icm.runtime.inconsistencymanager

import be.uantwerpen.msdl.icm.runtime.variablemanager.model.Relationship2
import be.uantwerpen.msdl.processmodel.properties.Relationship

class InconsistencyManager {

	def static reportError(Relationship relationship, Relationship2 relationship2) {
		System.err.println(
			String::format("Inconsistency detected at Relationship (%s) #%s with formula %s.",
				relationship.precision.literal, relationship.id, relationship.formula.definition))
	}

}
