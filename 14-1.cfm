<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var adventOfCode = CreateObject('component', 'AdventOfCode') />

	<cfset var numSquaresUsed = 0 />
	<cfset var rowIndex = '' />
	<cfset var knotHash = '' />
	<cfset var charIndex = '' />
	<cfset var char = '' />
	<cfset var bits = '' />
	<cfloop from="0" to="127" index="rowIndex">
		<cfset knotHash = adventOfCode.getKnotHash(arguments.input & '-' & rowIndex) />
		<cfloop from="1" to="#Len(knotHash)#" index="charIndex">
			<cfset char = Mid(knotHash, charIndex, 1) />
			<cfset bits = Right('0000' & FormatBaseN(InputBaseN(char, 16), 2), 4) />
			<cfset numSquaresUsed += Len(Replace(bits, '0', '', 'all')) />
		</cfloop>
	</cfloop>

	<cfreturn numSquaresUsed />
</cffunction>

<cfset testCases = [
	{
		input = 'flqrgnkx',
		expectedOutput = 8108
	},
	{
		input = Trim(FileRead(ExpandPath('14.txt'))),
		expectedOutput = 8194
	}
] />
<cfinclude template="test_runner_include.cfm" />
