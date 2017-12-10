<cffunction name="getPrograms" returntype="struct" output="false">
	<cfargument name="input" required="true" />

	<cfset var programByName = {} />

	<cfset var line = '' />
	<cfset var match = '' />
	<cfset var name = '' />
	<cfset var weight = '' />
	<cfset var heldNames = '' />
	<cfset var program = '' />
	<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
		<cfset line = Trim(line) />
		<cfset match = REFind('^([a-z]+) \((\d+)\)(?: -> (.+))?$', line, 1, true) />
		<cfset name = Mid(line, match.pos[2], match.len[2]) />
		<cfset weight = Mid(line, match.pos[3], match.len[3]) />
		<cfif match.len[4] gt 0>
			<cfset heldNames = ListToArray(Replace(Mid(line, match.pos[4], match.len[4]), ' ', '', 'all')) />
		<cfelse>
			<cfset heldNames = [] />
		</cfif>
		<cfset program = { name = name, weight = weight, heldNames = heldNames } />
		<cfset programByName[name] = program />
	</cfloop>

	<cfreturn programByName />
</cffunction>

<cffunction name="getRootName" returntype="string" output="false">
	<cfargument name="programByName" type="struct" required="true" />

	<cfset var allHeldNames = {} />
	<cfset var name = '' />
	<cfset var heldName = '' />
	<cfloop collection="#arguments.programByName#" item="name">
		<cfloop array="#arguments.programByName[name].heldNames#" item="heldName">
			<cfset allHeldNames[heldName] = 1 />
		</cfloop>
	</cfloop>
	<cfloop collection="#arguments.programByName#" item="name">
		<cfif !StructKeyExists(allHeldNames, name)>
			<cfreturn name />
		</cfif>
	</cfloop>
	<cfthrow message="Unexpected" />
</cffunction>

<cffunction name="getTotalWeightAndFixedWeight" returntype="struct" output="false">
	<cfargument name="name" type="string" required="true" />
	<cfargument name="programByName" type="struct" required="true" />

	<cfset var program = arguments.programByName[name] />

	<cfset var namesByTotalWeight = {} />
	<cfset var currentData = { totalWeight = program.weight } />
	<cfset var heldName = '' />
	<cfset var childData = '' />
	<cfloop array="#program.heldNames#" item="heldName">
		<cfset childData = getTotalWeightAndFixedWeight(heldName, arguments.programByName) />

		<cfset currentData.totalWeight += childData.totalWeight />
		<cfif StructKeyExists(childData, 'fixedWeight')>
			<cfset currentData.fixedWeight = childData.fixedWeight />
		</cfif>

		<cfif !StructKeyExists(namesByTotalWeight, childData.totalWeight)>
			<cfset namesByTotalWeight[childData.totalWeight] = [] />
		</cfif>
		<cfset ArrayAppend(namesByTotalWeight[childData.totalWeight], heldName) />
	</cfloop>

	<cfset var correctTotalWeight = '' />
	<cfset var incorrectTotalWeight = '' />
	<cfset var totalWeight = '' />
	<cfset var nameWithIncorrectWeight = '' />
	<cfif !StructKeyExists(currentData, 'fixedWeight')>
		<cfif StructCount(namesByTotalWeight) eq 2>
			<cfset correctTotalWeight = '' />
			<cfset incorrectTotalWeight = '' />
			<cfloop collection="#namesByTotalWeight#" item="totalWeight">
				<cfif ArrayLen(namesByTotalWeight[totalWeight]) eq 1>
					<cfset incorrectTotalWeight = totalWeight />
				<cfelse>
					<cfset correctTotalWeight = totalWeight />
				</cfif>
			</cfloop>
			<cfset nameWithIncorrectWeight = namesByTotalWeight[incorrectTotalWeight][1] />
			<cfset currentData.fixedWeight = programByName[nameWithIncorrectWeight].weight + correctTotalWeight - incorrectTotalWeight />
		<cfelseif StructCount(namesByTotalWeight) gt 2>
			<cfdump var="#namesByTotalWeight#" abort="true" />
		</cfif>
	</cfif>

	<cfreturn currentData />
</cffunction>

<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var programByName = getPrograms(arguments.input) />

	<cfset var rootName = getRootName(programByName) />

	<cfreturn getTotalWeightAndFixedWeight(rootName, programByName).fixedWeight />
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
		expectedOutput = 60
	},
	{
		input = Trim(FileRead(ExpandPath('7.txt'))),
		expectedOutput = 802
	}
] />

<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>7-2</title>
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
			<tr>
				<td>
					<cfset maxCharsToDisplay = 300 />
					<pre>#EncodeForHTML(Left(testCase.input, maxCharsToDisplay))#<cfif Len(testCase.input) gt maxCharsToDisplay>&hellip;</cfif></pre>
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
