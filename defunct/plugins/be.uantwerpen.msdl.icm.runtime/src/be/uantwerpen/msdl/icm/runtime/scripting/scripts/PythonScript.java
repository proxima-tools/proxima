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

public class PythonScript implements IScript {

    private String scriptLocation;

    public PythonScript(String scriptLocation) {
        this.scriptLocation = scriptLocation;
    }

    public String getScriptLocation() {
        return scriptLocation;
    }
}
