<cffunction name="buildBridges" returntype="void" output="false">
	<cfargument name="availableComps" required="true" />
	<cfargument name="nextPort" required="true" />
	<cfargument name="currentStrength" required="true" />

	<cfset request.maxStrength = Max(request.maxStrength, arguments.currentStrength) />

	<cfset var comp = '' />
	<cfset var compIndex = '' />
	<cfset var port1 = '' />
	<cfset var port2 = '' />
	<cfloop list="#arguments.availableComps#" item="comp" index="compIndex">
		<cfset port1 = ListGetAt(comp, 1, '/') />
		<cfset port2 = ListGetAt(comp, 2, '/') />
		<cfif port1 eq arguments.nextPort || port2 eq arguments.nextPort>
			<cfset buildBridges(
				availableComps = ListDeleteAt(availableComps, compIndex),
				nextPort = port1 eq arguments.nextPort ? port2 : port1,
				currentStrength = arguments.currentStrength + port1 + port2
			) />
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset request.maxStrength = 0 />

	<cfset buildBridges(
		availableComps = ListChangeDelims(Trim(arguments.input), ',', Chr(10)),
		nextPort = 0,
		currentStrength = 0
	) />

	<cfreturn request.maxStrength />
</cffunction>

<cfset testCases = [
	{
		input = '0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10',
		expectedOutput = 31
	},
	{
		input = Trim(FileRead(ExpandPath('24.txt'))),
		expectedOutput = 1511
	}
] />
<cfinclude template="test_runner_include.cfm" />
