package be.uantwerpen.msdl.process.dse.objectives.soft;

import java.util.Deque;
import java.util.HashSet;
import java.util.Iterator;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.incquery.runtime.base.api.IncQueryBaseFactory;
import org.eclipse.incquery.runtime.base.api.TransitiveClosureHelper;
import org.eclipse.incquery.runtime.base.exception.IncQueryBaseException;
import org.eclipse.incquery.runtime.exception.IncQueryException;
import org.eclipse.viatra.dse.api.SolutionTrajectory;
import org.eclipse.viatra.dse.base.ThreadContext;
import org.eclipse.viatra.dse.objectives.Comparators;
import org.eclipse.viatra.dse.objectives.IObjective;
import org.eclipse.viatra.dse.objectives.impl.BaseObjective;

import be.uantwerpen.msdl.metamodels.process.FlowFinal;
import be.uantwerpen.msdl.metamodels.process.Initial;
import be.uantwerpen.msdl.metamodels.process.Node;
import be.uantwerpen.msdl.metamodels.process.ProcessModel;
import be.uantwerpen.msdl.metamodels.process.ProcessPackage;

@Deprecated
public class ShortestPathSoftObjective extends BaseObjective {

	public static final String DEFAULT_NAME = "ShortestPathSoftObjective";
	private TransitiveClosureHelper tcHelper;

	public ShortestPathSoftObjective() {
		super(DEFAULT_NAME);
		comparator = Comparators.HIGHER_IS_BETTER;
	}

	@Override
	public Double getFitness(ThreadContext context) {
		// Set up tchelper
		HashSet<EReference> refs = new HashSet<EReference>();
		refs.add((EReference) ProcessPackage.eINSTANCE.getNode_ToControlFlow());

		SolutionTrajectory solutionTrajectroy = null;

		try {
			ProcessModel modelRoot = (ProcessModel) context.getModelRoot();
			tcHelper = IncQueryBaseFactory.getInstance().createTransitiveClosureHelper(modelRoot, refs);

			solutionTrajectroy = context.getDesignSpaceManager().createSolutionTrajectroy();
			solutionTrajectroy.setModel(modelRoot);
			solutionTrajectroy.doTransformation();

		} catch (IncQueryException e1) {
			e1.printStackTrace();
		} catch (IncQueryBaseException e) {
			e.printStackTrace();
		}

		// return 1.0;

		ProcessModel pm = (ProcessModel) context.getModelRoot();

		Initial initNode = null;
		FlowFinal finalNode = null;

		for (Node node : pm.getProcess().get(0).getNode()) {
			if (node instanceof Initial) {
				initNode = (Initial) node;
				break;
			}
		}

		for (Node node : pm.getProcess().get(0).getNode()) {
			if (node instanceof FlowFinal) {
				finalNode = (FlowFinal) node;
				break;
			}
		}

		Iterable<Deque<EObject>> shortestPaths = tcHelper.getPathFinder().getShortestPaths(initNode, finalNode);

		if (!shortestPaths.iterator().hasNext()) {
			if (solutionTrajectroy.getTrajectoryLength() != 0) {
				solutionTrajectroy.undoTransformation();
			}
			return Double.MIN_VALUE;
		}

		Iterator<Deque<EObject>> iterator = tcHelper.getPathFinder().getShortestPaths(initNode, finalNode).iterator();
		int maxSize = Integer.MIN_VALUE;
		while (iterator.hasNext()) {
			Deque<EObject> element = iterator.next();
			int size = element.size();
			if (size > maxSize) {
				maxSize = size;
			}
		}

		System.out.println(maxSize);
		if (solutionTrajectroy.getTrajectoryLength() != 0) {
			solutionTrajectroy.undoTransformation();
		}
		return (double) maxSize;

	}

	@Override
	public void init(ThreadContext context) {

	}

	@Override
	public IObjective createNew() {
		ShortestPathSoftObjective objective = new ShortestPathSoftObjective();
		objective.level = level;
		return objective;
	}

	@Override
	public boolean isHardObjective() {
		return false;
	}

	@Override
	public boolean satisifiesHardObjective(Double fitness) {
		return true;
	}

}
