<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var adventOfCode = CreateObject('component', 'AdventOfCode') />

	<cfreturn adventOfCode.getKnotHash(arguments.input) />
</cffunction>

<cfset testCases = [
	{
		input = '',
		expectedOutput = 'a2582a3a0e66e6e86e3812dcb672a272'
	},
	{
		input = 'AoC 2017',
		expectedOutput = '33efeb34ea91902bb2f59c9920caa6cd'
	},
	{
		input = '1,2,3',
		expectedOutput = '3efbe78a8d82f29979031a4aa0b16a9d'
	},
	{
		input = '1,2,4',
		expectedOutput = '63960835bcdc130f0b66d7ff4f6a5a8e'
	},
	{
		input = Trim(FileRead(ExpandPath('10.txt'))),
		expectedOutput = '0c2f794b2eb555f7830766bf8fb65a16'
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>10-2</title>
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
