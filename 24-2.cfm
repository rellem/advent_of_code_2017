<cffunction name="buildBridges" returntype="void" output="false">
	<cfargument name="availableComps" required="true" />
	<cfargument name="nextPort" required="true" />
	<cfargument name="currentStrength" required="true" />
	<cfargument name="currentLength" required="true" />

	<cfset request.maxStrength = Max(request.maxStrength, arguments.currentStrength) />

	<cfif arguments.currentLength gt request.maxLength>
		<cfset request.maxLength = arguments.currentLength />
		<cfset request.maxStrengthForMaxLength = arguments.currentStrength />
	<cfelseif arguments.currentLength eq request.maxLength>
		<cfset request.maxStrengthForMaxLength = Max(request.maxStrengthForMaxLength, arguments.currentStrength) />
	</cfif>

	<cfset var comp = '' />
	<cfset var compIndex = '' />
	<cfset var port1 = '' />
	<cfset var port2 = '' />
	<cfloop list="#arguments.availableComps#" item="comp" index="compIndex">
		<cfset port1 = ListGetAt(comp, 1, '/') />
		<cfset port2 = ListGetAt(comp, 2, '/') />
		<cfif port1 eq arguments.nextPort || port2 eq arguments.nextPort>
			<cfset buildBridges(
				availableComps = ListDeleteAt(availableComps, compIndex),
				nextPort = port1 eq arguments.nextPort ? port2 : port1,
				currentStrength = arguments.currentStrength + port1 + port2,
				currentLength = arguments.currentLength + 1
			) />
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset request.maxStrength = 0 />
	<cfset request.maxLength = 0 />
	<cfset request.maxStrengthForMaxLength = 0 />

	<cfset buildBridges(
		availableComps = ListChangeDelims(Trim(arguments.input), ',', Chr(10)),
		nextPort = 0,
		currentStrength = 0,
		currentLength = 0
	) />

	<cfreturn request.maxStrengthForMaxLength />
</cffunction>

<cfset testCases = [
	{
		input = '0/2
2/2
2/3
3/4
3/5
0/1
10/1
9/10',
		expectedOutput = 19
	},
	{
		input = Trim(FileRead(ExpandPath('24.txt'))),
		expectedOutput = 1471
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>24-2</title>
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
