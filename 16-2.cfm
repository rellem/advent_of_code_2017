<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var adventOfCode = CreateObject('component', 'AdventOfCode') />

	<cfset var seen = {} />
	<cfset var programs = 'abcdefghijklmnop' />
	<cfset var dances = 0 />
	<cfset seen[programs] = dances />
	<cfset var cycle = '' />
	<cfloop condition="true">
		<cfset programs = adventOfCode.dance(programs, arguments.input) />
		<cfset dances++ />
		<cfif StructKeyExists(seen, programs)>
			<cfset cycle = dances - seen[programs] />
			<cfbreak />
		</cfif>
		<cfset seen[programs] = dances />
	</cfloop>

	<cfset var i = '' />
	<cfloop from="1" to="#(1000000000 - dances) % cycle#" index="i">
		<cfset programs = adventOfCode.dance(programs, arguments.input) />
	</cfloop>

	<cfreturn programs />
</cffunction>

<cfset testCases = [
	{
		input = Trim(FileRead(ExpandPath('16.txt'))),
		expectedOutput = 'agndefjhibklmocp'
	}
] />
<cfinclude template="test_runner_include.cfm" />
