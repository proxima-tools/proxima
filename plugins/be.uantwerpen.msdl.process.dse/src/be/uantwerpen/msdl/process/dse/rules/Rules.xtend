package be.uantwerpen.msdl.process.dse.rules

import be.uantwerpen.msdl.icm.queries.processrewrite.ProcessRewrite
import be.uantwerpen.msdl.icm.queries.processrewrite.util.ReadModifySharedPropertyProcessor
import be.uantwerpen.msdl.icm.queries.processrewrite.util.SoftControlFlowBetweenActivitiesProcessor
import be.uantwerpen.msdl.metamodels.process.Activity
import be.uantwerpen.msdl.metamodels.process.ControlFlow
import be.uantwerpen.msdl.metamodels.process.Process
import be.uantwerpen.msdl.metamodels.process.ProcessFactory
import be.uantwerpen.msdl.metamodels.process.Property
import org.eclipse.viatra.dse.api.DSETransformationRule
import org.eclipse.viatra.dse.api.DesignSpaceExplorer

class Rules {

	val extension ProcessRewrite processRewriteQueries = ProcessRewrite::instance
	val extension ProcessFactory processFactory = ProcessFactory::eINSTANCE

	def addTransformationRules(DesignSpaceExplorer dse) {
		rules.forEach[rule|dse.addTransformationRule(rule)]
	}

	def rules() {
		#[
//			deleteSoftControlFlow
//			,
//			sequenceNodes,
//			parallelizeNodes,
//			objectFlow
			readModifyReorder
		]
	}

	/**
	 * Assign sequence READ-MODIFY 
	 */
	val readModifyReorder = new DSETransformationRule(
		readModifySharedProperty,
		new ReadModifySharedPropertyProcessor() {
			override process(Activity activity1, Activity activity2, Property property) {
				val tmp = createManualActivity;
				tmp.id = "tmp";

				tmp.controlIn.addAll(activity1.controlIn)
				activity1.controlIn.removeAll(tmp.controlIn)

				tmp.controlOut.addAll(activity1.controlOut)
				activity1.controlOut.removeAll(tmp.controlOut)

				activity1.controlIn.addAll(activity2.controlIn)
				activity2.controlIn.removeAll(activity1.controlIn)

				activity1.controlOut.addAll(activity2.controlOut)
				activity2.controlOut.removeAll(activity1.controlOut)

				activity2.controlIn.addAll(tmp.controlIn)
				tmp.controlIn.removeAll(activity2.controlIn)

				activity2.controlOut.addAll(tmp.controlOut)
				tmp.controlOut.removeAll(activity2.controlOut)
			}
		}
	)

	/**
	 * Control flow patterns
	 */
	val deleteSoftControlFlow = new DSETransformationRule(
		softControlFlowBetweenActivities,
		new SoftControlFlowBetweenActivitiesProcessor() {
			override process(Activity activity1, Activity activity2, ControlFlow controlFlow) {
				(controlFlow.eContainer as Process).controlFlow.remove(controlFlow)
			}
		}
	)
//
//	/**
//	 * Organize independent nodes into a sequence
//	 */
//	val sequenceNodes = new DSETransformationRule(
//		independentNodes,
//		new IndependentNodesProcessor() {
//			override process(Process process, Node node1, Node node2) {
//				val cf = createControlFlow();
//				cf.id = UUID.randomUUID.toString;
//				process.controlFlow += cf;
//				cf.fromNode += node1
//				cf.toNode += node2
//			}
//		}
//	)
//
//	/**
//	 * Organize independent nodes into a parallel structure
//	 */
//	val parallelizeNodes = new DSETransformationRule(
//		independentNodes2,
//		new IndependentNodes2Processor() {
//			override process(Process process, Node node1, Node node2) {
//				val fork = createFork;
//				fork.id = UUID.randomUUID.toString;
//				process.node += fork
//				val join = createJoin;
//				join.id = UUID.randomUUID.toString;
//				process.node += join
//
//				// control inputs of node1 and node2 should be redirected to the fork
//				fork.controlIn += node1.controlIn + node2.controlIn
//
//				// control outputs of node1 and node2 should be redirected from the join
//				join.controlOut += node1.controlOut + node2.controlOut
//
//				// wave activities into the fork-join structure
//				#[node1, node2].forEach [ node |
//					val controlFlow1 = createControlFlow
//					process.controlFlow += controlFlow1
//					controlFlow1.id = UUID.randomUUID.toString
//					controlFlow1.fromNode += fork
//					controlFlow1.toNode += node
//
//					val controlFlow2 = createControlFlow
//					process.controlFlow += controlFlow2
//					controlFlow2.id = UUID.randomUUID.toString
//					controlFlow2.fromNode += node
//					controlFlow2.toNode += join
//				]
//			}
//		}
//	)
//
//	/**
//	 * Object flow patterns
//	 */
//	val objectFlow = new DSETransformationRule(
//		objectFlowBetweenIndependentActivities,
//		new ObjectFlowBetweenIndependentActivitiesProcessor() {
//			override process(Activity activity1, Activity activity2) {
//				val process = (activity1.eContainer as Process)
//
//				val controlFlow = createControlFlow
//				process.controlFlow += controlFlow
//
//				controlFlow.fromNode += activity1
//				controlFlow.toNode += activity2
//			}
//		}
//	)
}
