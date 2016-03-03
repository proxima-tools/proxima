package be.uantwerpen.msdl.process.dse.rules.generic

import be.uantwerpen.msdl.icm.queries.processrewrite.util.SoftControlFlowBetweenActivitiesProcessor
import be.uantwerpen.msdl.metamodels.process.Activity
import be.uantwerpen.msdl.metamodels.process.ControlFlow
import be.uantwerpen.msdl.metamodels.process.Process
import org.eclipse.viatra.dse.api.DSETransformationRule
import be.uantwerpen.msdl.process.dse.rules.RuleGroup

class Generic extends RuleGroup{
	
	override rules() {
		#[
			deleteSoftControlFlow
		]
	}
	
		/**
		 * Control flow patterns
	 */
	val deleteSoftControlFlow = new DSETransformationRule(
		softControlFlowBetweenActivities,
		new SoftControlFlowBetweenActivitiesProcessor() {
			override process(Activity activity1, Activity activity2, ControlFlow controlFlow, Process process) {
				process.controlFlow.remove(controlFlow)
			}
		}
	)

}