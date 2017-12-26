<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var inputLength = Len(arguments.input) />
	<cfset var offset = inputLength / 2 />
	<cfset var sum = 0 />
	<cfset var pos = '' />
	<cfset var currentDigit = '' />
	<cfset var otherDigit = '' />
	<cfloop from="1" to="#inputLength#" index="pos">
		<cfset currentDigit = Mid(input, pos, 1) />
		<cfset otherDigit = Mid(input, (pos + offset - 1) mod inputLength + 1, 1) />
		<cfif currentDigit eq otherDigit>
			<cfset sum += currentDigit />
		</cfif>
	</cfloop>

	<cfreturn sum />
</cffunction>

<cfset testCases = [
	{
		input = '1212',
		expectedOutput = 6
	},
	{
		input = '1221',
		expectedOutput = 0
	},
	{
		input = '123425',
		expectedOutput = 4
	},
	{
		input = '123123',
		expectedOutput = 12
	},
	{
		input = '12131415',
		expectedOutput = 4
	},
	{
		input = Trim(FileRead(ExpandPath('1.txt'))),
		expectedOutput = 1292
	}
] />
<cfinclude template="test_runner_include.cfm" />
