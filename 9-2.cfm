<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var score = 0 />
	<cfset var level = 1 />
	<cfset var garbageCount = 0 />

	<cfset var inGarbage = false />
	<cfset var charIndex = 1 />
	<cfset var char = '' />
	<cfloop condition="charIndex lte Len(arguments.input)">
		<cfset char = Mid(arguments.input, charIndex, 1) />
		<cfif inGarbage>
			<cfif char eq '>'>
				<cfset inGarbage = false />
			<cfelseif char eq '!'>
				<cfset charIndex++ />
			<cfelse>
				<cfset garbageCount++ />
			</cfif>
		<cfelseif char eq '<'>
			<cfset inGarbage = true />
		<cfelseif char eq '{'>
			<cfset score += level />
			<cfset level++ />
		<cfelseif char eq '}'>
			<cfset level-- />
		<cfelseif char eq ','>
		<cfelse>
			<cfthrow message="Unexpected char: #char#" />
		</cfif>
		<cfset charIndex++ />
	</cfloop>

	<cfreturn garbageCount />
</cffunction>

<cfset testCases = [
	{
		input = '<>',
		expectedOutput = 0
	},
	{
		input = '<random characters>',
		expectedOutput = 17
	},
	{
		input = '<<<<>',
		expectedOutput = 3
	},
	{
		input = '<{!>}>',
		expectedOutput = 2
	},
	{
		input = '<!!>',
		expectedOutput = 0
	},
	{
		input = '<!!!>>',
		expectedOutput = 0
	},
	{
		input = '<{o"i!a,<{i<a>',
		expectedOutput = 10
	},
	{
		input = Trim(FileRead(ExpandPath('9.txt'))),
		expectedOutput = 10045
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>9-2</title>
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
					#EncodeForHTML(Left(testCase.input, 100))#
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
