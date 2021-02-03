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

package be.uantwerpen.msdl.icm.runtime.sirius.externalactions;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.eclipse.sirius.tools.api.ui.IExternalJavaAction;

public abstract class IcmExternalJavaAction implements IExternalJavaAction {
	protected static final String CODEGEN_LOCATION_PARAM_NAME = "location";
	protected static final String CODEGEN_ROOTPACKAGE_PARAM_NAME = "rootPackage";
	protected static final String EXECUTION_PARAMETERS_PARAM_NAME = "parameters";
	
	protected Logger logger = Logger.getLogger(this.getClass());

	public IcmExternalJavaAction() {
		logger.setLevel(Level.DEBUG);
	}
}
