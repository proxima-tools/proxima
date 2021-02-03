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

package be.uantwerpen.msdl.process.dse.rules

import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.processmodel.properties.IntentType
import be.uantwerpen.msdl.processmodel.properties.PropertiesFactory
import be.uantwerpen.msdl.processmodel.properties.Property
import be.uantwerpen.msdl.processmodel.properties.PropertyModel
import be.uantwerpen.msdl.processmodel.properties.impl.PropertiesFactoryImpl

import static extension be.uantwerpen.msdl.process.dse.rules.FactoryHelper.*

class PropertiesFactory2 extends PropertiesFactoryImpl {

	val extension PropertiesFactory propertiesFactory = PropertiesFactory::eINSTANCE

	override createIntent() {
		val intent = propertiesFactory.createIntent
		intent.setId
		intent
	}

	def createIntent(Activity from, Property to, IntentType intentType) {
		val intent = createIntent
		intent.activity = from
		intent.subject = to
		intent.type = intentType;
		(to.eContainer as PropertyModel).intent += intent
	}
}
