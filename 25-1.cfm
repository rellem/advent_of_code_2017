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
<cfinclude template="test_runner_include.cfm" />
