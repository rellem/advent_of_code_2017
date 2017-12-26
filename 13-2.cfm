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

	<cfset var tick = '' />
	<cfset var myPos = '' />
	<cfset var delay = -1 />
	<cfset var hit = true />
	<cfloop condition="hit">
		<cfset delay++ />
		<cfset myPos = -1 />
		<cfset hit = false />
		<cfset tick = delay />
		<cfloop condition="myPos lt maxDepth">
			<cfset myPos++ />
			<cfif StructKeyExists(firewall, myPos)>
				<cfif tick % (firewall[myPos] * 2 - 2) eq 0>
					<cfset hit = true />
					<cfbreak />
				</cfif>
			</cfif>
			<cfset tick++ />
		</cfloop>
	</cfloop>

	<cfreturn delay />
</cffunction>

<cfset testCases = [
	{
		input = '0: 3
1: 2
4: 4
6: 4',
		expectedOutput = 10
	},
	{
		input = Trim(FileRead(ExpandPath('13.txt'))),
		expectedOutput = 3913186
	}
] />
<cfinclude template="test_runner_include.cfm" />
