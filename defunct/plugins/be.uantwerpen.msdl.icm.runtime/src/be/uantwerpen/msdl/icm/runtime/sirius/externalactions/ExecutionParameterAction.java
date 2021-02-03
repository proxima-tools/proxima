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

import java.util.Collection;
import java.util.Map;

import org.eclipse.emf.common.util.EMap;
import org.eclipse.emf.ecore.EObject;

import be.uantwerpen.msdl.processmodel.pm.AutomatedActivity;

public class ExecutionParameterAction extends IcmExternalJavaAction {

	@Override
	public void execute(Collection<? extends EObject> selections, Map<String, Object> parameters) {
		EMap<String, String> executionParameters = ((AutomatedActivity) selections.iterator().next())
				.getExecutionParameters();

		executionParameters.clear();

		String actualParameters = parameters.get(EXECUTION_PARAMETERS_PARAM_NAME).toString();
		if(actualParameters.isEmpty()){
			return;
		}
		
		for (String parameterEntry : actualParameters.toString().replace(" ", "")
				.split(",")) {
			String[] splitParameterEntry = parameterEntry.replace(" ", "").split(":");
			String key = splitParameterEntry[0];
			String value = splitParameterEntry[1];
			logger.debug(key + ": " + value);
			executionParameters.put(key, value);
		}
	}

	@Override
	public boolean canExecute(Collection<? extends EObject> selections) {
		return true;
	}

}
