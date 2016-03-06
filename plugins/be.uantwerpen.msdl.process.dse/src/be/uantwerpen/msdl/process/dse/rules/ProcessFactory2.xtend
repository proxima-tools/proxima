package be.uantwerpen.msdl.process.dse.rules

import be.uantwerpen.msdl.metamodels.process.Activity
import be.uantwerpen.msdl.metamodels.process.Identifiable
import be.uantwerpen.msdl.metamodels.process.Node
import be.uantwerpen.msdl.metamodels.process.Process
import be.uantwerpen.msdl.metamodels.process.ProcessFactory
import be.uantwerpen.msdl.metamodels.process.Property
import be.uantwerpen.msdl.metamodels.process.impl.ProcessFactoryImpl
import java.util.UUID
import be.uantwerpen.msdl.metamodels.process.IntentType

class ProcessFactory2 extends ProcessFactoryImpl {

	val extension ProcessFactory processFactory = ProcessFactory::eINSTANCE

	private def setId(Identifiable identifiable) {
		identifiable.id = UUID.randomUUID.toString
	}

	override createManualActivity() {
		val manualActivity = processFactory.createManualActivity
		manualActivity.setId
		manualActivity
	}

	def createManualActivity(String name) {
		val manualActivity = createManualActivity
		manualActivity.name = name
		manualActivity
	}

	override createDecision() {
		val decision = processFactory.createDecision
		decision.setId
		decision
	}

	def createDecision(String name) {
		val decision = createDecision
		decision.name = name
		decision
	}

	def createDecision(Process process, String name) {
		val decision = createDecision(name)
		process.node += decision
		decision
	}

	override createControlFlow() {
		val controlFlow = processFactory.createControlFlow
		controlFlow.setId
		controlFlow
	}

	def createControlFlow(Process process) {
		val controlFlow = createControlFlow
		process.controlFlow += controlFlow
		controlFlow
	}

	def createControlFlow(Process process, Node from, Node to) {
		val controlFlow = process.createControlFlow
		controlFlow.fromNode = from
		controlFlow.toNode = to
		controlFlow
	}

	override createIntent() {
		val intent = processFactory.createIntent
		intent.setId
		intent
	}

	def createIntent(Activity from, Property to, IntentType intentType) {
		val intent = createIntent
		intent.activity = from
		intent.subjectOfIntent = to
		intent.type = intentType
	}
}
