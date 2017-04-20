package be.uantwerpen.msdl.icm.runtime.sirius.externalactions;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.eclipse.sirius.tools.api.ui.IExternalJavaAction;

public abstract class IcmExternalJavaAction implements IExternalJavaAction {
	protected static final String CODEGEN_LOCATION_PARAM_NAME = "location";
	protected static final String CODEGEN_ROOTPACKAGE_PARAM_NAME = "rootPackage";
	protected static final String EXECUTION_PARAMETERS_PARAM_NAME = "parameters";
	
	protected Logger logger = Logger.getLogger(this.getClass());

	public IcmExternalJavaAction() {
		logger.setLevel(Level.DEBUG);
	}
}
