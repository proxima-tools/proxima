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

package be.uantwerpen.msdl.icm.tooling.ui.wizards;

import java.util.List;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IProjectDescription;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.ui.actions.WorkspaceModifyOperation;

public class CreateProjectOperation extends WorkspaceModifyOperation {
    private final IProject projectHandle;
    private final IProjectDescription description;
    private final List<String> dependencies;

    public CreateProjectOperation(IProject projectHandle, IProjectDescription description, List<String> dependencies) {
        this.projectHandle = projectHandle;
        this.description = description;
        this.dependencies = dependencies;
    }

    protected void execute(IProgressMonitor monitor) throws CoreException {
        createProject(description, projectHandle, dependencies, monitor);
    }

    private void createProject(IProjectDescription description2, IProject projectHandle2, List<String> dependencies2,
            IProgressMonitor monitor) {
        // TODO The actual project creation logic comes here
    }
}