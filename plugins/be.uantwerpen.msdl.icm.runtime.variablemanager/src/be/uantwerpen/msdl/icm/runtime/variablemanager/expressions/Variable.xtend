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

package be.uantwerpen.msdl.icm.runtime.variablemanager.expressions

import org.eclipse.xtend.lib.annotations.Accessors

class Variable {
	@Accessors(PUBLIC_GETTER) String name
	@Accessors(#[PUBLIC_GETTER, PUBLIC_SETTER]) Double value

	new(String name, Double value) {
		this.name = name
		this.value = value
	}

	def isBound() {
		value != null
	}

	override equals(Object obj) {
		if (obj instanceof Variable) {
			if ((obj as Variable).name.equals(this.name)) {
				return true
			}
		}
		return false;
	}

	override hashCode() {
		var hash = 3
		if (this.name != null) {
			hash = 53 * hash + this.name.hashCode
		}
		if (this.value != null) {
			hash = 53 * hash + this.value.hashCode
		}
		return hash
	}

}
