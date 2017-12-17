<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var steps = arguments.input />
	<cfset var buffer = [] />
	<cfset var pos = 0 />
	<cfset buffer[pos+1] = 0 />
	<cfset var i = '' />
	<cfloop from="1" to="2017" index="i">
		<cfset pos = (pos + steps) % ArrayLen(buffer) + 1 />
		<cfif pos+1 gt ArrayLen(buffer)>
			<cfset ArrayAppend(buffer, i) />
		<cfelse>
			<cfset ArrayInsertAt(buffer, pos+1, i) />
		</cfif>
	</cfloop>

	<cfreturn buffer[(pos + 1) % ArrayLen(buffer) + 1] />
</cffunction>

<cfset testCases = [
	{
		input = '3',
		expectedOutput = 638
	},
	{
		input = Trim(FileRead(ExpandPath('17.txt'))),
		expectedOutput = 1971
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>17-1</title>
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
