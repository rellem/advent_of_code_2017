<cffunction name="reverseArray" returntype="array" output="false">
	<cfargument name="array" type="array" required="true" />

	<cfset var reversedArray = [] />
	<cfset var i = '' />
	<cfloop from="#ArrayLen(arguments.array)#" to="1" step="-1" index="i">
		<cfset ArrayAppend(reversedArray, arguments.array[i]) />
	</cfloop>

	<cfreturn reversedArray />
</cffunction>

<cffunction name="arrayOfNumbersToHexString" returntype="string" output="false">
	<cfargument name="arrayOfNumbers" type="array" required="true" />

	<cfset var hexString = '' />
	<cfset var number = '' />
	<cfset var hs = '' />
	<cfloop array="#arguments.arrayOfNumbers#" item="number">
		<cfset hs = FormatBaseN(number, 16) />
		<cfif Len(hs) eq 1>
			<cfset hs = '0' & hs />
		</cfif>
		<cfset hexString &= hs />
	</cfloop>

	<cfreturn LCase(hexString) />
</cffunction>

<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />
	<cfargument name="numberOfNumbers" default="256" />
	<cfargument name="numberOfRounds" default="64" />
	<cfargument name="numberOfBlocks" default="16" />

	<cfset var numbers = [] />
	<cfset var i = '' />
	<cfloop from="0" to="#arguments.numberOfNumbers - 1#" index="i">
		<cfset ArrayAppend(numbers, i) />
	</cfloop>

	<cfset var lengths = [] />
	<cfset var inputIndex = '' />
	<cfloop from="1" to="#Len(input)#" index="inputIndex">
		<cfset ArrayAppend(lengths, Asc(Mid(arguments.input, inputIndex, 1))) />
	</cfloop>
	<cfset ArrayAppend(lengths, ListToArray('17,31,73,47,23'), true) />

	<cfset var pos = 0 />
	<cfset var skipSize = 0 />
	<cfset var roundIndex = '' />
	<cfset var length = '' />
	<cfset var offset = '' />
	<cfset var indexFromStart = '' />
	<cfset var indexFromEnd = '' />
	<cfloop from="1" to="#arguments.numberOfRounds#" index="roundIndex">
		<cfloop array="#lengths#" item="length">
			<cfloop from="0" to="#Floor(length / 2) - 1#" index="offset">
				<cfset indexFromStart = (pos + offset) % arguments.numberOfNumbers + 1 />
				<cfset indexFromEnd = (pos + length - 1 - offset) % arguments.numberOfNumbers + 1 />
				<cfset ArraySwap(numbers, indexFromStart, indexFromEnd) />
			</cfloop>

			<cfset pos = (pos + length + skipSize) % arguments.numberOfNumbers />
			<cfset skipSize++ />
		</cfloop>
	</cfloop>

	<cfset var numbersPerBlock = arguments.numberOfNumbers / arguments.numberOfBlocks />
	<cfset var denseHash = [] />
	<cfset var blockIndex = '' />
	<cfset var numberIndex = '' />
	<cfset var blockValue = '' />
	<cfset var number = '' />
	<cfloop from="1" to="#arguments.numberOfBlocks#" index="blockIndex">
		<cfset blockValue = 0 />
		<cfloop from="1" to="#numbersPerBlock#" index="numberIndex">
			<cfset number = numbers[(blockIndex - 1) * numbersPerBlock + numberIndex] />
			<cfset blockValue = BitXOR(blockValue, number) />
		</cfloop>
		<cfset ArrayAppend(denseHash, blockValue) />
	</cfloop>

	<cfreturn arrayOfNumbersToHexString(denseHash) />
</cffunction>

<cfset testCases = [
	{
		input = '',
		expectedOutput = 'a2582a3a0e66e6e86e3812dcb672a272'
	},
	{
		input = 'AoC 2017',
		expectedOutput = '33efeb34ea91902bb2f59c9920caa6cd'
	},
	{
		input = '1,2,3',
		expectedOutput = '3efbe78a8d82f29979031a4aa0b16a9d'
	},
	{
		input = '1,2,4',
		expectedOutput = '63960835bcdc130f0b66d7ff4f6a5a8e'
	},
	{
		input = Trim(FileRead(ExpandPath('10.txt'))),
		expectedOutput = '0c2f794b2eb555f7830766bf8fb65a16'
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>10-2</title>
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
