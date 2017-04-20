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

package be.uantwerpen.msdl.icm.runtime;

import java.util.Map;

import org.junit.Test;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import be.uantwerpen.msdl.icm.runtime.sirius.externalactions.ExecutionParameterAction;
import be.uantwerpen.msdl.processmodel.pm.PmFactory;

public class ParamParseTest {

	@Test
	public void testParamParsing() {
		ExecutionParameterAction action = new ExecutionParameterAction();
		String params = "param1: value1, param2: value2";
		Map<String, Object> parameters = Maps.newHashMap();
		parameters.put("parameters", params);
		action.execute(Lists.newArrayList(PmFactory.eINSTANCE.createAutomatedActivity()), parameters);
	}
}
