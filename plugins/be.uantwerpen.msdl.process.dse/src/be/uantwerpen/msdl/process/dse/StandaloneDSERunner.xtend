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

package be.uantwerpen.msdl.process.dse

import be.uantwerpen.msdl.processmodel.ProcessModel
import be.uantwerpen.msdl.processmodel.ProcessmodelPackage
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl
import org.junit.After
import org.junit.Before
import org.junit.Test

/**
 * Triggers DSE in a standalone mode. TEST_FILE_LOCATION marks the file that contains the process model.
 */
class StandaloneDSERunner extends AbstractDSERunner {
	// private static final val TEST_FILE_LOCATION = "file:///D:/workspaces/runtime-New_configuration-neon/pmtest2/pmtest2.processmodel"
//	private static final val TEST_FILE_LOCATION = "file:///D:/GitHub/msdl/ICM/examples/example2/example.processmodel"
	private static final val TEST_FILE_LOCATION = "file:///D:/GitHub/msdl/agv/be.uantwerpen.msdl.icm.cases.agv2/agv.processmodel"

	private ResourceSet resourceSet
	private Resource resource

	@Before
	def void setup() {
		ProcessmodelPackage.eINSTANCE.eClass()

		val extensionToFactoryMap = Resource.Factory.Registry.INSTANCE.extensionToFactoryMap
		extensionToFactoryMap.put("processmodel", new XMIResourceFactoryImpl())
		resourceSet = new ResourceSetImpl()
		resource = resourceSet.getResource(URI.createURI(TEST_FILE_LOCATION), true)

		this.processModel = resource.contents.head as ProcessModel
	}

	@After
	def void tearDown() {
		resource = null
		resourceSet = null
	}

	@Test
	def override explore() {
		super.explore

	}
}
