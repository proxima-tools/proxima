package be.uantwerpen.msdl.icm.runtime

import be.uantwerpen.msdl.enactment.ActivityState
import be.uantwerpen.msdl.enactment.Enactment
import be.uantwerpen.msdl.enactment.EnactmentFactory
import be.uantwerpen.msdl.enactment.Token
import be.uantwerpen.msdl.icm.runtime.queries.util.AvailableActivityQuerySpecification
import be.uantwerpen.msdl.icm.runtime.queries.util.FireableToControlQuerySpecification
import be.uantwerpen.msdl.icm.runtime.queries.util.ForkableQuerySpecification
import be.uantwerpen.msdl.icm.runtime.queries.util.JoinableQuerySpecification
import be.uantwerpen.msdl.icm.runtime.queries.util.ReadyActivityQuerySpecification
import be.uantwerpen.msdl.icm.runtime.queries.util.RunnigActivityQuerySpecification
import be.uantwerpen.msdl.icm.runtime.queries.util.TokenInNodeQuerySpecification
import be.uantwerpen.msdl.processmodel.base.NamedElement
import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.processmodel.pm.Initial
import be.uantwerpen.msdl.processmodel.pm.Node
import be.uantwerpen.msdl.processmodel.pm.Process
import com.google.common.collect.Lists
import org.eclipse.viatra.query.runtime.api.ViatraQueryEngine
import org.eclipse.viatra.query.runtime.emf.EMFScope
import be.uantwerpen.msdl.icm.runtime.queries.util.AvailableFinishQuerySpecification
import be.uantwerpen.msdl.icm.runtime.queries.util.FinishedProcessQuerySpecification

class EnactmentManager {

	private Process process
	private Enactment enactment
	private ViatraQueryEngine queryEngine

	new(Process process, Enactment enactment) {
		this.process = process
		this.enactment = enactment
		queryEngine = ViatraQueryEngine.on(new EMFScope(enactment));
	}

	def initialize() {
		println(
			String.format("Compiling process model %s into enactment model %s", process.toString, enactment.toString))

		val token = EnactmentFactory.eINSTANCE.createToken
		enactment.token.add(token)
		token.currentNode = process.node.findFirst[n|n instanceof Initial]
	}

	def getAvailableActivities() {
		val fireableControlFlows = queryEngine.getMatcher(AvailableActivityQuerySpecification.instance).allMatches
		val activities = Lists::newArrayList

		for (ctrlFlowMatch : fireableControlFlows) {
			val toNode = ctrlFlowMatch.controlFlow.to
			activities.add(toNode)
		}
		
		val fireableFinalControlFlows = queryEngine.getMatcher(AvailableFinishQuerySpecification.instance).allMatches
		for (ctrlFlowMatch : fireableFinalControlFlows) {
			val toNode = ctrlFlowMatch.controlFlow.to
			activities.add(toNode)
		}
		
		activities
	}

	def getReadyActivities() {
		val matches = queryEngine.getMatcher(ReadyActivityQuerySpecification.instance).allMatches

		val activities = Lists::newArrayList

		for (match : matches) {
			activities.add(match.node)
		}

		activities
	}

	def prepareActivity(String activityName) {
		val match = queryEngine.getMatcher(AvailableActivityQuerySpecification.instance).allMatches.findFirst [ match |
			(match.activity as NamedElement).name.equalsIgnoreCase(activityName)
		]
		if (match != null) {
			prepareActivity(match.activity, match.token)
		} else {
			println("No available activity with the matching name.")
		}
	}

	def prepareActivity(Activity activity, Token token) {
		token.currentNode = activity
		token.state = ActivityState::READY
	}

	def runActivity(String activityName) {
		val match = queryEngine.getMatcher(ReadyActivityQuerySpecification.instance).allMatches.findFirst [ match |
			(match.node as NamedElement).name.equalsIgnoreCase(activityName)
		]

		if (match != null) {
			runActivity(match.node)
		} else {
			println("No prepared activity with the matching name.")
		}
	}

	def runActivity(Activity activity) {
		val token = enactment.token.findFirst[t|t.currentNode.equals(activity)]
		token.state = ActivityState::RUNNING
	}

