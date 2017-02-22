package be.uantwerpen.msdl.icm.runtime;

import java.util.List;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.google.common.collect.Lists;

import be.uantwerpen.msdl.enactment.Enactment;
import be.uantwerpen.msdl.enactment.EnactmentFactory;
import be.uantwerpen.msdl.processmodel.ProcessModel;
import be.uantwerpen.msdl.processmodel.ProcessmodelFactory;
import be.uantwerpen.msdl.processmodel.ftg.FormalismTransformationGraph;
import be.uantwerpen.msdl.processmodel.ftg.FtgFactory;
import be.uantwerpen.msdl.processmodel.pm.ControlFlow;
import be.uantwerpen.msdl.processmodel.pm.Node;
import be.uantwerpen.msdl.processmodel.pm.PmFactory;
import be.uantwerpen.msdl.processmodel.pm.Process;

public class ProcessEngineTests {

	private RuntimeRules engine;

	@Before
	public void setUp() {
		engine = new RuntimeRules();
	}

	@Test
	public void initializationTest() {
		// create enactment
		Enactment enactment = EnactmentFactory.eINSTANCE.createEnactment();

		// create process model
		ProcessModel processModel = ProcessmodelFactory.eINSTANCE.createProcessModel();

		// create parts of the process model
		// the required ftg
		FormalismTransformationGraph ftg = FtgFactory.eINSTANCE.createFormalismTransformationGraph();
		processModel.setFtg(ftg);

		// a process
		Process process = PmFactory.eINSTANCE.createProcess();
		processModel.getProcess().add(process);
		//nodes
		List<Node> nodes = Lists.newArrayList();
		nodes.add(PmFactory.eINSTANCE.createInitial());
		nodes.add(PmFactory.eINSTANCE.createAutomatedActivity());
		nodes.add(PmFactory.eINSTANCE.createFlowFinal());
		process.getNode().addAll(nodes);

		//control flow
		for (Node node : nodes) {
			int index = nodes.indexOf(node);
			if (index == nodes.size() - 1) {
				continue;
			}
			ControlFlow controlFlow = PmFactory.eINSTANCE.createControlFlow();
			controlFlow.setFrom(node);
			controlFlow.setTo(nodes.get(index + 1));
			process.getControlFlow().add(controlFlow);
		}

		// the rest is not required for a valid process model

		// set enacted process model
		enactment.setEnactedProcessModel(processModel);
		engine.setEnactment(enactment);
	}

	@After
	public void tearDown() {
		engine = null;
	}
}
