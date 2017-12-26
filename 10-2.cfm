<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var adventOfCode = CreateObject('component', 'AdventOfCode') />

	<cfreturn adventOfCode.getKnotHash(arguments.input) />
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
<cfinclude template="test_runner_include.cfm" />
