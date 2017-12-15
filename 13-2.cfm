<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var firewall = {} />
	<cfset var maxDepth = 0 />
	<cfset var line = '' />
	<cfset var words = '' />
	<cfset var depth = '' />
	<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
		<cfset words = ListToArray(Trim(line), Chr(32)) />
		<cfset depth = Replace(words[1], ':', '') />
		<cfset firewall[depth] = words[2] />
		<cfset maxDepth = Max(maxDepth, depth) />
	</cfloop>

	<cfset var tick = '' />
	<cfset var myPos = '' />
	<cfset var delay = -1 />
	<cfset var hit = true />
	<cfloop condition="hit">
		<cfset delay++ />
		<cfset myPos = -1 />
		<cfset hit = false />
		<cfset tick = delay />
		<cfloop condition="myPos lt maxDepth">
			<cfset myPos++ />
			<cfif StructKeyExists(firewall, myPos)>
				<cfif tick % (firewall[myPos] * 2 - 2) eq 0>
					<cfset hit = true />
					<cfbreak />
				</cfif>
			</cfif>
			<cfset tick++ />
		</cfloop>
	</cfloop>

	<cfreturn delay />
</cffunction>

<cfset testCases = [
	{
		input = '0: 3
1: 2
4: 4
6: 4',
		expectedOutput = 10
	},
	{
		input = Trim(FileRead(ExpandPath('13.txt'))),
		expectedOutput = 3913186
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>13-2</title>
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
