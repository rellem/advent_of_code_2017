<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var adventOfCode = CreateObject('component', 'AdventOfCode') />

	<cfset var seen = {} />
	<cfset var programs = 'abcdefghijklmnop' />
	<cfset var dances = 0 />
	<cfset seen[programs] = dances />
	<cfset var cycle = '' />
	<cfloop condition="true">
		<cfset programs = adventOfCode.dance(programs, arguments.input) />
		<cfset dances++ />
		<cfif StructKeyExists(seen, programs)>
			<cfset cycle = dances - seen[programs] />
			<cfbreak />
		</cfif>
		<cfset seen[programs] = dances />
	</cfloop>

	<cfset var i = '' />
	<cfloop from="1" to="#(1000000000 - dances) % cycle#" index="i">
		<cfset programs = adventOfCode.dance(programs, arguments.input) />
	</cfloop>

	<cfreturn programs />
</cffunction>

<cfset testCases = [
	{
		input = Trim(FileRead(ExpandPath('16.txt'))),
		expectedOutput = 'agndefjhibklmocp'
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>16-2</title>
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
