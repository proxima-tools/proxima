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

package be.uantwerpen.msdl.icm.runtime.transformations

import be.uantwerpen.msdl.enactment.ActivityState
import be.uantwerpen.msdl.enactment.Enactment
import be.uantwerpen.msdl.enactment.EnactmentFactory
import be.uantwerpen.msdl.icm.runtime.queries.RuntimeQueries
import be.uantwerpen.msdl.icm.runtime.queries.TokenInNode
import be.uantwerpen.msdl.processmodel.pm.Activity
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import org.eclipse.viatra.transformation.evm.specific.ConflictResolvers
import org.eclipse.viatra.transformation.runtime.emf.rules.EventDrivenTransformationRuleGroup
import org.eclipse.viatra.transformation.runtime.emf.rules.eventdriven.EventDrivenTransformationRuleFactory
import org.eclipse.viatra.transformation.runtime.emf.transformation.eventdriven.EventDrivenTransformation

class SimulatorTransformations2 {
	extension EventDrivenTransformationRuleFactory ruleFactory = new EventDrivenTransformationRuleFactory

	extension RuntimeQueries runtimeQueries = RuntimeQueries::instance

	private Enactment enactment
	private ViatraQueryEngine queryEngine
	private Logger logger = Logger.getLogger("SimulatorTransformation2")

	new(ViatraQueryEngine engine, Enactment enactment) {
		this.queryEngine = engine
		this.enactment = enactment
		logger.level = Level::DEBUG
	}

	def getRules() {
		new EventDrivenTransformationRuleGroup(
			forkableRule,
			joinableRule,
			fireToControlRule
		)
	}

	def registerRulesWithCustomPriorities() {
		val fixedPriorityResolver = ConflictResolvers.createFixedPriorityResolver();
		fixedPriorityResolver.setPriority(forkableRule.ruleSpecification, 10)
		fixedPriorityResolver.setPriority(joinableRule.ruleSpecification, 20)
		fixedPriorityResolver.setPriority(fireToControlRule.ruleSpecification, 30)

		EventDrivenTransformation.forEngine(queryEngine).addRules(rules).setConflictResolver(fixedPriorityResolver).
			build

	}

	val fireToControlRule = createRule.name("fire to control").precondition(fireableToControl).action [
		logger.debug(String.format("Firing token %s from node %s to control node %s.", token, fromNode, control))
		token.currentNode = control
	].build

	val forkableRule = createRule.name("forkable").precondition(forkable).action [
		logger.debug(String.format("Forking token %s at %s.", token, fork))
		// de-activate parent
		token.abstract = true

		// create sub-tokens
		for (ctrlOut : fork.controlOut) {
			val newToken = EnactmentFactory.eINSTANCE.createToken
			newToken.subTokenOf = token
			enactment.token.add(newToken)
			newToken.currentNode = ctrlOut.to
			if (ctrlOut.to instanceof Activity) {
				newToken.state = ActivityState::READY
			}
		}
		println("forkable")
	].build

	val joinableRule = createRule.name("joinable").precondition(joinable).action [
		logger.debug(String.format("Joining tokens at %s.", join))
		val tokenMatches = queryEngine.getMatcher(TokenInNode.instance).allMatches.filter [ match |
			match.node.equals(join)
		] // each token at this point should be joinable
		logger.debug(String.format("Joinable tokens: %s.", tokenMatches.map[tm|tm.token].toList))

		// activate parent
		val parentToken = tokenMatches.head.token.subTokenOf
		parentToken.abstract = false
		parentToken.currentNode = join

		// remove subs
		for (tokenMatch : tokenMatches) {
			enactment.token.remove(tokenMatch.token)
		}
		println("joinable")
	].build
}
