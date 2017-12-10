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

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>6-1</title>
	<style type="text/css">
		table { border-collapse: collapse; }
		table, th, td { border: 1px solid grey; }
		th { text-align: left; padding: 2px 8px 2px 8px; }
		td { padding: 2px 8px 2px 8px; }
		span.correct { color: ##00ff00 }
		span.incorrect { color: ##ff0000 }
	</style>
</head>
<body>
<table>
	<thead>
		<tr>
			<th>Input</th>
			<th>Expected output</th>
			<th>Output</th>
			<th>Status</th>
			<th>Time taken</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#testCases#" item="testCase">
			<tr>
				<td>
					<pre>#EncodeForHTML(Left(testCase.input, 100))#</pre>
				</td>
				<td>
					<cfif StructKeyExists(testCase, 'expectedOutput')>
						#EncodeForHTML(testCase.expectedOutput)#
					</cfif>
				</td>
				<td>
					<cfset startTickCount = GetTickCount() />
					<cfset actualOutput = solve(testCase.input) />
					<cfset tickCountTaken = GetTickCount() - startTickCount />
					#EncodeForHTML(actualOutput)#
				</td>
				<td>
					<cfif StructKeyExists(testCase, 'expectedOutput')>
						<cfif actualOutput eq testCase.expectedOutput>
							<span class="correct">Correct</span>
						<cfelse>
							<span class="incorrect">Incorrect</span>
						</cfif>
					</cfif>
				</td>
				<td>#tickCountTaken# ms</td>
			</tr>
		</cfloop>
	</tbody>
</table>
</body>
</html>
</cfoutput>
