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

package be.uantwerpen.msdl.process.dse.rules

import be.uantwerpen.msdl.process.dse.rules.parallel.ParallelModify
import be.uantwerpen.msdl.process.dse.rules.sequential.ReadModify

class RulesFactory {

	public static val ruleGroups = #[
		new ReadModify,
		new ParallelModify
	]
}
