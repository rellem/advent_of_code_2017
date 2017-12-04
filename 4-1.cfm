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

<cfoutput>#solve(FileRead('4.txt'))#</cfoutput>
