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

package be.uantwerpen.msdl.icm.runtime.variablemanager.trace

import be.uantwerpen.msdl.icm.runtime.variablemanager.expressions.Variable
import org.eclipse.xtend.lib.annotations.Accessors

class VariableModification {
	@Accessors(PUBLIC_GETTER) String variableName
	@Accessors(PUBLIC_GETTER) Double previousValue
	@Accessors(PUBLIC_GETTER) Double newValue
	
	new(String variableName, Double previousValue, Double newValue){
		this.variableName = variableName
		this.previousValue = previousValue
		this.newValue = newValue
	}
	
	new(Variable variable, Double previousValue, Double newValue){
		this.variableName = variable.name
		this.previousValue = previousValue
		this.newValue = newValue
	}
}