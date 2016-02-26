package be.uantwerpen.msdl.process.dse;

import java.io.IOException;
import java.util.Collection;
import java.util.Collections;
import java.util.Map;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.eclipse.incquery.runtime.exception.IncQueryException;
import org.eclipse.viatra.dse.api.DesignSpaceExplorer;
import org.eclipse.viatra.dse.api.Solution;
import org.eclipse.viatra.dse.api.SolutionTrajectory;
import org.eclipse.viatra.dse.api.Strategies;
import org.eclipse.viatra.dse.statecoding.simple.SimpleStateCoderFactory;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import be.uantwerpen.msdl.metamodels.process.ControlFlow;
import be.uantwerpen.msdl.metamodels.process.ProcessModel;
import be.uantwerpen.msdl.metamodels.process.ProcessPackage;

public class Optimizer {

	private ResourceSet resSet;
	private Resource resource;

	@Before
	public void setup() {
		ProcessPackage.eINSTANCE.eClass();

		Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
		Map<String, Object> m = reg.getExtensionToFactoryMap();
		m.put("process", new XMIResourceFactoryImpl());
		resSet = new ResourceSetImpl();
		resource = resSet.getResource(
				URI.createURI("file:///D:/GitHub/msdl/robot/be.uantwerpen.msdl.icm.robot/robot2.process"), true);
	}

	@After
	public void tearDown() {
		resource = null;
		resSet = null;
	}

	@Test
	public void explore() throws IncQueryException, IOException {
		// Load persisted model

		ProcessModel processModel = (ProcessModel) resource.getContents().get(0);
		// System.out.println(processModel.getProcess().size());
		// ProcessModel targetModel =
		// ProcessFactory.eINSTANCE.createProcessModel();
		// targetModel.setName("target");
		// resource.getContents().add(targetModel);
		// System.out.println(processModel.getProcess().size());

		System.out.println("nodes");
		System.out.println(processModel.getProcess().get(0).getNode());
		System.out.println("connections");
		for (ControlFlow controlFlow : processModel.getProcess().get(0).getControlFlow()) {
			System.out.println(controlFlow.getFromNode() + " -> " + controlFlow.getToNode());
		}

		// Set up DSE engine
		DesignSpaceExplorer dse = new DesignSpaceExplorer();
		dse.setInitialModel(processModel);

		// Trafo rules
		new Rules().addTransformationRules(dse);

		// Objectives
		new Constraints().addConstraints(dse);

		// State coding
		dse.addMetaModelPackage(ProcessPackage.eINSTANCE);
		dse.setStateCoderFactory(new SimpleStateCoderFactory(dse.getMetaModelPackages()));

		// Start
		dse.startExploration(Strategies.createDFSStrategy(5));

		// Get results
		System.out.println(dse.getSolutions().size());

		System.out.println("persisting solution");

		Collection<Solution> solutions = dse.getSolutions();
		Solution solution = dse.getSolutions().iterator().next();
		SolutionTrajectory arbitraryTrajectory = solution.getArbitraryTrajectory();
		arbitraryTrajectory.setModel(processModel);
		arbitraryTrajectory.doTransformation();

		System.out.println("nodes");
		System.out.println(processModel.getProcess().get(0).getNode());
		System.out.println("connections");
		for (ControlFlow controlFlow : processModel.getProcess().get(0).getControlFlow()) {
			System.out.println(controlFlow.getFromNode() + " -> " + controlFlow.getToNode());
		}

		resource.save(Collections.EMPTY_MAP);

		System.out.println("solution persisted");
	}
}
