<cfsetting requesttimeout="3600" />

<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var startingValueA = Trim(ListGetAt(arguments.input, 5, ' #Chr(10)#')) />
	<cfset var startingValueB = Trim(ListGetAt(arguments.input, 10, ' #Chr(10)#')) />
	<cfset var generatorA = CreateObject('component', 'Day15Generator').init(startingValue = startingValueA, factor = 16807) />
	<cfset var generatorB = CreateObject('component', 'Day15Generator').init(startingValue = startingValueB, factor = 48271) />
	<cfset var matches = 0 />
	<cfset var i = '' />
	<cfloop from="1" to="5000000" index="i">
		<cfif BitAnd(generatorA.nextMultipleOf(4), 65535) eq BitAnd(generatorB.nextMultipleOf(8), 65535) >
			<cfset matches++ />
			<cflog file="AdventOfCode" text="Pair #i# matches - Number of matches: #matches#" />
		</cfif>
	</cfloop>

	<cfreturn matches />
</cffunction>

<cfset testCases = [
	{
		input = 'Generator A starts with 65
Generator B starts with 8921
',
		expectedOutput = 309
	},
	{
		input = Trim(FileRead(ExpandPath('15.txt'))),
		expectedOutput = 323
	}
] />
<cfinclude template="test_runner_include.cfm" />
