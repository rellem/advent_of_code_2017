<cffunction name="solve">
	<cfargument name="input" required="true" />

	<cfset var line = '' />
	<cfset var word = '' />
	<cfset var newInput = '' >
	<cfset var newLine = '' />
	<cfset var letters = '' />
	<cfset var sortedWord = '' />

	<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
		<cfset line = Trim(line) />
		<cfset newLine = '' />
		<cfloop list="#line#" item="word" delimiters=" ">
			<!--- ListSort with an empty string as delimiter does not work as expected on Adobe ColdFusion. --->
			<cfset letters = ListToArray(word, '') />
			<cfset ArraySort(letters, 'text', 'asc') />
			<cfset sortedWord = ArrayToList(letters, '') />
			<cfset newLine = ListAppend(newLine, sortedWord, ' ') />
		</cfloop>
		<cfset newInput &= newLine & Chr(10) />
	</cfloop>

	<cfset var numValid = 0 />
	<cfset var hasDupe = false />

	<cfloop list="#newInput#" item="line" delimiters="#Chr(10)#">
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
		input = 'abcde fghij',
		expectedOutput = 1
	},
	{
		input = 'abcde xyz ecdab',
		expectedOutput = 0
	},
	{
		input = 'a ab abc abd abf abj',
		expectedOutput = 1
	},
	{
		input = 'iiii oiii ooii oooi oooo',
		expectedOutput = 1
	},
	{
		input = 'oiii ioii iioi iiio',
		expectedOutput = 0
	},
	{
		input = Trim(FileRead(ExpandPath('4.txt'))),
		expectedOutput = 119
	}
] />
<cfinclude template="test_runner_include.cfm" />
