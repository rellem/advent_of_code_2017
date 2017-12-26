<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var banks = ListToArray(Trim(arguments.input), Chr(9)) />
	<cfset var numberOfBanks = ArrayLen(banks) />

	<cfset var seen = {} />
	<cfset var key = ArrayToList(banks) />
	<cfset seen[key] = 0 />

	<cfset var numberOfCycles = 0 />
	<cfset var maxNumberOfBlocks = '' />
	<cfset var firstBankWithMaxNumberOfBlocks = '' />
	<cfset var offset = '' />
	<cfloop condition="true">
		<cfset numberOfCycles++ />

		<cfset maxNumberOfBlocks = ArrayMax(banks) />
		<cfset firstBankWithMaxNumberOfBlocks = ArrayFind(banks, maxNumberOfBlocks) />

		<cfset banks[firstBankWithMaxNumberOfBlocks] = 0 />
		<cfloop from="1" to="#maxNumberOfBlocks#" index="offset">
			<cfset banks[(firstBankWithMaxNumberOfBlocks + offset - 1) mod numberOfBanks + 1]++ />
		</cfloop>

		<cfset key = ArrayToList(banks) />
		<cfif StructKeyExists(seen, key)>
			<cfreturn numberOfCycles />
		</cfif>
		<cfset seen[key] = numberOfCycles />
	</cfloop>
</cffunction>

<cfset testCases = [
	{
		input = '0	2	7	0',
		expectedOutput = 5
	},
	{
		input = Trim(FileRead(ExpandPath('6.txt'))),
		expectedOutput = 4074
	}
] />
<cfinclude template="test_runner_include.cfm" />
