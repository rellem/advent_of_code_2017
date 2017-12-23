<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var threadNames = [] />
	<cfset var threadName = '' />

	<cfset request.queueFromProgram0ToProgram1 = CreateObject('component', 'Queue').init() />
	<cfset request.queueFromProgram1ToProgram0 = CreateObject('component', 'Queue').init() />

	<cfset threadName = 'program0-' & CreateUUID() />
	<cfset ArrayAppend(threadNames, threadName) />
	<cfthread action="run" name="#threadName#" input="#arguments.input#">
		<cfset CreateObject('component', 'Day18Part2Program').runAndReturnNumSentValues(
			input = attributes.input,
			outQueue = request.queueFromProgram0ToProgram1,
			inQueue = request.queueFromProgram1ToProgram0,
			initialRegisterValues = { p = 0 }
		) />
	</cfthread>

	<cfset threadName = 'program1-' & CreateUUID() />
	<cfset ArrayAppend(threadNames, threadName) />
	<cfthread action="run" name="#threadName#" input="#arguments.input#">
		<cfset request.numSentValues = CreateObject('component', 'Day18Part2Program').runAndReturnNumSentValues(
			input = attributes.input,
			outQueue = request.queueFromProgram1ToProgram0,
			inQueue = request.queueFromProgram0ToProgram1,
			initialRegisterValues = { p = 1 }
		) />
	</cfthread>

	<cfthread action="join" name="#ArrayToList(threadNames)#" />
	<cfloop array="#threadNames#" item="threadName">
		<cfif cfthread[threadName].status neq 'COMPLETED'>
			<cfdump var="#cfthread[threadName]#" abort="true" />
		</cfif>
	</cfloop>

	<cfreturn request.numSentValues />
</cffunction>

<cfset testCases = [
	{
		input = 'snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d',
		expectedOutput = 3
	},
	{
		input = Trim(FileRead(ExpandPath('18.txt'))),
		expectedOutput = 5969
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>18-2</title>
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
