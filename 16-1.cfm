<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var adventOfCode = CreateObject('component', 'AdventOfCode') />

	<cfset var programs = 'abcdefghijklmnop' />
	<cfreturn adventOfCode.dance(programs, arguments.input) />
</cffunction>

<cfset testCases = [
	{
		input = Trim(FileRead(ExpandPath('16.txt'))),
		expectedOutput = 'doeaimlbnpjchfkg'
	}
] />
<cfinclude template="test_runner_include.cfm" />
