<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />
	<cfargument name="numberOfNumbers" default="256" />

	<cfset var numbers = [] />
	<cfset var i = '' />
	<cfloop from="0" to="#arguments.numberOfNumbers - 1#" index="i">
		<cfset ArrayAppend(numbers, i) />
	</cfloop>

	<cfset var lengths = ListToArray(arguments.input) />

	<cfset var pos = 0 />
	<cfset var skipSize = 0 />
	<cfset var length = '' />
	<cfset var offset = '' />
	<cfset var indexFromStart = '' />
	<cfset var indexFromEnd = '' />
	<cfloop array="#lengths#" item="length">
		<cfloop from="0" to="#Floor(length / 2) - 1#" index="offset">
			<cfset indexFromStart = (pos + offset) % arguments.numberOfNumbers + 1 />
			<cfset indexFromEnd = (pos + length - 1 - offset) % arguments.numberOfNumbers + 1 />
			<cfset ArraySwap(numbers, indexFromStart, indexFromEnd) />
		</cfloop>

		<cfset pos = (pos + length + skipSize) % arguments.numberOfNumbers />
		<cfset skipSize++ />
	</cfloop>

	<cfreturn numbers[1] * numbers[2] />
</cffunction>

<cfset testCases = [
	{
		input = '3, 4, 1, 5',
		numberOfNumbers = 5,
		expectedOutput = 12
	} ,
	{
		input = Trim(FileRead(ExpandPath('10.txt'))),
		expectedOutput = 2928
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>10-1</title>
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
					<cfset actualOutput = solve(argumentCollection = testCase) />
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
