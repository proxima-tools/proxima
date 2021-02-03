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

package be.uantwerpen.msdl.process.dse

import be.uantwerpen.msdl.processmodel.ProcessModel
import org.apache.log4j.Level

/**
 * Public interface for running the DSE.
 */
class DSERunner extends AbstractDSERunner {

	new(ProcessModel processModel) {
		logger.level = Level::DEBUG
		this.processModel = processModel
		this.resource = processModel.eResource
	}
}
