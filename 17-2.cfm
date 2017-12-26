<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var steps = arguments.input />
	<cfset var pos = 0 />
	<cfset var i = '' />
	<cfset var answer = '' />
	<cfloop from="1" to="50000000" index="i">
		<cfset pos = (pos + steps) % i + 1 />
		<cfif pos eq 1>
			<cfset answer = i />
		</cfif>
	</cfloop>

	<cfreturn answer />
</cffunction>

<cfset testCases = [
	{
		input = Trim(FileRead(ExpandPath('17.txt'))),
		expectedOutput = 17202899
	}
] />
<cfinclude template="test_runner_include.cfm" />
