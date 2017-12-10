<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var programNamesSeenOnRightSide = {} />

	<cfset var line = '' />
	<cfset var words = '' />
	<cfset var programNamesOnRightSide = '' />
	<cfset var programName = '' />
	<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
		<cfset line = Trim(line) />
		<cfset words = ListToArray(line, Chr(32)) />

		<cfif line contains '->'>
			<cfset programNamesOnRightSide = Replace(Trim(ListGetAt(line, 2, '>')), ' ', '', 'all') />
			<cfloop list="#programNamesOnRightSide#" item="programName">
				<cfset programNamesSeenOnRightSide[programName] = 1 />
			</cfloop>
		</cfif>
	</cfloop>

	<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
		<cfset line = Trim(line) />
		<cfset words = ListToArray(line, Chr(32)) />

		<cfif line contains '->'>
			<cfset programName = ListFirst(line, ' ') />
			<cfif !StructKeyExists(programNamesSeenOnRightSide, programName)>
				<cfreturn programName />
			</cfif>
		</cfif>
	</cfloop>

	<cfthrow message="Did not find root program" />
</cffunction>

<cfset testCases = [
	{
		input = 'pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)',
		expectedOutput = 'tknk'
	},
	{
		input = Trim(FileRead(ExpandPath('7.txt'))),
		expectedOutput = 'ahnofa'
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>7-1</title>
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
