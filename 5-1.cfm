<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var jumpOffsets = [] />
	<cfset var line = '' />
	<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
		<cfset ArrayAppend(jumpOffsets, Trim(line)) />
	</cfloop>
	<cfset var numJumpOffsets = ArrayLen(jumpOffsets) />

	<cfset var jumpsTaken = 0 />
	<cfset var pos = 1 />
	<cfset var newPos = '' />
	<cfloop condition="pos lte numJumpOffsets">
		<cfset newPos = pos + jumpOffsets[pos] />
		<cfset jumpOffsets[pos]++ />
		<cfset pos = newPos />
		<cfset jumpsTaken++ />
	</cfloop>

	<cfreturn jumpsTaken />
</cffunction>

<cfset testCases = [
	{
		input = '0
3
0
1
-3',
		expectedOutput = 5
	},
	{
		input = Trim(FileRead(ExpandPath('5.txt'))),
		expectedOutput = 372671
	}
] />
<cfinclude template="test_runner_include.cfm" />
