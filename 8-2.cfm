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

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>8-2</title>
	<style type="text/css">
		table { border-collapse: collapse; }
		table, th, td { border: 1px solid grey; }
		th { text-align: left; padding: 2px 8px 2px 8px; }
		td { padding: 2px 8px 2px 8px; }
		span.correct { color: ##00ff00 }
		span.incorrect { color: ##ff0000 }
	</style>
</head>
<body>
<table>
	<thead>
		<tr>
			<th>Input</th>
			<th>Expected output</th>
			<th>Output</th>
			<th>Status</th>
			<th>Time taken</th>
		</tr>
	</thead>
	<tbody>
		<cfloop array="#testCases#" item="testCase">
			<cfif Len(testCase.input) eq 0>
				<cfcontinue />
			</cfif>
			<tr>
				<td>
					<pre>#EncodeForHTML(Left(testCase.input, 100))#</pre>
				</td>
				<td>
					<cfif StructKeyExists(testCase, 'expectedOutput')>
						#EncodeForHTML(testCase.expectedOutput)#
					</cfif>
				</td>
				<td>
					<cfset startTickCount = GetTickCount() />
					<cfset actualOutput = solve(testCase.input) />
					<cfset tickCountTaken = GetTickCount() - startTickCount />
					#EncodeForHTML(actualOutput)#
				</td>
				<td>
					<cfif StructKeyExists(testCase, 'expectedOutput')>
						<cfif actualOutput eq testCase.expectedOutput>
							<span class="correct">Correct</span>
						<cfelse>
							<span class="incorrect">Incorrect</span>
						</cfif>
					</cfif>
				</td>
				<td>#tickCountTaken# ms</td>
			</tr>
		</cfloop>
	</tbody>
</table>
</body>
</html>
</cfoutput>
