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

import java.io.ByteArrayInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IProjectDescription;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.NullProgressMonitor;
import org.eclipse.jdt.core.IClasspathEntry;
import org.eclipse.jdt.core.IJavaProject;
import org.eclipse.jdt.core.IPackageFragmentRoot;
import org.eclipse.jdt.core.JavaCore;
import org.eclipse.jdt.core.JavaModelException;
import org.eclipse.jdt.launching.IVMInstall;
import org.eclipse.jdt.launching.JavaRuntime;
import org.eclipse.jdt.launching.LibraryLocation;
import org.eclipse.ui.dialogs.WizardNewProjectCreationPage;
import org.eclipse.ui.wizards.newresource.BasicNewProjectResourceWizard;

import be.uantwerpen.msdl.icm.tooling.core.nature.ProcessModelerProjectNature;

public class NewProjectWizard extends BasicNewProjectResourceWizard {

    @Override
    public boolean performFinish() {
        super.performFinish();

        final IProject projectHandle = ((WizardNewProjectCreationPage) getPage("basicNewProjectPage"))
                .getProjectHandle();

        try {
            addProjectNature(projectHandle, ProcessModelerProjectNature.NATURE_ID);
            addProjectNature(projectHandle, "org.eclipse.jdt.core.javanature");
            addProjectNature(projectHandle, "org.eclipse.sirius.nature.modelingproject");

            List<IClasspathEntry> entries = new ArrayList<IClasspathEntry>();
            IVMInstall vmInstall = JavaRuntime.getDefaultVMInstall();
            LibraryLocation[] locations = JavaRuntime.getLibraryLocations(vmInstall);
            for (LibraryLocation element : locations) {
                entries.add(JavaCore.newLibraryEntry(element.getSystemLibraryPath(), null, null));
            }
            // add libs to project class path
            IJavaProject javaProject = JavaCore.create(projectHandle);
            javaProject.setRawClasspath(entries.toArray(new IClasspathEntry[entries.size()]), null);

            createFolder(projectHandle, javaProject, "src");
            createFolder(projectHandle, javaProject, "src-gen");
            createFolder(projectHandle, javaProject, "process");

            createFile(projectHandle, "process/process.processmodel");
            createFile(projectHandle, "process/representations.aird");  //TODO fixme

        } catch (CoreException e) {
            e.printStackTrace();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        return true;
    }

    private void createFolder(IProject projectHandle, IJavaProject javaProject, String folderName)
            throws CoreException {
        IFolder folder = projectHandle.getFolder(folderName);
        folder.create(false, true, null);

        if (folderName.equalsIgnoreCase("src") || folderName.equalsIgnoreCase("src-gen")) {
            addToClassEntry(projectHandle, javaProject, folderName);
        }
    }

    private void createFile(IProject projectHandle, String fileName) throws CoreException, FileNotFoundException {
        InputStream inputStream = null;

        if (fileName.contains("processmodel")) {
            inputStream = new ByteArrayInputStream(
                    Templates.getProcessModelTemplate().toString().getBytes(StandardCharsets.UTF_8));
        } else if (fileName.contains("aird")) {
            inputStream = new ByteArrayInputStream(
                    Templates.getRepresentationsTemplate().toString().getBytes(StandardCharsets.UTF_8));
        }

        IFile file = projectHandle.getFile(fileName);
        file.create(inputStream, true, null);
    }

    private void addToClassEntry(IProject projectHandle, IJavaProject javaProject, String folderName)
            throws JavaModelException {
        IPackageFragmentRoot root = javaProject.getPackageFragmentRoot(projectHandle.getFolder(folderName));
        IClasspathEntry[] oldEntries = javaProject.getRawClasspath();
        IClasspathEntry[] newEntries = new IClasspathEntry[oldEntries.length + 1];
        System.arraycopy(oldEntries, 0, newEntries, 0, oldEntries.length);
        newEntries[oldEntries.length] = JavaCore.newSourceEntry(root.getPath());
        javaProject.setRawClasspath(newEntries, null);
    }

    private void addProjectNature(final IProject projectHandle, String nature) throws CoreException {
        IProjectDescription description = projectHandle.getDescription();
        String[] natures = description.getNatureIds();
        String[] newNatures = new String[natures.length + 1];
        System.arraycopy(natures, 0, newNatures, 0, natures.length);
        newNatures[natures.length] = nature;
        description.setNatureIds(newNatures);
        projectHandle.setDescription(description, new NullProgressMonitor());
    }
}
