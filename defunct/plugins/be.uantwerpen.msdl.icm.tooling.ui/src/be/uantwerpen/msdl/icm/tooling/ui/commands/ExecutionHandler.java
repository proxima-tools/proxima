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

package be.uantwerpen.msdl.icm.tooling.ui.commands;

import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;

/**
 * @author Istvan David
 *
 */
public class ExecutionHandler extends Handler {

    @Override
    public Object execute(ExecutionEvent event) throws ExecutionException {
        logger.debug("MOCK execution running");
        System.out.println(getModel().getProcess().get(0).getNode().size());
        return null;
    }

}
