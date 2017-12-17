<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var adventOfCode = CreateObject('component', 'AdventOfCode') />

	<cfset var programs = 'abcdefghijklmnop' />
	<cfreturn adventOfCode.dance(programs, arguments.input) />
</cffunction>

<cfset testCases = [
	{
		input = Trim(FileRead(ExpandPath('16.txt'))),
		expectedOutput = 'doeaimlbnpjchfkg'
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>16-1</title>
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
					<cfflush />
					<cfset startTickCount = GetTickCount() />
					<cfset actualOutput = solve(testCase.input) />
					<cfset tickCountTaken = GetTickCount() - startTickCount />
					#EncodeForHTML(actualOutput)#
					<cfflush />
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
