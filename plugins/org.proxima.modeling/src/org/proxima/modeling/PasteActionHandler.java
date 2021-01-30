package org.proxima.modeling;

import java.util.List;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.sirius.diagram.ui.tools.internal.clipboard.SiriusClipboardManager;

import com.google.common.collect.Lists;

import org.proxima.pm.ProcessModel;

public class PasteActionHandler {

	private static PasteActionHandler instance;
	private Process process;
	private List<EObject> registeredPastes;

	public static PasteActionHandler getInstance(Process process) {
		if (instance == null) {
			instance = new PasteActionHandler(process);
		}
		return instance;
	}

	private PasteActionHandler(Process process) {
		this.process = process;
		this.registeredPastes = Lists.newArrayList();
	}

	public void registerPaste(EObject eObject) {
		registeredPastes.add(eObject);
		
	}
}
