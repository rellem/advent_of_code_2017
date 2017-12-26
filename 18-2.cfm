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
<cfinclude template="test_runner_include.cfm" />
