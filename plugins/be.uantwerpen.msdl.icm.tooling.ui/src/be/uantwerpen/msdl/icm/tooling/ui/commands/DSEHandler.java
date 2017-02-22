/*******************************************************************************
 * Copyright (c) 2016 Istvan David
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *    Istvan David - initial API and implementation
 *******************************************************************************/

package be.uantwerpen.msdl.icm.tooling.ui.commands;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.runtime.Assert;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.gmf.runtime.notation.Diagram;
import org.eclipse.sirius.diagram.business.internal.metamodel.spec.DSemanticDiagramSpec;
import org.eclipse.sirius.ui.business.api.session.SessionEditorInput;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.IEditorReference;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.internal.EditorReference;

import be.uantwerpen.msdl.process.dse.DSERunner;
import be.uantwerpen.msdl.processmodel.ProcessModel;

/**
 * @author Istvan David
 *
 */
public class DSEHandler extends org.eclipse.core.commands.AbstractHandler {

	private static final String SIRIUS_DIAGRAM_EDITOR_ID = "org.eclipse.sirius.diagram.ui.part.SiriusDiagramEditorID";

	private Logger logger = Logger.getLogger("DSE Handler");

	@Override
	public Object execute(ExecutionEvent event) throws ExecutionException {
		logger.setLevel(Level.DEBUG);
		logger.debug("Execute DSE!");

		IEditorReference[] editorReferences = PlatformUI.getWorkbench().getActiveWorkbenchWindow().getActivePage()
				.getEditorReferences();

		IEditorReference editor = null;

		for (IEditorReference iEditorReference : editorReferences) {
			EditorReference editRef = (EditorReference) iEditorReference;
			if (editRef.getDescriptor().getId().equalsIgnoreCase(SIRIUS_DIAGRAM_EDITOR_ID)) {
				editor = editRef;
				break;
			}
		}

		EObject input = null;

		try {
			IEditorInput editorInput = editor.getEditorInput();
			if (editorInput instanceof SessionEditorInput) {
				input = ((SessionEditorInput) editorInput).getInput();
			}
		} catch (PartInitException e) {
			e.printStackTrace();
		}

		EObject model = null;

		if (input instanceof Diagram) {
			EObject element = ((Diagram) input).getElement();
			if (element instanceof DSemanticDiagramSpec) {
				model = ((DSemanticDiagramSpec) element).getTarget();
			}
		}

		Assert.isTrue(model instanceof ProcessModel, "Fatal error: model not instance of ProcessModel.");

		DSERunner dseRunner = new DSERunner((ProcessModel) model);
		logger.debug("TEST MOCK: DSE EXECUTING");
//		dseRunner.explore();

		//TODO refresh diagram once execution successfully finished
		
		return null;
	}

}
