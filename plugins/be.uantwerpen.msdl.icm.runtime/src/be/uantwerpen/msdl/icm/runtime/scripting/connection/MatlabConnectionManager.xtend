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
package be.uantwerpen.msdl.icm.runtime.scripting.connection

import com.mathworks.engine.MatlabEngine
import org.apache.log4j.Level
import org.apache.log4j.Logger
import org.eclipse.xtend.lib.annotations.Accessors

class MatlabConnectionManager {

	private static Logger logger = Logger.getLogger('MatlabConnectionManager')

	@Accessors(NONE) var static MatlabEngine matlabEngine = null

	private new() {
	}

	def static getMatlabEngine() {
		logger.level = Level::DEBUG
		if (matlabEngine == null) {
			logger.debug('No running MATLAB engine found, starting a new one.')
			matlabEngine = MatlabEngine.startMatlab
			matlabEngine.eval("matlab.engine.shareEngine('engine001')")
			logger.debug('MATLAB engine started and shared with ID "engine001".')
		}
		logger.debug('Returning MATLAB engine "engine001".')
		matlabEngine
	}
}
