<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var actionMap = { 'inc' = 1, 'dec' = -1 } />
	<cfset var operatorMap = {
		'<' = 'lt',
		'<=' = 'lte',
		'>=' = 'gte',
		'>' = 'gt',
		'==' = 'eq',
		'!=' = 'neq'
	} />

	<cfset var registers = {} />

	<cfset var maxValueSeen = '' />

	<cfset var line = '' />
	<cfset var words = '' />
	<cfset var r1 = '' />
	<cfset var action = '' />
	<cfset var v1 = '' />
	<cfset var r2 = '' />
	<cfset var operator = '' />
	<cfset var v2 = '' />
	<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
		<cfset words = ListToArray(Trim(line), Chr(32)) />

		<cfset r1 = words[1] />
		<cfset action = words[2] />
		<cfset v1 = words[3] />
		<cfset r2 = words[5] />
		<cfset operator = words[6] />
		<cfset v2 = words[7] />

		<cfif !StructKeyExists(registers, r1)>
			<cfset registers[r1] = 0 />
		</cfif>
		<cfif !StructKeyExists(registers, r2)>
			<cfset registers[r2] = 0 />
		</cfif>

		<cfif Evaluate('#registers[r2]# #operatorMap[operator]# #v2#')>
			<cfset registers[r1] += v1 * actionMap[action] />
			<cfif !IsNumeric(maxValueSeen) || registers[r1] gt maxValueSeen>
				<cfset maxValueSeen = registers[r1] />
			</cfif>
		</cfif>
	</cfloop>

	<cfreturn maxValueSeen />
</cffunction>

<cfset testCases = [
	{
		input = 'b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10',
		expectedOutput = 10
	},
	{
		input = Trim(FileRead(ExpandPath('8.txt'))),
		expectedOutput = 7310
	}
] />
<cfinclude template="test_runner_include.cfm" />
