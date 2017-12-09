<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var jumpOffsets = [] />
	<cfset var line = '' />
	<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
		<cfset ArrayAppend(jumpOffsets, Trim(line)) />
	</cfloop>
	<cfset var numJumpOffsets = ArrayLen(jumpOffsets) />

	<cfset var jumpsTaken = 0 />
	<cfset var pos = 1 />
	<cfset var newPos = '' />
	<cfloop condition="pos lte numJumpOffsets">
		<cfset newPos = pos + jumpOffsets[pos] />
		<cfif jumpOffsets[pos] gte 3>
			<cfset jumpOffsets[pos]-- />
		<cfelse>
			<cfset jumpOffsets[pos]++ />
		</cfif>
		<cfset pos = newPos />
		<cfset jumpsTaken++ />
	</cfloop>

	<cfreturn jumpsTaken />
</cffunction>

<cfset testCases = [
	{
		input = '0
3
0
1
-3',
		expectedOutput = 10
	},
	{
		input = Trim(FileRead(ExpandPath('5.txt'))),
		expectedOutput = 25608480
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>5-2</title>
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
			<cfif Len(testCase.input) eq 0>
				<cfcontinue />
			</cfif>
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
