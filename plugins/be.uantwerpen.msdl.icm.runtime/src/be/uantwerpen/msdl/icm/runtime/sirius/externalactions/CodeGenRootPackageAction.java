package be.uantwerpen.msdl.icm.runtime.sirius.externalactions;

import java.util.Collection;
import java.util.Map;

import org.apache.log4j.Logger;
import org.eclipse.emf.common.util.EMap;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.sirius.tools.api.ui.IExternalJavaAction;

import be.uantwerpen.msdl.processmodel.ProcessModel;

public class CodeGenRootPackageAction implements IExternalJavaAction {
	Logger logger = Logger.getLogger(this.getClass());

	public CodeGenRootPackageAction() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public void execute(Collection<? extends EObject> selections, Map<String, Object> parameters) {
		EMap<String, String> codeGenProperties = ((ProcessModel) selections.iterator().next()).getCodeGenProperties();
		codeGenProperties.put("rootPackage", parameters.get("rootPackage").toString());
	}

	@Override
	public boolean canExecute(Collection<? extends EObject> selections) {
		return true;
	}

}
