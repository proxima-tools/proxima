package be.uantwerpen.msdl.process.dse.rules

import be.uantwerpen.msdl.process.dse.rules.parallel.ParallelModify
import be.uantwerpen.msdl.process.dse.rules.sequential.ReadModify

class RulesFactory {
	
	public static val ruleGroups=#[
		new ReadModify,
		new ParallelModify
	]
}