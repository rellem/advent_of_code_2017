<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var grid = CreateObject('component', 'Grid').init() />

	<cfset var lines = ListToArray(arguments.input, Chr(10)) />
	<cfset var line = '' />
	<cfset var lineIndex = '' />
	<cfset var char = '' />
	<cfset var charIndex = '' />
	<cfset var position = '' />
	<cfloop array="#lines#" item="line" index="lineIndex">
		<cfloop array="#ListToArray(line, '')#" item="char" index="charIndex">
			<cfset position = { x = charIndex, y = lineIndex } />
			<cfset grid.setValue(position, Trim(char)) />
		</cfloop>
	</cfloop>

	<cfset var foundStart = false />
	<cfset var x = '' />
	<cfloop from="1" to="#Len(lines[1])#" index="x">
		<cfset position = { x = x, y = 1 } />
		<cfif grid.getValue(position) eq '|'>
			<cfset foundStart = true />
			<cfbreak />
		</cfif>
	</cfloop>
	<cfif !foundStart>
		<cfthrow message="Did not find the start position" />
	</cfif>

	<cfset var numMoves = 0 />
	<cfset var currentPosition = { x = x, y = 1 } />
	<cfset var nextPosition = '' />
	<cfset var currentDirection = 'DOWN' />
	<cfset var nextDirection = '' />
	<cfset var foundNext = '' />
	<cfloop condition="true">
		<cfset numMoves++ />

		<cfset foundNext = false />
		<cfloop array="#[ currentDirection, grid.turnLeft(currentDirection), grid.turnRight(currentDirection) ]#" item="nextDirection">
			<cfset nextPosition = grid.move(currentPosition, nextDirection) />
			<cfif Len(grid.getValue(nextPosition, '')) gt 0>
				<cfset foundNext = true />
				<cfbreak />
			</cfif>
		</cfloop>

		<cfif !foundNext>
			<cfbreak />
		</cfif>

		<cfset currentPosition = nextPosition />
		<cfset currentDirection = nextDirection />
	</cfloop>

	<cfreturn numMoves />
</cffunction>

<cfset testCases = [
	{
		input = '     |
     |  +--+
     A  |  C
 F---|----E|--+
     |  |  |  D
     +B-+  +--+
',
		expectedOutput = 38
	},
	{
		input = FileRead(ExpandPath('19.txt')),
		expectedOutput = 16162
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>19-2</title>
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
