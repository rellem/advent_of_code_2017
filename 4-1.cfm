<cffunction name="solve">
	<cfargument name="input" required="true" />

	<cfset var numValid = 0 />
	<cfset var line = '' />
	<cfset var word = '' />
	<cfset var hasDupe = false />

	<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
		<cfset line = Trim(line) />
		<cfset hasDupe = false />
		<cfloop list="#line#" item="word" delimiters=" ">
			<cfif ListValueCount(line, word, ' ') gte 2>
				<cfset hasDupe = true />
				<cfbreak />
			</cfif>
		</cfloop>
		<cfif !hasDupe>
			<cfset numValid++ />
		</cfif>
	</cfloop>

	<cfreturn numValid />
</cffunction>

<cfset testCases = [
	{
		input = 'aa bb cc dd ee',
		expectedOutput = 1
	},
	{
		input = 'aa bb cc dd aa',
		expectedOutput = 0
	},
	{
		input = 'aa bb cc dd aaa',
		expectedOutput = 1
	},
	{
		input = Trim(FileRead(ExpandPath('4.txt'))),
		expectedOutput = 325
	}
] />
<cfinclude template="test_runner_include.cfm" />
