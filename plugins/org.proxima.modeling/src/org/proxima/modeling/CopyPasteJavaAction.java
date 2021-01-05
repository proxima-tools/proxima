package org.proxima.modeling;

import java.util.Collection;
import java.util.Map;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.transaction.TransactionalEditingDomain;
import org.eclipse.sirius.business.api.session.Session;
import org.eclipse.sirius.business.api.session.SessionManager;
import org.eclipse.sirius.diagram.ui.tools.internal.clipboard.SiriusClipboardManager;
import org.eclipse.sirius.tools.api.ui.IExternalJavaAction;
import org.proxima.modeling.services.Services;

import be.uantwerpen.msdl.proxima.processmodel.pm.ControlFlow;
import be.uantwerpen.msdl.proxima.processmodel.pm.Node;
import be.uantwerpen.msdl.proxima.processmodel.pm.ObjectFlow;
import be.uantwerpen.msdl.proxima.processmodel.pm.Process;

public class CopyPasteJavaAction implements IExternalJavaAction {

	public CopyPasteJavaAction() {
		// TODO Auto-generated constructor stub
		//System.out.println("hello0");
		//CopyPasteHeap.getInstance().getCopyHeap().clear();
	}

	@Override
	public boolean canExecute(Collection<? extends EObject> arg0) {
		// TODO Auto-generated method stub
		//System.out.println("hello1");
		return true;
	}

	@Override
	public void execute(Collection<? extends EObject> arg0, Map<String, Object> arg1) {
		Process process = (Process) arg0.iterator().next();

		EObject pasteElement = (EObject) arg1.values().iterator().next();

		//System.out.println("hello");
		//PasteActionHandler.getInstance(process).registerPaste(pasteElement);

		//System.out.println("bye");


		if (pasteElement instanceof Node) {
			paste((Node) pasteElement, process);
		}
//		else if (pasteElement instanceof ControlFlow) {
//			paste((ControlFlow) pasteElement, process);
//		} else if (pasteElement instanceof ObjectFlow) {
//			paste((ObjectFlow) pasteElement, process);
//		}
		else {
			System.err.println("Unsupported paste action.");
		}
	}

	private void paste(Node node, Process process) {
		//System.out.println("copying node " + node.toString());

		//CopyPasteHeap copyPasteHeap = CopyPasteHeap.getInstance();

		Node newNode = EcoreUtil.copy(node);
		newNode.setId(new Services().getId(newNode));

		process.getNode().add(newNode);
		//copyPasteHeap.getCopyHeap().put(node, newNode);

		// try to reroute objectFlows
//		EList<ObjectFlow> objectIn = node.getObjectIn();
//		for (ObjectFlow objectFlow : objectIn) {
//			if (copyPasteHeap.getCopyHeap().containsKey(objectFlow)) {
//				ObjectFlow newObjectFlow = (ObjectFlow) copyPasteHeap.getCopyHeap().get(objectFlow);
//				newNode.getObjectIn().add(newObjectFlow);
//			}
//		}
//		EList<ObjectFlow> objectOut = node.getObjectIn();
//		for (ObjectFlow objectFlow : objectOut) {
//			if (copyPasteHeap.getCopyHeap().containsKey(objectFlow)) {
//				ObjectFlow newObjectFlow = (ObjectFlow) copyPasteHeap.getCopyHeap().get(objectFlow);
//				newNode.getObjectIn().add(newObjectFlow);
//			}
//		}
//
//		System.out.println("success");
	}

	private void paste(ControlFlow controlFlow, Process process) {
		System.out.println("copying controlFlow " + controlFlow.toString());
	}

	private void paste(ObjectFlow objectFlow, Process process) {
		CopyPasteHeap copyPasteHeap = CopyPasteHeap.getInstance();

		ObjectFlow newObjectFlow = EcoreUtil.copy(objectFlow);
		newObjectFlow.setId(new Services().getId(newObjectFlow));

		process.getObjectFlow().add(newObjectFlow);
		copyPasteHeap.getCopyHeap().put(objectFlow, newObjectFlow);

		// try to reroute
		Node oldFrom = objectFlow.getFrom();
		Node oldTo = objectFlow.getTo();

		if (copyPasteHeap.getCopyHeap().containsKey(oldFrom)) {
			newObjectFlow.setFrom((Node) copyPasteHeap.getCopyHeap().get(oldFrom));
		}
		if (copyPasteHeap.getCopyHeap().containsKey(oldTo)) {
			newObjectFlow.setTo((Node) copyPasteHeap.getCopyHeap().get(oldTo));
		}

		System.out.println("success");
	}

}
