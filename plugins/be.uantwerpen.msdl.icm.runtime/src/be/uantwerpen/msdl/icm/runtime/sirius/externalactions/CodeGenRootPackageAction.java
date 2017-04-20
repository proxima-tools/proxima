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

import be.uantwerpen.msdl.processmodel.ProcessModel;

public class CodeGenRootPackageAction extends IcmExternalJavaAction {

	@Override
	public void execute(Collection<? extends EObject> selections, Map<String, Object> parameters) {
		EMap<String, String> codeGenProperties = ((ProcessModel) selections.iterator().next()).getCodeGenProperties();
		codeGenProperties.put(CODEGEN_ROOTPACKAGE_PARAM_NAME, parameters.get(CODEGEN_ROOTPACKAGE_PARAM_NAME).toString());
	}

	@Override
	public boolean canExecute(Collection<? extends EObject> selections) {
		return true;
	}

}
