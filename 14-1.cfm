<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var adventOfCode = CreateObject('component', 'AdventOfCode') />

	<cfset var numSquaresUsed = 0 />
	<cfset var rowIndex = '' />
	<cfset var knotHash = '' />
	<cfset var charIndex = '' />
	<cfset var char = '' />
	<cfset var bits = '' />
	<cfloop from="0" to="127" index="rowIndex">
		<cfset knotHash = adventOfCode.getKnotHash(arguments.input & '-' & rowIndex) />
		<cfloop from="1" to="#Len(knotHash)#" index="charIndex">
			<cfset char = Mid(knotHash, charIndex, 1) />
			<cfset bits = Right('0000' & FormatBaseN(InputBaseN(char, 16), 2), 4) />
			<cfset numSquaresUsed += Len(Replace(bits, '0', '', 'all')) />
		</cfloop>
	</cfloop>

	<cfreturn numSquaresUsed />
</cffunction>

<cfset testCases = [
	{
		input = 'flqrgnkx',
		expectedOutput = 8108
	},
	{
		input = Trim(FileRead(ExpandPath('14.txt'))),
		expectedOutput = 8194
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>14-1</title>
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
					<cfset maxCharsToDisplay = 100 />
					<pre>#EncodeForHTML(Left(testCase.input, maxCharsToDisplay))#<cfif Len(testCase.input) gt maxCharsToDisplay>&hellip;</cfif></pre>
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
