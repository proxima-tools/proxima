/*******************************************************************************
 * Copyright (c) 2016 Istvan David
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *    Istvan David - initial API and implementation
 *******************************************************************************/

package be.uantwerpen.msdl.process.dse.rules

import be.uantwerpen.msdl.processmodel.pm.Node
import be.uantwerpen.msdl.processmodel.pm.PmFactory
import be.uantwerpen.msdl.processmodel.pm.Process
import be.uantwerpen.msdl.processmodel.pm.impl.PmFactoryImpl
import static extension be.uantwerpen.msdl.process.dse.rules.FactoryHelper.*

class PmFactory2 extends PmFactoryImpl {

	val extension PmFactory pmFactory = PmFactory::eINSTANCE

	override createManualActivity() {
		val manualActivity = pmFactory.createManualActivity
		manualActivity.setId
		manualActivity
	}

	def createManualActivity(String name) {
		val manualActivity = createManualActivity
		manualActivity.name = name
		manualActivity
	}

	def createManualActivity(Process process, String name) {
		val manualActivity = createManualActivity
		manualActivity.name = name
		process.node += manualActivity
		manualActivity
	}

	override createDecision() {
		val decision = pmFactory.createDecision
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

	override createFork() {
		val fork = pmFactory.createFork
		fork.setId
		fork
	}

	def createFork(Process process) {
		val fork = createFork
		process.node += fork
		fork
	}

	override createJoin() {
		val join = pmFactory.createJoin
		join.setId
		join
	}

	def createJoin(Process process) {
		val join = createJoin
		process.node += join
		join
	}

	override createControlFlow() {
		val controlFlow = pmFactory.createControlFlow
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
		controlFlow.from = from
		controlFlow.to = to
		controlFlow
	}

	def createFeedback(Process process, Node from, Node to) {
		val controlFlow = createControlFlow(process, from, to)
		controlFlow.feedback = true;
		controlFlow
	}
}
