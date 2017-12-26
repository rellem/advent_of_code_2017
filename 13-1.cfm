<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var firewall = {} />
	<cfset var maxDepth = 0 />
	<cfset var line = '' />
	<cfset var words = '' />
	<cfset var depth = '' />
	<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
		<cfset words = ListToArray(Trim(line), Chr(32)) />
		<cfset depth = Replace(words[1], ':', '') />
		<cfset firewall[depth] = words[2] />
		<cfset maxDepth = Max(maxDepth, depth) />
	</cfloop>

	<cfset var score = 0 />
	<cfset var myPos = '' />
	<cfloop from="0" to="#maxDepth#" index="myPos">
		<cfif StructKeyExists(firewall, myPos)>
			<cfif myPos % (firewall[myPos] * 2 - 2) eq 0>
				<cfset score += myPos * firewall[myPos] />
			</cfif>
		</cfif>
	</cfloop>

	<cfreturn score />
</cffunction>

<cfset testCases = [
	{
		input = '0: 3
1: 2
4: 4
6: 4',
		expectedOutput = 24
	},
	{
		input = Trim(FileRead(ExpandPath('13.txt'))),
		expectedOutput = 2508
	}
] />
<cfinclude template="test_runner_include.cfm" />
