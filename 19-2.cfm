<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var grid = CreateObject('component', 'Grid').init() />

	<cfset var lines = ListToArray(arguments.input, Chr(10)) />
	<cfset var line = '' />
	<cfset var lineIndex = '' />
	<cfset var char = '' />
	<cfset var charIndex = '' />
	<cfset var position = '' />
	<cfloop array="#lines#" item="line" index="lineIndex">
		<cfloop array="#ListToArray(line, '')#" item="char" index="charIndex">
			<cfset position = { x = charIndex, y = lineIndex } />
			<cfset grid.setValue(position, Trim(char)) />
		</cfloop>
	</cfloop>

	<cfset var foundStart = false />
	<cfset var x = '' />
	<cfloop from="1" to="#Len(lines[1])#" index="x">
		<cfset position = { x = x, y = 1 } />
		<cfif grid.getValue(position) eq '|'>
			<cfset foundStart = true />
			<cfbreak />
		</cfif>
	</cfloop>
	<cfif !foundStart>
		<cfthrow message="Did not find the start position" />
	</cfif>

	<cfset var numMoves = 0 />
	<cfset var currentPosition = { x = x, y = 1 } />
	<cfset var nextPosition = '' />
	<cfset var currentDirection = 'DOWN' />
	<cfset var nextDirection = '' />
	<cfset var foundNext = '' />
	<cfloop condition="true">
		<cfset numMoves++ />

		<cfset foundNext = false />
		<cfloop array="#[ currentDirection, grid.turnLeft(currentDirection), grid.turnRight(currentDirection) ]#" item="nextDirection">
			<cfset nextPosition = grid.move(currentPosition, nextDirection) />
			<cfif Len(grid.getValue(nextPosition, '')) gt 0>
				<cfset foundNext = true />
				<cfbreak />
			</cfif>
		</cfloop>

		<cfif !foundNext>
			<cfbreak />
		</cfif>

		<cfset currentPosition = nextPosition />
		<cfset currentDirection = nextDirection />
	</cfloop>

	<cfreturn numMoves />
</cffunction>

<cfset testCases = [
	{
		input = '     |
     |  +--+
     A  |  C
 F---|----E|--+
     |  |  |  D
     +B-+  +--+
',
		expectedOutput = 38
	},
	{
		input = FileRead(ExpandPath('19.txt')),
		expectedOutput = 16162
	}
] />
<cfinclude template="test_runner_include.cfm" />
