<cffunction name="getGridValue" returntype="numeric">
	<cfargument name="grid" required="true" />
	<cfargument name="x" required="true" />
	<cfargument name="y" required="true" />

	<cfif StructKeyExists(arguments.grid, arguments.x) && StructKeyExists(arguments.grid[arguments.x], arguments.y)>
		<cfreturn arguments.grid[arguments.x][arguments.y] />
	<cfelse>
		<cfreturn 0 />
	</cfif>
</cffunction>

<cffunction name="solve" returntype="numeric">
	<cfargument name="input" required="true" />

	<cfset var x = 0 />
	<cfset var y = 0 />
	<cfset var direction = 'E' />

	<cfset var minX = 0 />
	<cfset var maxX = 0 />
	<cfset var minY = 0 />
	<cfset var maxY = 0 />

	<cfset var grid = {} />
	<cfset grid[0][0] = 1 />

	<cfset var i = '' />
	<cfloop from="1" to="1000" index="i">
		<cfif direction eq 'E'>
			<cfset x++ />
			<cfif x gt maxX>
				<cfset direction = 'N' />
				<cfset maxX = x />
			</cfif>
		<cfelseif direction eq 'N'>
			<cfset y++ />
			<cfif y gt maxY>
				<cfset direction = 'W' />
				<cfset maxY = y />
			</cfif>
		<cfelseif direction eq 'W'>
			<cfset x-- />
			<cfif x lt minX>
				<cfset direction = 'S' />
				<cfset minX = x />
			</cfif>
		<cfelseif direction eq 'S'>
			<cfset y-- />
			<cfif y lt minY>
				<cfset direction = 'E' />
				<cfset minY = y />
			</cfif>
		<cfelse>
			<cfthrow type="AssertionFailure" message="Unexpected direction" />
		</cfif>

		<cfset grid[x][y] = getGridValue(grid, x+1, y) + getGridValue(grid, x+1, y+1) + getGridValue(grid, x, y+1) + getGridValue(grid, x-1, y+1) + getGridValue(grid, x-1, y) + getGridValue(grid, x-1, y-1) + getGridValue(grid, x, y-1) + getGridValue(grid, x+1, y-1) />

		<cfif grid[x][y] gt arguments.input>
			<cfreturn grid[x][y] />
		</cfif>
	</cfloop>

	<cfthrow message="error" />
</cffunction>

<cfset testCases = [
	{
		input = '1',
		expectedOutput = 2
	},
	{
		input = '59',
		expectedOutput = 122
	},
	{
		input = '133',
		expectedOutput = 142
	},
	{
		input = '351',
		expectedOutput = 362
	},
	{
		input = Trim(FileRead(ExpandPath('3.txt'))),
		expectedOutput = 330785
	}
] />
<cfinclude template="test_runner_include.cfm" />
