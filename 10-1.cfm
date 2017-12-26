<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />
	<cfargument name="numberOfNumbers" default="256" />

	<cfset var numbers = [] />
	<cfset var i = '' />
	<cfloop from="0" to="#arguments.numberOfNumbers - 1#" index="i">
		<cfset ArrayAppend(numbers, i) />
	</cfloop>

	<cfset var lengths = ListToArray(arguments.input) />

	<cfset var pos = 0 />
	<cfset var skipSize = 0 />
	<cfset var length = '' />
	<cfset var offset = '' />
	<cfset var indexFromStart = '' />
	<cfset var indexFromEnd = '' />
	<cfloop array="#lengths#" item="length">
		<cfloop from="0" to="#Floor(length / 2) - 1#" index="offset">
			<cfset indexFromStart = (pos + offset) % arguments.numberOfNumbers + 1 />
			<cfset indexFromEnd = (pos + length - 1 - offset) % arguments.numberOfNumbers + 1 />
			<cfset ArraySwap(numbers, indexFromStart, indexFromEnd) />
		</cfloop>

		<cfset pos = (pos + length + skipSize) % arguments.numberOfNumbers />
		<cfset skipSize++ />
	</cfloop>

	<cfreturn numbers[1] * numbers[2] />
</cffunction>

<cfset testCases = [
	{
		input = Trim(FileRead(ExpandPath('10.txt'))),
		expectedOutput = 2928
	}
] />
<cfinclude template="test_runner_include.cfm" />
