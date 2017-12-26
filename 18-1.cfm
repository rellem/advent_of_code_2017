<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfreturn CreateObject('component', 'Day18Part1Program').runAndReturnFirstRecoveredFrequency(input = arguments.input) />
</cffunction>

<cfset testCases = [
	{
		input = 'set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2',
		expectedOutput = 4
	},
	{
		input = Trim(FileRead(ExpandPath('18.txt'))),
		expectedOutput = 1187
	}
] />
<cfinclude template="test_runner_include.cfm" />
