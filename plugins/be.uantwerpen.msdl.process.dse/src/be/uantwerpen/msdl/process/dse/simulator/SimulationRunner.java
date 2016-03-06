package be.uantwerpen.msdl.process.dse.simulator;

import java.util.Map;
import java.util.WeakHashMap;

import org.eclipse.emf.common.notify.Notifier;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.viatra.dse.base.DesignSpaceManager;
import org.eclipse.viatra.dse.base.ThreadContext;
import org.eclipse.viatra.dse.designspace.api.IState;
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine;

import be.uantwerpen.msdl.metamodels.process.ProcessModel;

public class SimulationRunner {

	private static Map<Notifier, SimulationRunner> sims = new WeakHashMap<Notifier, SimulationRunner>();

	public static synchronized SimulationRunner create(ThreadContext context) {
		EObject modelRoot = context.getModelRoot();
		SimulationRunner sim = sims.get(modelRoot);
		if (sim == null) {
			sim = new SimulationRunner();
			sim.init(context);
			sims.put(modelRoot, sim);
		}
		return sim;
	}

	private double cost;
	private ProcessModel modelRoot;
	private IState lastState = null;
	private DesignSpaceManager dsm;
	private ViatraQueryEngine queryEngine;

	private SimulationRunner() {
	}

	private void init(ThreadContext context) {
		modelRoot = (ProcessModel) context.getModelRoot();
		dsm = context.getDesignSpaceManager();
		queryEngine = context.getQueryEngine();
	}

	public void runSimulation() {
		if (dsm.getCurrentState().getId().equals(lastState)) {
			return;
		}

		FixedIterationCostSimulator simulator = new FixedIterationCostSimulator(modelRoot, queryEngine);
		if (simulator.canSimulate()) {
			cost = simulator.simulate();
		} else {
			cost = Double.POSITIVE_INFINITY;
		}
	}

	public double getCost() {
		return cost;
	}
}
