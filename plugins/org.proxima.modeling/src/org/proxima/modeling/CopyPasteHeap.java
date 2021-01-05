package org.proxima.modeling;

import java.util.Map;

import org.eclipse.emf.ecore.EObject;

import com.google.common.collect.Maps;

public class CopyPasteHeap {

	private static CopyPasteHeap instance;

	private Map<EObject, EObject> copyHeap = Maps.newLinkedHashMap();

	public static CopyPasteHeap getInstance() {
		if (instance == null) {
			instance = new CopyPasteHeap();
		}
		return instance;
	}

	private CopyPasteHeap() {
	}

	public Map<EObject, EObject> getCopyHeap() {
		return copyHeap;
	}
}
