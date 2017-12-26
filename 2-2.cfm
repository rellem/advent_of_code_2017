<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var sum = 0 />
	<cfset var row = '' />
	<cfset var rowNumbers = '' />
	<cfset var number1 = '' />
	<cfset var number2 = '' />
	<cfset var index1 = '' />
	<cfset var index2 = '' />
	<cfloop list="#arguments.input#" item="row" delimiters="#Chr(10)#">
		<cfset rowNumbers = ListToArray(row, Chr(9)) />
		<cfloop from="1" to="#ArrayLen(rowNumbers)#" index="index1">
			<cfset number1 = rowNumbers[index1] />
			<cfloop from="#index1 + 1#" to="#ArrayLen(rowNumbers)#" index="index2">
				<cfset number2 = rowNumbers[index2] />

				<cfif number1 mod number2 eq 0>
					<cfset sum += number1 / number2 />
				<cfelseif number2 mod number1 eq 0>
					<cfset sum += number2 / number1 />
				</cfif>
			</cfloop>
		</cfloop>
	</cfloop>

	<cfreturn sum />
</cffunction>

<cfset testCases = [
	{
		input = '5	9	2	8
9	4	7	3
3	8	6	5',
		expectedOutput = 9
	},
	{
		input = Trim(FileRead(ExpandPath('2.txt'))),
		expectedOutput = 308
	}
] />
<cfinclude template="test_runner_include.cfm" />
