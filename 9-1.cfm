<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var score = 0 />
	<cfset var level = 1 />

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

	<cfreturn score />
</cffunction>

<cfset testCases = [
	{
		input = '{}',
		expectedOutput = 1
	},
	{
		input = '{{{}}}',
		expectedOutput = 6
	},
	{
		input = '{{},{}}',
		expectedOutput = 5
	},
	{
		input = '{{{},{},{{}}}}',
		expectedOutput = 16
	},
	{
		input = '{<a>,<a>,<a>,<a>}',
		expectedOutput = 1
	},
	{
		input = '{{<ab>},{<ab>},{<ab>},{<ab>}}',
		expectedOutput = 9
	},
	{
		input = '{{<!!>},{<!!>},{<!!>},{<!!>}}',
		expectedOutput = 9
	},
	{
		input = '{{<a!>},{<a!>},{<a!>},{<ab>}}',
		expectedOutput = 3
	},
	{
		input = Trim(FileRead(ExpandPath('9.txt'))),
		expectedOutput = 23588
	}
] />
<cfinclude template="test_runner_include.cfm" />
