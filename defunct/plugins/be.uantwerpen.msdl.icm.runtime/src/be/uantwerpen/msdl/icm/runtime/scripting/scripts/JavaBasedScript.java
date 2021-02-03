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

package be.uantwerpen.msdl.icm.runtime.scripting.scripts;

import org.apache.log4j.Logger;

import be.uantwerpen.msdl.processmodel.pm.AutomatedActivity;

public abstract class JavaBasedScript implements IScript, Runnable {

    protected Logger logger = Logger.getLogger(this.getClass().getCanonicalName());

    private AutomatedActivity automatedActivity;

    public AutomatedActivity getAutomatedActivity() {
        return automatedActivity;
    }

    public void setAutomatedActivity(AutomatedActivity automatedActivity) {
        this.automatedActivity = automatedActivity;
    }
}
