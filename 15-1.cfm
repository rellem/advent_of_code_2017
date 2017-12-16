<cfsetting requesttimeout="3600" />

<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var startingValueA = Trim(ListGetAt(arguments.input, 5, ' #Chr(10)#')) />
	<cfset var startingValueB = Trim(ListGetAt(arguments.input, 10, ' #Chr(10)#')) />
	<cfset var generatorA = CreateObject('component', 'Day15Generator').init(startingValue = startingValueA, factor = 16807) />
	<cfset var generatorB = CreateObject('component', 'Day15Generator').init(startingValue = startingValueB, factor = 48271) />
	<cfset var matches = 0 />
	<cfset var i = '' />
	<cfloop from="1" to="40000000" index="i">
		<cfif BitAnd(generatorA.next(), 65535) eq BitAnd(generatorB.next(), 65535) >
			<cfset matches++ />
			<cflog file="AdventOfCode" text="Pair #i# matches - Number of matches: #matches#" />
		</cfif>
	</cfloop>

	<cfreturn matches />
</cffunction>

<cfset testCases = [
	{
		input = 'Generator A starts with 65
Generator B starts with 8921
',
		expectedOutput = 588
	},
	{
		input = Trim(FileRead(ExpandPath('15.txt'))),
		expectedOutput = 567
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>15-1</title>
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
