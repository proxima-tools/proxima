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

package be.uantwerpen.msdl.icm.tooling.ui;

import org.eclipse.core.expressions.PropertyTester;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.sirius.diagram.DDiagram;
import org.eclipse.sirius.diagram.ui.edit.api.part.IDiagramElementEditPart;
import org.eclipse.sirius.ui.business.api.dialect.DialectEditor;
import org.eclipse.sirius.viewpoint.DRepresentation;

public class DiagramTester extends PropertyTester {

    private static final String DIAGRAM_NAME = "ProcessModel";

    @Override
    public boolean test(Object receiver, String property, Object[] args, Object expectedValue) {
        if ("isConcernedEditor".equals(property)) {
            // called in a with activeEditor element
            if (receiver instanceof DialectEditor) {
                DRepresentation activeRepresentation = ((DialectEditor) receiver).getRepresentation();
                if (activeRepresentation instanceof DDiagram) {
                    // the id property in the VSM editor : name in the meta
                    // model.
                    String diagramName = ((DDiagram) activeRepresentation).getDescription().getName();
                    return DIAGRAM_NAME.equals(diagramName);
                }
            }
        }
        else 
            if ("shouldActivateIcmMenu".equals(property)) {
            if (receiver instanceof IDiagramElementEditPart) {
                EObject domainElement = ((IDiagramElementEditPart) receiver).resolveTargetSemanticElement();
                // TODO
                return domainElement instanceof EClass && ((EClass) domainElement).isAbstract();
            }
        }
        return false;
    }

}
