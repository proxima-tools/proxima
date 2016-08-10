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

import be.uantwerpen.msdl.processmodel.IntentType
import be.uantwerpen.msdl.processmodel.ProcessModel
import be.uantwerpen.msdl.processmodel.ProcessmodelFactory
import be.uantwerpen.msdl.processmodel.impl.ProcessmodelFactoryImpl
import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.processmodel.properties.Property

import static extension be.uantwerpen.msdl.process.dse.rules.FactoryHelper.*

class ProcessFactory2 extends ProcessmodelFactoryImpl {

	val extension ProcessmodelFactory processFactory = ProcessmodelFactory::eINSTANCE

	override createIntent() {
		val intent = processFactory.createIntent
		intent.setId
		intent
	}

	def createIntent(Activity from, Property to, IntentType intentType) {
		val intent = createIntent
		intent.activity = from
		intent.subject = to
		intent.type = intentType;
		(from.eContainer.eContainer as ProcessModel).intent += intent
	}
}
