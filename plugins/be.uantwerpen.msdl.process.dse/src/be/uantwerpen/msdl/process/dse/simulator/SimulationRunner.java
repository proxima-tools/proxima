/*******************************************************************************
 * Copyright (c) 2016-2017 Istvan David
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Istvan David - initial API and implementation
 *******************************************************************************/

package be.uantwerpen.msdl.process.dse.simulator;

import java.util.Map;
import java.util.WeakHashMap;

import org.eclipse.emf.common.notify.Notifier;
import org.eclipse.viatra.dse.base.DesignSpaceManager;
import org.eclipse.viatra.dse.base.ThreadContext;
import org.eclipse.viatra.dse.designspace.api.IDesignSpace;
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine;

import be.uantwerpen.msdl.processmodel.ProcessModel;

public class SimulationRunner {

    private static Map<Notifier, SimulationRunner> sims = new WeakHashMap<Notifier, SimulationRunner>();

    public static synchronized SimulationRunner create(ThreadContext context) {
        Notifier modelRoot = context.getModel();
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
    private IDesignSpace lastState = null;
    private DesignSpaceManager dsm;
    private ViatraQueryEngine queryEngine;

    private SimulationRunner() {
    }

    private void init(ThreadContext context) {
        modelRoot = (ProcessModel) context.getModel();
        dsm = context.getDesignSpaceManager();
        queryEngine = context.getQueryEngine();
    }

    public void runSimulation() {
        if (dsm.getCurrentState().equals(lastState)) {
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
