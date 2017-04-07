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

package be.uantwerpen.msdl.icm.runtime.variablemanager.model

import org.eclipse.xtend.lib.annotations.Accessors

class Result {
	@Accessors(PUBLIC_GETTER) String variableName
	@Accessors(PUBLIC_GETTER) double value

	new(String variableName, double value) {
		this.variableName = variableName;
		this.value = value;
	}
}
