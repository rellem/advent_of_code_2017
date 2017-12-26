<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var runResult = CreateObject('component', 'Day23Program').run(
		input = arguments.input,
		initialRegisterValues = {}
	) />
	<cfreturn runResult.counters.numberOfMultiplications />
</cffunction>

<cfset testCases = [
	{
		input = Trim(FileRead(ExpandPath('23.txt'))),
		expectedOutput = 3025
	}
] />
<cfinclude template="test_runner_include.cfm" />
