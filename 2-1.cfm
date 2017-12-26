<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var sum = 0 />
	<cfset var row = '' />
	<cfset var rowNumbers = '' />
	<cfloop list="#arguments.input#" item="row" delimiters="#Chr(10)#">
		<cfset rowNumbers = ListToArray(row, Chr(9)) />
		<cfset sum += ArrayMax(rowNumbers) - ArrayMin(rowNumbers) />
	</cfloop>

	<cfreturn sum />
</cffunction>

<cfset testCases = [
	{
		input = '5	1	9	5
7	5	3
2	4	6	8',
		expectedOutput = 18
	},
	{
		input = Trim(FileRead(ExpandPath('2.txt'))),
		expectedOutput = 58975
	}
] />
<cfinclude template="test_runner_include.cfm" />
