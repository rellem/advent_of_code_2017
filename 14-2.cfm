<cffunction name="findAndMarkNeighbours" output="false">
	<cfargument name="grid" required="true" />
	<cfargument name="rowIndex" required="true" />
	<cfargument name="colIndex" required="true" />

	<cfif arguments.rowIndex lt 0 || arguments.rowIndex gt 127 || arguments.colIndex lt 0 || arguments.colIndex gt 127 || arguments.grid[arguments.rowIndex][arguments.colIndex] eq '0'>
		<cfreturn />
	</cfif>

	<cfset arguments.grid[arguments.rowIndex][arguments.colIndex] = '0' />

	<cfset findAndMarkNeighbours(arguments.grid, arguments.rowIndex - 1, arguments.colIndex) />
	<cfset findAndMarkNeighbours(arguments.grid, arguments.rowIndex + 1, arguments.colIndex) />
	<cfset findAndMarkNeighbours(arguments.grid, arguments.rowIndex, arguments.colIndex - 1) />
	<cfset findAndMarkNeighbours(arguments.grid, arguments.rowIndex, arguments.colIndex + 1) />
</cffunction>

<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var adventOfCode = CreateObject('component', 'AdventOfCode') />

	<cfset var grid = {} />
	<cfset var rowIndex = '' />
	<cfset var knotHash = '' />
	<cfset var colIndex = '' />
	<cfset var charIndex = '' />
	<cfset var char = '' />
	<cfset var bits = '' />
	<cfset var i = '' />
	<cfloop from="0" to="127" index="rowIndex">
		<cfset grid[rowIndex] = {} />
		<cfset knotHash = adventOfCode.getKnotHash(arguments.input & '-' & rowIndex) />
		<cfset colIndex = 0 />
		<cfloop from="1" to="#Len(knotHash)#" index="charIndex">
			<cfset char = Mid(knotHash, charIndex, 1) />
			<cfset bits = Right('0000' & FormatBaseN(InputBaseN(char, 16), 2), 4) />
			<cfloop from="1" to="4" index="i">
				<cfset grid[rowIndex][colIndex] = Mid(bits, i, 1) />
				<cfset colIndex++ />
			</cfloop>
		</cfloop>
	</cfloop>

	<cfset var numRegions = 0 />
	<cfloop from="0" to="127" index="rowIndex">
		<cfloop from="0" to="127" index="colIndex">
			<cfif grid[rowIndex][colIndex] eq '1'>
				<cfset numRegions++ />
				<cfset findAndMarkNeighbours(grid, rowIndex, colIndex) />
			</cfif>
		</cfloop>
	</cfloop>

	<cfreturn numRegions />
</cffunction>

<cfset testCases = [
	{
		input = 'flqrgnkx',
		expectedOutput = 1242
	},
	{
		input = Trim(FileRead(ExpandPath('14.txt'))),
		expectedOutput = 1141
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>14-2</title>
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
