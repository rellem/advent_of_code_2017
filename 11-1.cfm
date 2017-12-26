<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var x = 0 />
	<cfset var y = 0 />
	<cfset var direction = '' />
	<cfset var distanceFromStart = 0 />

	<cfloop list="#arguments.input#" item="direction">
		<cfif direction eq 'ne'>
			<cfset x += 0.5 />
			<cfset y += 0.5 />
		<cfelseif direction eq 'n'>
			<cfset x += 0 />
			<cfset y += 1 />
		<cfelseif direction eq 'nw'>
			<cfset x -= 0.5 />
			<cfset y += 0.5 />
		<cfelseif direction eq 'sw'>
			<cfset x -= 0.5 />
			<cfset y -= 0.5 />
		<cfelseif direction eq 's'>
			<cfset x += 0 />
			<cfset y -= 1 />
		<cfelseif direction eq 'se'>
			<cfset x += 0.5 />
			<cfset y -= 0.5 />
		<cfelse>
			<cfthrow message="Unexpected direction: #direction#" />
		</cfif>
		<cfif Abs(x) gt Abs(y)>
			<cfset distanceFromStart = Abs(x) * 2 />
		<cfelse>
			<cfset distanceFromStart = Abs(x) + Abs(y) />
		</cfif>
	</cfloop>

	<cfreturn distanceFromStart />
</cffunction>

<cfset testCases = [
	{
		input = 'ne,ne,ne',
		expectedOutput = 3
	},
	{
		input = 'ne,ne,sw,sw',
		expectedOutput = 0
	},
	{
		input = 'ne,ne,s,s',
		expectedOutput = 2
	},
	{
		input = 'se,sw,se,sw,sw',
		expectedOutput = 3
	},
	{
		input = 'ne,se',
		expectedOutput = 2
	},
	{
		input = Trim(FileRead(ExpandPath('11.txt'))),
		expectedOutput = 707
	}
] />
<cfinclude template="test_runner_include.cfm" />
