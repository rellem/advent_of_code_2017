<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var childsByParent = {} />
	<cfset var line = '' />
	<cfset var words = '' />
	<cfset var parent = '' />
	<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
		<cfset words = ListToArray(Replace(Trim(line), ', ', ',', 'all'), Chr(32)) />
		<cfset parent = words[1] />
		<cfset childsByParent[parent] = ListToArray(words[3]) />
	</cfloop>

	<cfset var group0 = { 0 = true } />
	<cfset var foundNewGroupMember = true />
	<cfset var child = '' />
	<cfloop condition="foundNewGroupMember">
		<cfset foundNewGroupMember = false />
		<cfloop collection="#childsByParent#" item="parent">
			<cfif StructKeyExists(group0, parent)>
				<cfloop array="#childsByParent[parent]#" item="child">
					<cfif !StructKeyExists(group0, child)>
						<cfset group0[child] = true />
						<cfset foundNewGroupMember = true />
					</cfif>
				</cfloop>
			</cfif>
		</cfloop>
	</cfloop>

	<cfreturn StructCount(group0) />
</cffunction>

<cfset testCases = [
	{
		input = '0 <-> 2
1 <-> 1
2 <-> 0, 3, 4
3 <-> 2, 4
4 <-> 2, 3, 6
5 <-> 6
6 <-> 4, 5',
		expectedOutput = 6
	},
	{
		input = Trim(FileRead(ExpandPath('12.txt'))),
		expectedOutput = 288
	}
] />
<cfinclude template="test_runner_include.cfm" />
