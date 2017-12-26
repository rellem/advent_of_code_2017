<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var adventOfCode = CreateObject('component', 'AdventOfCode') />

	<cfset var firstEightInputLines = ArrayToList(ArraySlice(ListToArray(arguments.input, Chr(10)), 1, 8), Chr(10)) />
	<cfset var runResult = CreateObject('component', 'Day23Program').run(
		input = firstEightInputLines,
		initialRegisterValues = { a = 1 }
	) />

	<cfset var h = 0 />
	<cfset var b = '' />
	<cfloop from="#runResult.registers.b#" to="#runResult.registers.c#" step="17" index="b">
		<cfif !adventOfCode.isPrime(b)>
			<cfset h++ />
		</cfif>
	</cfloop>

	<cfreturn h />
</cffunction>

<cfset testCases = [
	{
		input = Trim(FileRead(ExpandPath('23.txt'))),
		expectedOutput = 915
	}
] />
<cfinclude template="test_runner_include.cfm" />
