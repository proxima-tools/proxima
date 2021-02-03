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

package be.uantwerpen.msdl.icm.tooling.core.nature;

import org.eclipse.core.resources.ICommand;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IProjectDescription;
import org.eclipse.core.resources.IProjectNature;
import org.eclipse.core.runtime.CoreException;

public class ProcessModelerProjectNature implements IProjectNature {

    public static final String NATURE_ID = "be.uantwerpen.msdl.icm.projectnature"; //$NON-NLS-1$
    public static final String BUILDER_ID = "be.uantwerpen.msdl.icm.projectbuilder";//$NON-NLS-1$
    public static final String EXECUTION_ENVIRONMENT = "JavaSE-1.7"; // $NON_NLS-1$

    private IProject project;

    @Override
    public void configure() throws CoreException {
        IProjectDescription description = project.getDescription();
        ICommand[] commands = description.getBuildSpec();
        for (int i = 0; i < commands.length; i++) {
            if (commands[i].getBuilderName().equals(BUILDER_ID)) {
                return; // Builder is already configured, returning
            }
        }

        ICommand command = description.newCommand();
        command.setBuilderName(BUILDER_ID);
        ICommand[] newCommandList = new ICommand[commands.length + 1];
        System.arraycopy(commands, 0, newCommandList, 1, commands.length);
        newCommandList[0] = command;
        description.setBuildSpec(newCommandList);
        project.setDescription(description, null);
    }

    @Override
    public void deconfigure() throws CoreException {
        IProjectDescription desc = project.getDescription();
        ICommand[] commands = desc.getBuildSpec();
        int index = 0;
        for (; index < commands.length; index++) {
            if (commands[index].getBuilderName().equals(BUILDER_ID)) {
                break; // Builder found
            }
        }
        if (index == commands.length) {
            return;
        }
        ICommand command = desc.newCommand();
        command.setBuilderName(BUILDER_ID);
        ICommand[] newCommandList = new ICommand[commands.length - 1];
        if (newCommandList.length > 0) {
            System.arraycopy(commands, 0, newCommandList, 0, index);
            System.arraycopy(commands, index + 1, newCommandList, index, commands.length - index);
        }
        desc.setBuildSpec(newCommandList);
        project.setDescription(desc, null);
    }

    @Override
    public IProject getProject() {
        return project;
    }

    @Override
    public void setProject(IProject project) {
        this.project = project;
    }

}
