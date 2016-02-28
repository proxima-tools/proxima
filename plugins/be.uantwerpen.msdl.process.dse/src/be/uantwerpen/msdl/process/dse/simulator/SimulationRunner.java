package be.uantwerpen.msdl.process.dse.simulator;

import java.util.Map;
import java.util.WeakHashMap;

import org.eclipse.emf.common.notify.Notifier;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.viatra.dse.base.DesignSpaceManager;
import org.eclipse.viatra.dse.base.ThreadContext;
import org.eclipse.viatra.dse.designspace.api.IState;

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

	private SimulationRunner() {
	}

	private void init(ThreadContext context) {
		modelRoot = (ProcessModel) context.getModelRoot();
		dsm = context.getDesignSpaceManager();
	}

	public void runSimulation() {
		if (dsm.getCurrentState().getId().equals(lastState)) {
			return;
		}

		Simulator simulator = new Simulator(modelRoot);
		if (simulator.canSimulate()) {
			simulator.simulate();

		} else {
			cost = Double.POSITIVE_INFINITY;
		}
	}

	public double getCost() {
		return cost;
	}
}
