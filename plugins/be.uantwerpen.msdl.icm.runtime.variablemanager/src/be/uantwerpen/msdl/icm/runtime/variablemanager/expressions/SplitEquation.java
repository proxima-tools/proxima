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

package be.uantwerpen.msdl.icm.runtime.variablemanager.expressions;

public class SplitEquation {
	private String lhs;
	private Relation relation;
	private String rhs;

	public SplitEquation(String lhs, Relation relation, String rhs) {
		this.lhs = lhs;
		this.relation = relation;
		this.rhs = rhs;
	}

	public String getLhs() {
		return lhs;
	}

	public Relation getRelation() {
		return relation;
	}

	public String getRhs() {
		return rhs;
	}

	@Override
	public String toString() {
		return lhs + " " + relation.getSymbol() + " " + rhs;
	}
}
