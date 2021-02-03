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

package be.uantwerpen.msdl.icm.runtime.querying

class AmesimQueryScriptTemplate {
	public static def generateAmesimQueryScript2() '''
		import sys
		print(sys.version)
	'''
	
	public static def generateAmesimQueryScript(String attributeName) '''
		import sys, os.path
		from ame_apy import *
		from amesim import *
		
		def query():
		  AMEInitAPI()
		  AMEOpenAmeFile('ElectricalModelTest.ame')
		  
		  model_name = AMEGetActiveCircuit()
		  
		  queryresult = AMEGetParameterValue('«attributeName»')
		  
		  print("queryresult: " + queryresult[0])
		  
		  AMECloseCircuit()
		  AMECloseAPI()
		  
		if __name__ == "__main__":
		  query()
	'''
}
