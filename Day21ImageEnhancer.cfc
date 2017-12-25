<cfcomponent output="false">

	<cffunction name="getStartingGrid" access="public" returntype="Grid" output="false">
		<cfset var grid = CreateObject('component', 'Grid').init() />
		<cfset grid.setValue({ x = 0, y = 0 }, '.') />
		<cfset grid.setValue({ x = 1, y = 0 }, '##') />
		<cfset grid.setValue({ x = 2, y = 0 }, '.') />
		<cfset grid.setValue({ x = 0, y = 1 }, '.') />
		<cfset grid.setValue({ x = 1, y = 1 }, '.') />
		<cfset grid.setValue({ x = 2, y = 1 }, '##') />
		<cfset grid.setValue({ x = 0, y = 2 }, '##') />
		<cfset grid.setValue({ x = 1, y = 2 }, '##') />
		<cfset grid.setValue({ x = 2, y = 2 }, '##') />
		<cfreturn grid />
	</cffunction>

	<cffunction name="getRulesFromInput" access="public" returntype="struct" output="false">
		<cfargument name="input" type="string" required="true" />

		<cfset var rules = {} />

		<cfset var line = '' />
		<cfset var words = '' />
		<cfset var patterns = '' />
		<cfset var pattern = '' />
		<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
			<cfset words = ListToArray(Trim(line), Chr(32)) />
			<cfset patterns = getVariantsOfPattern(words[1]) />
			<cfloop array="#patterns#" item="pattern">
				<cfset rules[pattern] = words[3] />
			</cfloop>
		</cfloop>

		<cfreturn rules />
	</cffunction>

	<cffunction name="enhance" access="public" returntype="Grid" output="false">
		<cfargument name="inputGrid" type="Grid" required="true" />
		<cfargument name="rules" type="struct" required="true" />
		<cfargument name="iterations" type="numeric" required="true" />

		<cfset var grid = arguments.inputGrid />
		<cfset var newGrid = '' />
		<cfset var iteration = '' />
		<cfset var gridSize = '' />
		<cfset var divSize = '' />
		<cfset var newDivSize = '' />
		<cfset var divIndexRow = '' />
		<cfset var divIndexCol = '' />
		<cfset var topLeftPosition = '' />
		<cfset var bottomRightPosition = '' />
		<cfset var gridSlice = '' />
		<cfset var newGridSlice = '' />
		<cfset var pattern = '' />
		<cfset var newTopLeftPosition = '' />
		<cfloop from="1" to="#arguments.iterations#" index="iteration">
			<cfset gridSize = grid.getMaxX() - grid.getMinX() + 1 />

			<cfif gridSize % 2 eq 0>
				<cfset divSize = 2 />
				<cfset newDivSize = 3 />
			<cfelseif gridSize % 3 eq 0>
				<cfset divSize = 3 />
				<cfset newDivSize = 4 />
			<cfelse>
				<cfthrow message="Unexpected grid size" />
			</cfif>

			<cfset newGrid = CreateObject('component', 'Grid').init() />

			<cfloop from="1" to="#gridSize / divSize#" index="divIndexRow">
				<cfloop from="1" to="#gridSize / divSize#" index="divIndexCol">
					<cfset topLeftPosition = { x = (divIndexCol-1) * divSize, y = (divIndexRow-1) * divSize } />
					<cfset bottomRightPosition = { x = divIndexCol * divSize - 1, y = divIndexRow * divSize - 1 } />
					<cfset gridSlice = grid.getSlice(topLeftPosition, bottomRightPosition) />
					<cfset pattern = gridToPattern(gridSlice) />
					<cfif StructKeyExists(arguments.rules, pattern)>
						<cfset newGridSlice = patternToGrid(arguments.rules[pattern]) />
						<cfset newTopLeftPosition = { x = (divIndexCol - 1) * newDivSize, y = (divIndexRow - 1) * newDivSize } />
						<cfset newGrid.putSlice(newTopLeftPosition, newGridSlice) />
					<cfelse>
						<cfthrow message="Found no matching rule for pattern: '#rule#'" />
					</cfif>
				</cfloop>
			</cfloop>
			<cfset grid = newGrid />
		</cfloop>

		<cfreturn grid />
	</cffunction>

	<cffunction name="patternToGrid" access="private" returntype="Grid" output="false">
		<cfargument name="pattern" type="string" required="true" />

		<cfset var grid = CreateObject('component', 'Grid').init() />

		<cfset var line = '' />
		<cfset var lineIndex = '' />
		<cfset var char = '' />
		<cfset var charIndex = '' />
		<cfloop list="#arguments.pattern#" item="line" index="lineIndex" delimiters="/">
			<cfloop array="#ListToArray(line, '')#" item="char" index="charIndex">
				<cfset grid.setValue({ x = charIndex - 1, y = lineIndex - 1 }, char) />
			</cfloop>
		</cfloop>

		<cfreturn grid />
	</cffunction>

	<cffunction name="gridToPattern" access="private" returntype="string" output="false">
		<cfargument name="grid" type="Grid" required="true" />

		<cfset var pattern = '' />
		<cfset var line = '' />
		<cfset var x = '' />
		<cfset var y = '' />
		<cfloop from="#arguments.grid.getMinY()#" to="#arguments.grid.getMaxY()#" index="y">
			<cfset line = '' />
			<cfloop from="#arguments.grid.getMinX()#" to="#arguments.grid.getMaxX()#" index="x">
				<cfset line &= grid.getValue({ x = x, y = y }) />
			</cfloop>
			<cfset pattern = ListAppend(pattern, line, '/') />
		</cfloop>

		<cfreturn pattern />
	</cffunction>

	<cffunction name="getVariantsOfPattern" access="private" returntype="array" output="false">
		<cfargument name="pattern" type="string" required="true" />

		<cfset var grid = patternToGrid(arguments.pattern) />

		<cfset var variants = [] />

		<cfset ArrayAppend(variants, gridToPattern(grid)) />
		<cfset ArrayAppend(variants, gridToPattern(grid.getFlippedGrid('x'))) />
		<cfset ArrayAppend(variants, gridToPattern(grid.getFlippedGrid('y'))) />

		<cfset ArrayAppend(variants, gridToPattern(grid.getClockwiseRotatedGrid())) />
		<cfset ArrayAppend(variants, gridToPattern(grid.getClockwiseRotatedGrid().getClockwiseRotatedGrid())) />
		<cfset ArrayAppend(variants, gridToPattern(grid.getClockwiseRotatedGrid().getClockwiseRotatedGrid().getClockwiseRotatedGrid())) />

		<cfset ArrayAppend(variants, gridToPattern(grid.getFlippedGrid('x').getClockwiseRotatedGrid())) />
		<cfset ArrayAppend(variants, gridToPattern(grid.getFlippedGrid('x').getClockwiseRotatedGrid().getClockwiseRotatedGrid())) />
		<cfset ArrayAppend(variants, gridToPattern(grid.getFlippedGrid('x').getClockwiseRotatedGrid().getClockwiseRotatedGrid().getClockwiseRotatedGrid())) />

		<cfreturn variants />
	</cffunction>

</cfcomponent>