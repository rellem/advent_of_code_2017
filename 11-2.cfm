<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var x = 0 />
	<cfset var y = 0 />
	<cfset var direction = '' />
	<cfset var distanceFromStart = 0 />
	<cfset var maxDistanceFromStart = 0 />

	<cfloop list="#arguments.input#" item="direction">
		<cfif direction eq 'ne'>
			<cfset x += 0.5 />
			<cfset y += 0.5 />
		<cfelseif direction eq 'n'>
			<cfset x += 0 />
			<cfset y += 1 />
		<cfelseif direction eq 'nw'>
			<cfset x -= 0.5 />
			<cfset y += 0.5 />
		<cfelseif direction eq 'sw'>
			<cfset x -= 0.5 />
			<cfset y -= 0.5 />
		<cfelseif direction eq 's'>
			<cfset x += 0 />
			<cfset y -= 1 />
		<cfelseif direction eq 'se'>
			<cfset x += 0.5 />
			<cfset y -= 0.5 />
		<cfelse>
			<cfthrow message="Unexpected direction: #direction#" />
		</cfif>
		<cfset distanceFromStart = Abs(x) + Abs(y) />
		<cfset maxDistanceFromStart = Max(maxDistanceFromStart, distanceFromStart) />
	</cfloop>

	<cfreturn maxDistanceFromStart />
</cffunction>

<cfset testCases = [
	{
		input = Trim(FileRead(ExpandPath('11.txt'))),
		expectedOutput = 1490
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>11-2</title>
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
					<cfset maxCharsToDisplay = 50 />
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
