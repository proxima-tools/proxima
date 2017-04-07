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

import be.uantwerpen.msdl.processmodel.ProcessModel
import be.uantwerpen.msdl.processmodel.cost.CostModel
import be.uantwerpen.msdl.processmodel.cost.CostType
import be.uantwerpen.msdl.processmodel.cost.impl.CostFactoryImpl
import be.uantwerpen.msdl.processmodel.pm.Activity
import be.uantwerpen.msdl.processmodel.pm.Process

class CostFactory2 extends CostFactoryImpl {

	def createCost(Activity activity, double value, CostType costType) {
		val cost = createCost
		val processModel = (activity.eContainer as Process).eContainer as ProcessModel
		if (processModel.costModel == null) {
			processModel.costModel = createCostModel
		}
		val costModel = processModel.costModel

		val appropriateCostFactors = costModel.costFactor.filter[it.type.equals(costType)]

		val costFactor = if (!appropriateCostFactors.isEmpty)
				appropriateCostFactors.head
			else
				costModel.createCostFactor(costType)

		costFactor.cost += cost
		cost.value = value
		activity.cost += cost
		cost
	}

	def createCostFactor(CostModel costModel, CostType costType) {
		val costFactor = createCostFactor
		costModel.costFactor += costFactor
		costFactor.type = costType
		costFactor
	}
}
