package be.uantwerpen.msdl.icm.runtime.sirius.externalactions;

import java.util.Collection;
import java.util.Map;

import org.apache.log4j.Logger;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.sirius.tools.api.ui.IExternalJavaAction;

import be.uantwerpen.msdl.icm.runtime.codegen.CodeGenConfig;

public class CodeGenLocationAction implements IExternalJavaAction {
	Logger logger = Logger.getLogger(this.getClass());

	public CodeGenLocationAction() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public void execute(Collection<? extends EObject> selections, Map<String, Object> parameters) {
		String location = (String) parameters.get("location");
		CodeGenConfig.instance().setLocation(location);
	}

	@Override
	public boolean canExecute(Collection<? extends EObject> selections) {
		return true;
	}

}
