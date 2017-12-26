<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var lines = ListToArray(Replace(Replace(arguments.input, ':', '', 'all'), '.', '', 'all'), Chr(10)) />
	<cfset var beginState = ListGetAt(Trim(lines[1]), 4, ' ') />
	<cfset var numDiag = ListGetAt(Trim(lines[2]), 6, ' ') />
	<cfset var line = '' />
	<cfset var lineIndex = '' />
	<cfset var words = '' />
	<cfset var stateRules = {} />
	<cfloop array="#lines#" item="line" index="lineIndex">
		<cfset words = ListToArray(Trim(line), Chr(32)) />
		<cfif words[1] eq 'In' && words[2] eq 'state'>
			<cfset stateRules[words[3]] = {
				0 = {
					valueToWrite = ListGetAt(Trim(lines[lineIndex + 2]), 5, ' '),
					move = ListGetAt(Trim(lines[lineIndex + 3]), 7, ' '),
					nextState = ListGetAt(Trim(lines[lineIndex + 4]), 5, ' ')
				},
				1 = {
					valueToWrite = ListGetAt(Trim(lines[lineIndex + 6]), 5, ' '),
					move = ListGetAt(Trim(lines[lineIndex + 7]), 7, ' '),
					nextState = ListGetAt(Trim(lines[lineIndex + 8]), 5, ' ')
				}
			} />
		</cfif>
	</cfloop>

	<cfset var tape = {} />
	<cfset var tapePos = 0 />
	<cfset var currentState = beginState />
	<cfset var diagIndex = '' />
	<cfset var currentValue = '' />
	<cfset var currentRule = '' />
	<cfloop from="1" to="#numDiag#" index="diagIndex">
		<cfset currentValue = StructKeyExists(tape, tapePos) ? tape[tapePos] : 0 />
		<cfset currentRule = stateRules[currentState][currentValue] />
		<cfset tape[tapePos] = currentRule.valueToWrite />
		<cfset currentState = currentRule.nextState />
		<cfset tapePos += currentRule.move eq 'right' ? 1 : -1 />
	</cfloop>

	<cfset var checksum = 0 />
	<cfset var tapeIndex = '' />
	<cfloop collection="#tape#" item="tapeIndex">
		<cfif tape[tapeIndex] eq 1>
			<cfset checksum++ />
		</cfif>
	</cfloop>

	<cfreturn checksum />
</cffunction>

<cfset testCases = [
	{
		input = 'Begin in state A.
Perform a diagnostic checksum after 6 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state B.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.',
		expectedOutput = 3
	},
	{
		input = Trim(FileRead(ExpandPath('25.txt'))),
		expectedOutput = 2474
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>25-1</title>
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
