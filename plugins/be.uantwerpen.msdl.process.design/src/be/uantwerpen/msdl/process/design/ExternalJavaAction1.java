package be.uantwerpen.msdl.process.design;

import java.util.Collection;
import java.util.Map;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.sirius.tools.api.ui.IExternalJavaAction;

public class ExternalJavaAction1 implements IExternalJavaAction {

	public ExternalJavaAction1() {
	}

	@Override
	public boolean canExecute(Collection<? extends EObject> arg0) {
		return true;
	}

	@Override
	public void execute(Collection<? extends EObject> arg0, Map<String, Object> arg1) {
		System.out.println("External Java action executing");

	}

}
