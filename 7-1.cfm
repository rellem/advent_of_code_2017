<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var programNamesSeenOnRightSide = {} />

	<cfset var line = '' />
	<cfset var words = '' />
	<cfset var programNamesOnRightSide = '' />
	<cfset var programName = '' />
	<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
		<cfset line = Trim(line) />
		<cfset words = ListToArray(line, Chr(32)) />

		<cfif line contains '->'>
			<cfset programNamesOnRightSide = Replace(Trim(ListGetAt(line, 2, '>')), ' ', '', 'all') />
			<cfloop list="#programNamesOnRightSide#" item="programName">
				<cfset programNamesSeenOnRightSide[programName] = 1 />
			</cfloop>
		</cfif>
	</cfloop>

	<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
		<cfset line = Trim(line) />
		<cfset words = ListToArray(line, Chr(32)) />

		<cfif line contains '->'>
			<cfset programName = ListFirst(line, ' ') />
			<cfif !StructKeyExists(programNamesSeenOnRightSide, programName)>
				<cfreturn programName />
			</cfif>
		</cfif>
	</cfloop>

	<cfthrow message="Did not find root program" />
</cffunction>

<cfset testCases = [
	{
		input = 'pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)',
		expectedOutput = 'tknk'
	},
	{
		input = Trim(FileRead(ExpandPath('7.txt'))),
		expectedOutput = 'ahnofa'
	}
] />
<cfinclude template="test_runner_include.cfm" />
