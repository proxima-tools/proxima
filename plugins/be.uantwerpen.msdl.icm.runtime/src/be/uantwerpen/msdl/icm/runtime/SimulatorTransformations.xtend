package be.uantwerpen.msdl.icm.runtime

import be.uantwerpen.msdl.enactment.ActivityState
import be.uantwerpen.msdl.enactment.Enactment
import be.uantwerpen.msdl.enactment.EnactmentFactory
import be.uantwerpen.msdl.icm.runtime.queries.RuntimeQueries
import be.uantwerpen.msdl.icm.runtime.queries.util.TokenInNodeQuerySpecification
import be.uantwerpen.msdl.processmodel.pm.Activity
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import org.eclipse.viatra.transformation.runtime.emf.modelmanipulation.IModelManipulations
import org.eclipse.viatra.transformation.runtime.emf.modelmanipulation.SimpleModelManipulations
import org.eclipse.viatra.transformation.runtime.emf.rules.BatchTransformationRuleGroup
import org.eclipse.viatra.transformation.runtime.emf.rules.batch.BatchTransformationRuleFactory
import org.eclipse.viatra.transformation.runtime.emf.transformation.batch.BatchTransformation
import org.eclipse.viatra.transformation.runtime.emf.transformation.batch.BatchTransformationStatements

class SimulatorTransformations {
	extension BatchTransformationRuleFactory ruleFactory = new BatchTransformationRuleFactory
	extension BatchTransformation transformation
	extension BatchTransformationStatements statements
	extension IModelManipulations manipulation

	extension RuntimeQueries runtimeQueries = RuntimeQueries::instance

	private Enactment enactment

	new(ViatraQueryEngine engine, Enactment enactment) {
		transformation = BatchTransformation.forEngine(engine).build()
		statements = transformation.transformationStatements
		manipulation = new SimpleModelManipulations(engine)
		this.enactment = enactment
	}

	def maintain() {
		new BatchTransformationRuleGroup(
			fireToControlRule,
			forkableRule,
			joinableRule
		).fireWhilePossible
	}

	val fireToControlRule = createRule.name("fire to control").precondition(fireableToControl).action [
		token.currentNode = control
	].build

	val forkableRule = createRule.name("forkable").precondition(forkable).action [
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
	].build

	val joinableRule = createRule.name("joinable").precondition(joinable).action [
		val tokenMatches = queryEngine.getMatcher(TokenInNodeQuerySpecification.instance).allMatches.filter [ match |
			match.node.equals(join)
		] // each token at this point should be joinable
		// activate parent
		val parentToken = tokenMatches.head.token.subTokenOf
		parentToken.abstract = false
		parentToken.currentNode = join

		// remove subs
		for (tokenMatch : tokenMatches) {
			enactment.token.remove(tokenMatch.token)
		}
	].build
}
