package be.uantwerpen.msdl.process.dse;

import java.io.IOException;
import java.util.Collections;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import org.eclipse.incquery.runtime.base.api.TransitiveClosureHelper;
import org.eclipse.incquery.runtime.base.exception.IncQueryBaseException;
import org.eclipse.incquery.runtime.exception.IncQueryException;
import org.eclipse.viatra.dse.api.DesignSpaceExplorer;
import org.eclipse.viatra.dse.api.Solution;
import org.eclipse.viatra.dse.api.SolutionTrajectory;
import org.eclipse.viatra.dse.api.Strategies;
import org.eclipse.viatra.dse.statecoding.simple.SimpleStateCoderFactory;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import com.google.common.base.Stopwatch;

import be.uantwerpen.msdl.metamodels.process.ProcessModel;
import be.uantwerpen.msdl.metamodels.process.ProcessPackage;
import be.uantwerpen.msdl.process.dse.objectives.hard.ValidityHardObjectives;
import be.uantwerpen.msdl.process.dse.objectives.soft.SoftObjectives;
import be.uantwerpen.msdl.process.dse.rules.Rules;

public class Optimizer {

	private static final Level LEVEL = Level.DEBUG;

	private Logger logger;
	private ResourceSet resSet;
	private Resource resource;
	private TransitiveClosureHelper tcHelper;

	@Before
	public void setup() {
		logger = Logger.getLogger("Process DSE");
		logger.setLevel(LEVEL);

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
		tcHelper.dispose();
		logger = null;
	}

	@Test
	public void explore() throws IncQueryException, IOException, IncQueryBaseException {
		// Load persisted model
		ProcessModel processModel = (ProcessModel) resource.getContents().get(0);

		logger.debug("setting up engine");
		Stopwatch stopwatch = Stopwatch.createStarted();

		// Set up DSE engine
		DesignSpaceExplorer dse = new DesignSpaceExplorer();
		dse.setInitialModel(processModel);

		logger.debug("initial model set in " + stopwatch.elapsed(TimeUnit.MILLISECONDS) + " ms");
		stopwatch.reset().start();

		// Trafo rules
		new Rules().addTransformationRules(dse);
		logger.debug("trafo rules added in " + stopwatch.elapsed(TimeUnit.MILLISECONDS) + " ms");
		stopwatch.reset().start();

		// Objectives
		new ValidityHardObjectives().addConstraints(dse);
		new SoftObjectives().addConstraints(dse);
		logger.debug("objectives added in " + stopwatch.elapsed(TimeUnit.MILLISECONDS) + " ms");
		stopwatch.reset().start();

		// State coding
		dse.addMetaModelPackage(ProcessPackage.eINSTANCE);
		dse.setStateCoderFactory(new SimpleStateCoderFactory(dse.getMetaModelPackages()));
		logger.debug("state coding done in " + stopwatch.elapsed(TimeUnit.MILLISECONDS) + " ms");
		stopwatch.reset().start();

		logger.debug("starting");
		// Start
		dse.startExploration(Strategies.createDFSStrategy(5));

		logger.debug("exploration took " + stopwatch.elapsed(TimeUnit.MILLISECONDS) + " ms");
		stopwatch.stop();

		// Get results
		logger.debug("number of solutions: " + dse.getSolutions().size());

		logger.debug("persisting first solution");
		Solution solution = dse.getSolutions().iterator().next();
		SolutionTrajectory arbitraryTrajectory = solution.getArbitraryTrajectory();
		arbitraryTrajectory.setModel(processModel);
		arbitraryTrajectory.doTransformation();

		resource.save(Collections.EMPTY_MAP);

		logger.debug("solution persisted");
	}
}
