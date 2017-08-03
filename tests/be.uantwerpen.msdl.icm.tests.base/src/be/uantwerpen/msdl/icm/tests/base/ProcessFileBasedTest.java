package be.uantwerpen.msdl.icm.tests.base;

import java.io.File;
import java.util.Map;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;

import be.uantwerpen.msdl.processmodel.ProcessModel;

public abstract class ProcessFileBasedTest {

	private ProcessModel processModel;
	private File processModelFile;

	public ProcessFileBasedTest() {
		processModelFile = new File(
				"D:\\GitHub\\msdl\\ICM\\examples\\be.uantwerpen.msdl.icm.examples.full\\processes\\attributetest.processmodel");

		Map<String, Object> extensionToFactoryMap = Resource.Factory.Registry.INSTANCE.getExtensionToFactoryMap();
		extensionToFactoryMap.put("processmodel", new XMIResourceFactoryImpl());
		ResourceSet resourceSet = new ResourceSetImpl();
		Resource resource;

		if (processModelFile.getPath().toLowerCase().startsWith("c")
				|| processModelFile.getPath().toLowerCase().startsWith("d")) {
			resource = resourceSet.getResource(URI.createFileURI(processModelFile.getPath()), true);
		} else {
			resource = resourceSet.getResource(URI.createURI(processModelFile.getPath()), true);
		}

		processModel = (ProcessModel) resource.getContents().get(0);
	}

	public ProcessModel getProcessModel() {
		return processModel;
	}

	public File getProcessModelFile() {
		return processModelFile;
	}
}