	def finishActivity(String activityName) {
		val match = queryEngine.getMatcher(RunnigActivityQuerySpecification.instance).allMatches.findFirst [ match |
			(match.node as NamedElement).name.equalsIgnoreCase(activityName)
		]

		if (match != null) {
			finishActivity(match.node)
		} else {
			println("No running activity with the matching name.")
		}
	}

	def finishActivity(Activity activity) {
		val token = enactment.token.findFirst[t|t.currentNode.equals(activity)]
		token.state = ActivityState::DONE
	}
	
	def stepActivity() {
		val matchAvailable = queryEngine.getMatcher(AvailableActivityQuerySpecification.instance).allMatches.head
		val matchReady = queryEngine.getMatcher(ReadyActivityQuerySpecification.instance).allMatches.head
		
		if (matchAvailable != null) {
			val match = matchAvailable
			prepareActivity(match.activity, match.token)
			runActivity(match.activity)
			finishActivity(match.activity)
		} else if (matchReady != null) {
			val match = matchReady
			runActivity(match.node)
			finishActivity(match.node)
		} else {
			println("No available activity with the matching name.")
		}
	}
	
	def stepActivity(String activityName) {
		val matchAvailable = queryEngine.getMatcher(AvailableActivityQuerySpecification.instance).allMatches.findFirst [ match |
			(match.activity as NamedElement).name.equalsIgnoreCase(activityName)
		]
		val matchReady = queryEngine.getMatcher(ReadyActivityQuerySpecification.instance).allMatches.findFirst [ match |
			(match.node as NamedElement).name.equalsIgnoreCase(activityName)
		]

		if (matchAvailable != null) {
			val match = matchAvailable
			prepareActivity(match.activity, match.token)
			runActivity(match.activity)
			finishActivity(match.activity)
		} else if (matchReady != null) {
			val match = matchReady
			runActivity(match.node)
			finishActivity(match.node)
		} else {
			println("No available activity with the matching name.")
		}
	}
	
	def finalStep() {
		val fireableFinalControlFlows = queryEngine.getMatcher(AvailableFinishQuerySpecification.instance).allMatches
		
		if(fireableFinalControlFlows.empty){
			println("The process cannot be finished at this point.")
		}
		
		fireableFinalControlFlows.head.token.currentNode = fireableFinalControlFlows.head.final
	}
	
	def boolean processFinished(){
		queryEngine.getMatcher(FinishedProcessQuerySpecification.instance).countMatches > 0
	}

	def maintain() {
		var intact = false

		while (!intact) {
			val c1 = fireToControl()
			val c2 = fork()
			val c3 = join()

			intact = c1 && c2 && c3
		}
	}

	def boolean fireToControl() {
		var intact = true

		val fireables = queryEngine.getMatcher(FireableToControlQuerySpecification.instance).allMatches
		if (fireables.empty) {
			return intact
		}

		intact = false
		for (fireable : fireables) {
			fireable.token.currentNode = fireable.control
		}

		intact
	}

	def boolean fork() {
		var intact = true

		val forkables = queryEngine.getMatcher(ForkableQuerySpecification.instance).allMatches
		if (forkables.empty) {
			return intact
		}

		intact = false
		for (forkable : forkables) {
			// de-activate parent
			forkable.token.abstract = true

			// create sub-tokens
			for (ctrlOut : forkable.fork.controlOut) {
				val newToken = EnactmentFactory.eINSTANCE.createToken
				newToken.subTokenOf = forkable.token
				enactment.token.add(newToken)
				newToken.currentNode = ctrlOut.to
				if (ctrlOut.to instanceof Activity) {
					newToken.state = ActivityState::READY
				}
			}
		}

		intact
	}

	def join() {
		var intact = true

		val joinables = queryEngine.getMatcher(JoinableQuerySpecification.instance).allMatches
		if (joinables.empty) {
			return intact
		}

		intact = false

		for (joinable : joinables) {
			val join = joinable.join
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
		}

		intact
	}

	def getActivities(Process process) {
		process.node.filter[n|n instanceof Activity]
	}

	def isDoneActivity(Node node) {
		if (!(node instanceof Activity)) {
			return false
		}
		val token = enactment.token.findFirst[t|t.currentNode.equals(node)]
		token.state.equals(ActivityState::DONE)
	}

}
