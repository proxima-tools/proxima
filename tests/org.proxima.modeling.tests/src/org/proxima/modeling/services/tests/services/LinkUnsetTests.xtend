package org.proxima.modeling.services.tests.services

import be.uantwerpen.msdl.proxima.modeling.services.Services
import be.uantwerpen.msdl.proxima.processmodel.ftg.Formalism
import be.uantwerpen.msdl.proxima.processmodel.ftg.FtgFactory
import be.uantwerpen.msdl.proxima.processmodel.ftg.Tool
import org.eclipse.sirius.diagram.DEdge
import org.eclipse.sirius.diagram.DNode
import org.eclipse.sirius.diagram.DiagramFactory
import org.junit.After
import org.junit.Before
import org.junit.Test

import static org.junit.Assert.assertFalse
import static org.junit.Assert.assertTrue

class LinkUnsetTests {

	var Services services
	var DEdge dEdge
	var DNode sourceDNode
	var DNode targetDNode

	@Before
	def void setUp() {
		services = new Services()

		dEdge = DiagramFactory.eINSTANCE.createDEdge

		sourceDNode = DiagramFactory.eINSTANCE.createDNode
		dEdge.sourceNode = sourceDNode

		targetDNode = DiagramFactory.eINSTANCE.createDNode
		dEdge.targetNode = targetDNode
	}

	@After
	def void tearDown() {
		services = null
		dEdge = null
		sourceDNode = null
		targetDNode = null
	}

	@Test
	def void testUnsetImplementationLink() {
		val Tool tool = FtgFactory.eINSTANCE.createTool
		sourceDNode.target = tool

		val Formalism formalism = FtgFactory.eINSTANCE.createFormalism
		targetDNode.target = formalism

		tool.implements.add(formalism)
		assertTrue(tool.implements.contains(formalism))

		services.unsetImplementationLink(dEdge)
		assertFalse(tool.implements.contains(formalism))
	}

	@Test
	def void testUnsetTransformedByLink() {
		val Formalism formalism = FtgFactory.eINSTANCE.createFormalism
		sourceDNode.target = formalism

		val transformation = FtgFactory.eINSTANCE.createTransformation
		targetDNode.target = transformation

		formalism.inputOf.add(transformation)
		assertTrue(formalism.inputOf.contains(transformation))

		services.unsetTransformedByLink(dEdge)
		assertFalse(formalism.inputOf.contains(transformation))
	}
	
	@Test
	def void testUnsetTransformationToLink() {
		val transformation = FtgFactory.eINSTANCE.createTransformation
		sourceDNode.target = transformation
		
		val Formalism formalism = FtgFactory.eINSTANCE.createFormalism
		targetDNode.target = formalism

		formalism.outputOf.add(transformation)
		assertTrue(formalism.outputOf.contains(transformation))

		services.unsetTransformationToLink(dEdge)
		assertFalse(formalism.outputOf.contains(transformation))
	}
}
