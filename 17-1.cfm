<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var steps = arguments.input />
	<cfset var buffer = [] />
	<cfset var pos = 0 />
	<cfset buffer[pos+1] = 0 />
	<cfset var i = '' />
	<cfloop from="1" to="2017" index="i">
		<cfset pos = (pos + steps) % ArrayLen(buffer) + 1 />
		<cfif pos+1 gt ArrayLen(buffer)>
			<cfset ArrayAppend(buffer, i) />
		<cfelse>
			<cfset ArrayInsertAt(buffer, pos+1, i) />
		</cfif>
	</cfloop>

	<cfreturn buffer[(pos + 1) % ArrayLen(buffer) + 1] />
</cffunction>

<cfset testCases = [
	{
		input = '3',
		expectedOutput = 638
	},
	{
		input = Trim(FileRead(ExpandPath('17.txt'))),
		expectedOutput = 1971
	}
] />
<cfinclude template="test_runner_include.cfm" />
