package be.uantwerpen.msdl.icm.runtime

import be.uantwerpen.msdl.enactment.Enactment
import be.uantwerpen.msdl.icm.runtime.queries.RuntimeQueries
import org.eclipse.viatra.query.runtime.emf.EMFScope
import org.eclipse.viatra.transformation.evm.specific.ConflictResolvers
import org.eclipse.viatra.transformation.runtime.emf.rules.EventDrivenTransformationRuleGroup
import org.eclipse.viatra.transformation.runtime.emf.rules.eventdriven.EventDrivenTransformationRuleFactory
import org.eclipse.viatra.transformation.runtime.emf.transformation.eventdriven.EventDrivenTransformation
import org.eclipse.xtend.lib.annotations.Accessors

class RuntimeRules {

	val extension EventDrivenTransformationRuleFactory ruleFactory = new EventDrivenTransformationRuleFactory
	val extension RuntimeQueries runtimeQueries = RuntimeQueries::instance
	
	@Accessors Enactment enactment

	def getRules() {
		new EventDrivenTransformationRuleGroup(
			enabledTransitionRule
		)
	}

	def registerRulesWithCustomPriorities() {
		val fixedPriorityResolver = ConflictResolvers.createFixedPriorityResolver();
		fixedPriorityResolver.setPriority(enabledTransitionRule.ruleSpecification, 100)

		EventDrivenTransformation.forScope(new EMFScope(enactment.eResource.resourceSet)).addRules(rules).setConflictResolver(
			fixedPriorityResolver).build
	}

	val enabledTransitionRule = createRule.name("enabled transition").precondition(enabledTransition).action [
		token.currentNode = toNode
	].build
	
	//TODO token strategy
	
	val executableActivityRule = createRule.name("executable activity").precondition(executableActivity).action [
		//find runnable and execute
	].build
}
