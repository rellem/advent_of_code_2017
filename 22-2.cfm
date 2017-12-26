<cfsetting requesttimeout="600" />

<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var grid = CreateObject('component', 'Grid').init() />
	<cfset var line = '' />
	<cfset var lineIndex = '' />
	<cfset var char = '' />
	<cfset var charIndex = '' />
	<cfset var position = '' />
	<cfloop list="#arguments.input#" item="line" index="lineIndex" delimiters="#Chr(10)#">
		<cfloop array="#ListToArray(Trim(line), '')#" item="char" index="charIndex">
			<cfset position = { x = charIndex, y = lineIndex } />
			<cfset grid.setValue(position, char) />
		</cfloop>
	</cfloop>

	<cfset var infections = 0 />
	<cfset var center = (Len(line) - 1) / 2 + 1 />
	<cfset var currentPosition = { x = center, y = center } />
	<cfset var currentDirection = 'UP' />
	<cfset var burst = '' />
	<cfloop from="1" to="10000000" index="burst">
		<cfswitch expression="#grid.getValue(currentPosition, '.')#">
			<cfcase value="##">
				<cfset currentDirection = grid.turnRight(currentDirection) />
				<cfset grid.setValue(currentPosition, 'F') />
			</cfcase>
			<cfcase value="F">
				<cfset currentDirection = grid.turnLeft(grid.turnLeft(currentDirection)) />
				<cfset grid.setValue(currentPosition, '.') />
			</cfcase>
			<cfcase value="W">
				<cfset grid.setValue(currentPosition, '##') />
				<cfset infections++ />
			</cfcase>
			<cfcase value=".">
				<cfset currentDirection = grid.turnLeft(currentDirection) />
				<cfset grid.setValue(currentPosition, 'W') />
			</cfcase>
			<cfdefaultcase>
				<cfthrow message="Unexpected" />
			</cfdefaultcase>
		</cfswitch>
		<cfset currentPosition = grid.move(currentPosition, currentDirection) />
	</cfloop>

	<cfreturn infections />
</cffunction>

<cfset testCases = [
	{
		input = '..##
##..
...',
		expectedOutput = 2511944
	},
	{
		input = Trim(FileRead(ExpandPath('22.txt'))),
		expectedOutput = 2512059
	}
] />
<cfinclude template="test_runner_include.cfm" />
