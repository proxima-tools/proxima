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

package be.uantwerpen.msdl.icm.tooling.ui.wizards

class Templates {
	def static getProcessModelTemplate() '''
		<?xml version="1.0" encoding="UTF-8"?>
		<be.uantwerpen.msdl.metamodels:ProcessModel
			xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xmlns:be.uantwerpen.msdl.metamodels="metamodels.processmodel" xmlns:be.uantwerpen.msdl.metamodels_1="metamodels.pm">
			
		</be.uantwerpen.msdl.metamodels:ProcessModel>
	'''

	def static getRepresentationsTemplate() '''
		<?xml version="1.0" encoding="UTF-8"?>
		<viewpoint:DAnalysis xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:description="http://www.eclipse.org/sirius/description/1.1.0" xmlns:viewpoint="http://www.eclipse.org/sirius/1.1.0" xsi:schemaLocation="http://www.eclipse.org/sirius/description/1.1.0 http://www.eclipse.org/sirius/1.1.0#//description" xmi:id="_BOJa8B1yEeen9ol6PRcXVQ" selectedViews="_BxA3cB1yEeen9ol6PRcXVQ" version="11.0.0.201604141600">
		  <semanticResources>process/process.processmodel</semanticResources>
		  <ownedViews xmi:type="viewpoint:DView" xmi:id="_BxA3cB1yEeen9ol6PRcXVQ">
		    <viewpoint xmi:type="description:Viewpoint" href="platform:/plugin/be.uantwerpen.msdl.process.design/description/process.odesign#//@ownedViewpoints[name='ProcessViewpoint']"/>
		  </ownedViews>
		</viewpoint:DAnalysis>
	'''
}
