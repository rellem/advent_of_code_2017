<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var score = 0 />
	<cfset var level = 1 />
	<cfset var garbageCount = 0 />

	<cfset var inGarbage = false />
	<cfset var charIndex = 1 />
	<cfset var char = '' />
	<cfloop condition="charIndex lte Len(arguments.input)">
		<cfset char = Mid(arguments.input, charIndex, 1) />
		<cfif inGarbage>
			<cfif char eq '>'>
				<cfset inGarbage = false />
			<cfelseif char eq '!'>
				<cfset charIndex++ />
			<cfelse>
				<cfset garbageCount++ />
			</cfif>
		<cfelseif char eq '<'>
			<cfset inGarbage = true />
		<cfelseif char eq '{'>
			<cfset score += level />
			<cfset level++ />
		<cfelseif char eq '}'>
			<cfset level-- />
		<cfelseif char eq ','>
		<cfelse>
			<cfthrow message="Unexpected char: #char#" />
		</cfif>
		<cfset charIndex++ />
	</cfloop>

	<cfreturn garbageCount />
</cffunction>

<cfset testCases = [
	{
		input = '<>',
		expectedOutput = 0
	},
	{
		input = '<random characters>',
		expectedOutput = 17
	},
	{
		input = '<<<<>',
		expectedOutput = 3
	},
	{
		input = '<{!>}>',
		expectedOutput = 2
	},
	{
		input = '<!!>',
		expectedOutput = 0
	},
	{
		input = '<!!!>>',
		expectedOutput = 0
	},
	{
		input = '<{o"i!a,<{i<a>',
		expectedOutput = 10
	},
	{
		input = Trim(FileRead(ExpandPath('9.txt'))),
		expectedOutput = 10045
	}
] />
<cfinclude template="test_runner_include.cfm" />
