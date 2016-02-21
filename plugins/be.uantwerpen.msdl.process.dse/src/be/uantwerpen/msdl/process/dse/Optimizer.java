package be.uantwerpen.msdl.process.dse;

import java.util.Map;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.eclipse.viatra.dse.api.DSETransformationRule;
import org.eclipse.viatra.dse.api.DesignSpaceExplorer;
import org.junit.Test;

import be.uantwerpen.msdl.icm.queries.SharedPropertyMatch;
import be.uantwerpen.msdl.icm.queries.SharedPropertyMatcher;
import be.uantwerpen.msdl.icm.queries.util.SharedPropertyProcessor;
import be.uantwerpen.msdl.icm.queries.util.SharedPropertyQuerySpecification;
import be.uantwerpen.msdl.metamodels.process.Activity;
import be.uantwerpen.msdl.metamodels.process.ProcessModel;
import be.uantwerpen.msdl.metamodels.process.ProcessPackage;
import be.uantwerpen.msdl.metamodels.process.Property;

public class Optimizer {

	@Test
	public void explore() {
		// Load persisted model
		ProcessPackage.eINSTANCE.eClass();

		Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
		Map<String, Object> m = reg.getExtensionToFactoryMap();
		m.put("process", new XMIResourceFactoryImpl());
		ResourceSet resSet = new ResourceSetImpl();
		Resource resource = resSet.getResource(
				URI.createURI("file:///d:/GitHub/msdl/robot/be.uantwerpen.msdl.icm.robot/robot2.process"), true);
		ProcessModel processModel = (ProcessModel) resource.getContents().get(0);
		// System.out.println(processModel.getProcess().size());
		// ProcessModel targetModel =
		// ProcessFactory.eINSTANCE.createProcessModel();
		// targetModel.setName("target");
		// resource.getContents().add(targetModel);
		// System.out.println(processModel.getProcess().size());

		// Set up DSE engine
		DesignSpaceExplorer dse = new DesignSpaceExplorer();
		dse.setInitialModel(processModel);

		addTransformationRules(dse);

	}

	private void addTransformationRules(DesignSpaceExplorer dse) {
		try {
			DSETransformationRule<SharedPropertyMatch, SharedPropertyMatcher> rule = new DSETransformationRule<SharedPropertyMatch, SharedPropertyMatcher>(
					SharedPropertyQuerySpecification.instance(), new SharedPropertyProcessor() {

						@Override
						public void process(Activity pActivity1, Activity pActivity2, Property pProperty,
								be.uantwerpen.msdl.metamodels.process.Object pObject) {
							// TODO Auto-generated method stub
						}
					});

			dse.addTransformationRule(rule);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
