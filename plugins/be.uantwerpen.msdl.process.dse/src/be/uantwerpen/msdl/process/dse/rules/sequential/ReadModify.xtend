package be.uantwerpen.msdl.process.dse.rules.sequential

import be.uantwerpen.msdl.icm.queries.processrewrite.util.ReadModifySharedProperty2Processor
import be.uantwerpen.msdl.icm.queries.processrewrite.util.ReadModifySharedPropertyProcessor
import be.uantwerpen.msdl.metamodels.process.Activity
import be.uantwerpen.msdl.metamodels.process.Process
import be.uantwerpen.msdl.metamodels.process.Property
import org.eclipse.viatra.dse.api.DSETransformationRule
import be.uantwerpen.msdl.process.dse.rules.RuleGroup

class ReadModify extends RuleGroup {

	override rules() {
		#[
			readModifyReorder,
			readModifyAugmentWithCheck
		]
	}

	/**
	 * Sequence READ-MODIFY pairs
	 */
	val readModifyReorder = new DSETransformationRule(
		readModifySharedProperty,
		new ReadModifySharedPropertyProcessor() {
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
	 * Create a check on a READ-MODIFY pair
	 * FIXME This is not complete yet, there should be an activity with a check intent on the property
	 * between A2 and D. Also: the pattern should look for this missing check with neg find.
	 */
	val readModifyAugmentWithCheck = new DSETransformationRule(
		readModifySharedProperty2,
		new ReadModifySharedProperty2Processor() {
			override process(Activity activity1, Activity activity2, Property property, Process process) {

				val decision = process.createDecision(property.name + "?")

				// these are gonna be the OK nodes from the Decision node
				activity2.controlOut.forEach [ cf |
					cf.name = "OK"
				]
				decision.controlOut.addAll(activity2.controlOut)
				activity2.controlOut.removeAll(decision.controlOut)

				// connecting Activity2 with the Decision node
				process.createControlFlow(activity2, decision)

				val controlNO = process.createControlFlow(decision, activity1)
				controlNO.name = "NO"
			}
		}
	)
}
