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

import java.util.UUID

class Templates {
	def static getProcessModelTemplate() '''
		<?xml version="1.0" encoding="UTF-8"?>
		<be.uantwerpen.msdl.metamodels:ProcessModel
			xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xmlns:be.uantwerpen.msdl.metamodels="metamodels.processmodel" xmlns:be.uantwerpen.msdl.metamodels_1="metamodels.pm">
			
		</be.uantwerpen.msdl.metamodels:ProcessModel>
	'''
	
	def static getRepresentationsTemplate(){
		getRepresentationsTemplate(id, id)
	}
	

	def static getRepresentationsTemplate(String schemaId, String viewId) '''
		<?xml version="1.0" encoding="UTF-8"?>
		<viewpoint:DAnalysis xmi:version="2.0" xmlns:xmi="http://www.omg.org/XMI" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:description="http://www.eclipse.org/sirius/description/1.1.0" xmlns:viewpoint="http://www.eclipse.org/sirius/1.1.0" xsi:schemaLocation="http://www.eclipse.org/sirius/description/1.1.0 http://www.eclipse.org/sirius/1.1.0#//description" xmi:id="«schemaId»" selectedViews="«viewId»" version="11.1.0.201608251200">
		  <semanticResources>process.processmodel</semanticResources>
		  <ownedViews xmi:type="viewpoint:DView" xmi:id="«viewId»">
		    <viewpoint xmi:type="description:Viewpoint" href="platform:/resource/be.uantwerpen.msdl.process.design/description/process.odesign#//@ownedViewpoints[name='ProcessViewpoint']"/>
		  </ownedViews>
		</viewpoint:DAnalysis>
	'''
	
	private static def getId(){
		'_'+UUID.randomUUID().toString.replace('-', '').subSequence(0, 21)
	}
}
