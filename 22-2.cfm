<cfsetting requesttimeout="300" />

<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var grid = CreateObject('component', 'Grid').init() />
	<cfset var line = '' />
	<cfset var lineIndex = '' />
	<cfset var char = '' />
	<cfset var charIndex = '' />
	<cfset var position = '' />
	<cfloop list="#arguments.input#" item="line" index="lineIndex" delimiters="#Chr(10)#">
		<cfloop array="#ListToArray(Trim(line), '')#" item="char" index="charIndex">
			<cfset position = { x = charIndex, y = lineIndex } />
			<cfset grid.setValue(position, char) />
		</cfloop>
	</cfloop>

	<cfset var infections = 0 />
	<cfset var center = (Len(line) - 1) / 2 + 1 />
	<cfset var currentPosition = { x = center, y = center } />
	<cfset var currentDirection = 'UP' />
	<cfset var burst = '' />
	<cfloop from="1" to="10000000" index="burst">
		<cfswitch expression="#grid.getValue(currentPosition, '.')#">
			<cfcase value="##">
				<cfset currentDirection = grid.turnRight(currentDirection) />
				<cfset grid.setValue(currentPosition, 'F') />
			</cfcase>
			<cfcase value="F">
				<cfset currentDirection = grid.turnLeft(grid.turnLeft(currentDirection)) />
				<cfset grid.setValue(currentPosition, '.') />
			</cfcase>
			<cfcase value="W">
				<cfset grid.setValue(currentPosition, '##') />
				<cfset infections++ />
			</cfcase>
			<cfcase value=".">
				<cfset currentDirection = grid.turnLeft(currentDirection) />
				<cfset grid.setValue(currentPosition, 'W') />
			</cfcase>
			<cfdefaultcase>
				<cfthrow message="Unexpected" />
			</cfdefaultcase>
		</cfswitch>
		<cfset currentPosition = grid.move(currentPosition, currentDirection) />
	</cfloop>

	<cfreturn infections />
</cffunction>

<cfset testCases = [
	{
		input = '..##
##..
...',
		expectedOutput = 2511944
	},
	{
		input = Trim(FileRead(ExpandPath('22.txt'))),
		expectedOutput = 2512059
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>22-2</title>
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
