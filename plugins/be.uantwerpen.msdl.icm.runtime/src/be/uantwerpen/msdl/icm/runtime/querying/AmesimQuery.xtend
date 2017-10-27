package be.uantwerpen.msdl.icm.runtime.querying

import be.uantwerpen.msdl.processmodel.properties.Attribute
import be.uantwerpen.msdl.processmodel.properties.impl.AmesimAttributeDefinitionImpl
import com.google.common.collect.Lists
import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.File
import java.io.FileWriter
import java.io.InputStreamReader
import java.util.List
import org.apache.log4j.Level
import org.apache.log4j.Logger

class AmesimQuery extends AmesimAttributeDefinitionImpl implements IExecutable {

	private val logger = Logger.getLogger(this.class)
	private val AMESIM_LOCATION = new File("D:\\tools\\LMS\\LMS Imagine.Lab Amesim\\v1400")
	private val QUERY_RESULT_LABEL = "queryresult:"
	private val ERROR_MSG = "From AMEGetParameterValue: fail to locate parameter or variable in the active circuit:"

	private var Attribute attribute;

	new(Attribute attribute) {
		this.attribute = attribute
	}

	override execute() {
		logger.level = Level::OFF

		val file = File.createTempFile("amesimquery", ".py", AMESIM_LOCATION)
		file.deleteOnExit()
		val bufferedWriter = new BufferedWriter(new FileWriter(file))

		val scriptText = AmesimQueryScriptTemplate.generateAmesimQueryScript(attribute.name).toString
		bufferedWriter.write(scriptText)
		bufferedWriter.close();

		logger.debug(file.getAbsolutePath())
		logger.debug(scriptText)

		val command = '"' + AMESIM_LOCATION + '\\python.bat" "' + file.absolutePath + '"'
		logger.debug('command: ' + command)

		val processBuilder = new ProcessBuilder(command)
		processBuilder.directory(AMESIM_LOCATION)
		val process = processBuilder.start

		val bufferedReader = new BufferedReader(new InputStreamReader(process.inputStream))
		val errorReader = new BufferedReader(new InputStreamReader(process.errorStream))

		evaluate(bufferedReader, errorReader)
	}

	private def evaluate(BufferedReader bufferedReader, BufferedReader errorReader) {
		val List<String> blines = Lists::newArrayList(bufferedReader.lines().toArray)
		if (!blines.empty) {
			for (line : blines) {
				logger.debug(line)
				if (line.trim.startsWith(QUERY_RESULT_LABEL)) {
					return Double.parseDouble(line.split(':').last.trim)
				}
			}
		}

		// TODO do some meaningful error handling here
		val List<String> elines = Lists::newArrayList(errorReader.lines().toArray)
		if (!elines.empty) {
			for (line : elines) {
				logger.debug(line)
				if (line.trim.startsWith(ERROR_MSG)) {
					return null
				}
			}
		}
	}

}
