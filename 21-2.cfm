<cfsetting requesttimeout="600" />

<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var imageEnhancer = CreateObject('component', 'Day21ImageEnhancer') />
	<cfset var startingGrid = imageEnhancer.getStartingGrid() />
	<cfset var rules = imageEnhancer.getRulesFromInput(arguments.input) />
	<cfset var iterations = 18 />
	<cfset var enhancedGrid = imageEnhancer.enhance(startingGrid, rules, iterations) />

	<cfreturn enhancedGrid.countValues('##') />
</cffunction>

<cfset testCases = [
	{
		input = Trim(FileRead(ExpandPath('21.txt'))),
		expectedOutput = 2480380
	}
] />
<cfinclude template="test_runner_include.cfm" />
