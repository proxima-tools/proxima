package be.uantwerpen.msdl.process.dse.rules.sequential

import be.uantwerpen.msdl.icm.queries.inconsistencies.util.UnmanagedReadModify2Processor
import be.uantwerpen.msdl.icm.queries.inconsistencies.util.UnmanagedReadModify3Processor
import be.uantwerpen.msdl.icm.queries.inconsistencies.util.UnmanagedReadModifyProcessor
import be.uantwerpen.msdl.metamodels.process.Activity
import be.uantwerpen.msdl.metamodels.process.IntentType
import be.uantwerpen.msdl.metamodels.process.Process
import be.uantwerpen.msdl.metamodels.process.ProcessModel
import be.uantwerpen.msdl.metamodels.process.Property
import be.uantwerpen.msdl.process.dse.rules.RuleGroup
import org.eclipse.viatra.dse.api.DSETransformationRule

class ReadModify extends RuleGroup {

	override rules() {
		#[
			readModifyReorder,
			readModifyAugmentWithCheck,
			readModifyAugmentWithContract
		]
	}

	/**
	 * Reordering
	 */
	val readModifyReorder = new DSETransformationRule(
		unmanagedReadModify,
		new UnmanagedReadModifyProcessor() {
			override process(Activity activity1, Activity activity2, Property property) {
				val tmp = createManualActivity("tmp");

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
	 * Check property
	 */
	val readModifyAugmentWithCheck = new DSETransformationRule(
		unmanagedReadModify2,
		new UnmanagedReadModify2Processor() {
			override process(Activity activity1, Activity activity2, Property property) {

				val process = activity1.eContainer as Process

				val decision = process.createDecision(property.name + "?")

				// these are gonna be the OK nodes from the Decision node
				activity2.controlOut.forEach [ cf |
					cf.name = "OK"
				]
				decision.controlOut.addAll(activity2.controlOut)
				activity2.controlOut.removeAll(decision.controlOut)

				val checkActivity = process.createManualActivity("check" + property.name)
				val cost = createRatioScale;
				(process.eContainer as ProcessModel).costModel.cost += cost
				cost.value = checkCost

				checkActivity.cost = cost

				createIntent(checkActivity, property, IntentType::CHECK)

				// connecting Activity2 with the check activity and that with the Decision 
				process.createControlFlow(activity2, checkActivity)
				process.createControlFlow(checkActivity, decision)

				val controlNO = process.createControlFlow(decision, activity1)
				controlNO.name = "NO"
			}
		}
	)

	val readModifyAugmentWithContract = new DSETransformationRule(
		unmanagedReadModify3,
		new UnmanagedReadModify3Processor() {
			override process(Activity activity1, Activity activity2, Property property) {
			}
		}
	)
}
