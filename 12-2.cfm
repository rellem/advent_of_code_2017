<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var childsByParent = {} />
	<cfset var line = '' />
	<cfset var words = '' />
	<cfset var parent = '' />
	<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
		<cfset words = ListToArray(Replace(Trim(line), ', ', ',', 'all'), Chr(32)) />
		<cfset parent = words[1] />
		<cfset childsByParent[parent] = ListToArray(words[3]) />
	</cfloop>

	<cfset var allSeen = { } />
	<cfset var groups = [] />
	<cfset var group = '' />
	<cfset var foundNewGroupMember = '' />
	<cfset var child = '' />
	<cfloop condition="true">
		<cfset group = {} />
		<cfloop collection="#childsByParent#" item="parent">
			<cfif !StructKeyExists(allSeen, parent)>
				<cfset allSeen[parent] = true />
				<cfset group[parent] = true />
				<cfset foundNewGroupMember = true />
				<cfbreak />
			</cfif>
		</cfloop>
		<cfif StructCount(group) eq 0>
			<cfbreak />
		</cfif>

		<cfloop condition="foundNewGroupMember">
			<cfset foundNewGroupMember = false />
			<cfloop collection="#childsByParent#" item="parent">
				<cfif StructKeyExists(group, parent)>
					<cfloop array="#childsByParent[parent]#" item="child">
						<cfif !StructKeyExists(group, child)>
							<cfset allSeen[child] = true />
							<cfset group[child] = true />
							<cfset foundNewGroupMember = true />
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>
		</cfloop>

		<cfset ArrayAppend(groups, group) />
	</cfloop>

	<cfreturn ArrayLen(groups) />
</cffunction>

<cfset testCases = [
	{
		input = '0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5',
		expectedOutput = '2'
	},
	{
		input = Trim(FileRead(ExpandPath('12.txt'))),
		expectedOutput = '211'
	},
	{
		input = '',
		expectedOutput = 0
	},
	{
		input = '3 <-> 3',
		expectedOutput = 1
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>12-2</title>
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
