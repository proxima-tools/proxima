package be.uantwerpen.msdl.icm.examples.full.main;

import java.io.File;
import java.util.List;

import org.junit.Test;

import com.google.common.collect.Lists;

import be.uantwerpen.msdl.icm.examples.full.main.scripts.A1;
import be.uantwerpen.msdl.icm.examples.full.main.scripts.A2;
import be.uantwerpen.msdl.icm.examples.full.main.scripts.A3;
import be.uantwerpen.msdl.icm.examples.full.main.scripts.A4;
import be.uantwerpen.msdl.icm.runtime.CommandInterpreter;
import be.uantwerpen.msdl.icm.runtime.EnactmentManager;
import be.uantwerpen.msdl.icm.scripting.scripts.JavaBasedScript;

public class Runner {

	@Test
	public void run() {
		EnactmentManager enactmentManager = new EnactmentManager(new File("processes\\attributetest.processmodel"), getScripts());
		new CommandInterpreter(enactmentManager).interpret();
	}
	
	private List<Class<? extends JavaBasedScript>> getScripts(){
		List<Class<? extends JavaBasedScript>> scripts = Lists.newArrayList();
		
		scripts.add(A1.class);
		scripts.add(A2.class);
		scripts.add(A3.class);
		scripts.add(A4.class);
		
		return scripts;
	}
}
