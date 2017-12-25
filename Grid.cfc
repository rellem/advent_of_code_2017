<cfcomponent output="false">

	<cffunction name="init" access="public" returntype="Grid" output="false">
		<cfset variables.grid = {} />

		<cfset variables.minX = '' />
		<cfset variables.maxX = '' />
		<cfset variables.minY = '' />
		<cfset variables.maxY = '' />
		<cfset variables.hasMinMax = false />

		<cfreturn this />
	</cffunction>

	<cffunction name="setValue" access="public" returntype="void" output="false">
		<cfargument name="position" type="struct" required="true" />
		<cfargument name="value" required="true" />

		<cfif !variables.hasMinMax>
			<cfset variables.minX = arguments.position.x />
			<cfset variables.maxX = arguments.position.x />
			<cfset variables.minY = arguments.position.y />
			<cfset variables.maxY = arguments.position.y />
			<cfset variables.hasMinMax = true />
		</cfif>
		<cfset variables.minX = Min(variables.minX, arguments.position.x) />
		<cfset variables.maxX = Max(variables.maxX, arguments.position.x) />
		<cfset variables.minY = Min(variables.minY, arguments.position.y) />
		<cfset variables.maxY = Max(variables.maxY, arguments.position.y) />

		<cfif !StructKeyExists(variables.grid, arguments.position.y)>
			<cfset variables.grid[arguments.position.y] = {} />
		</cfif>
		<cfset variables.grid[arguments.position.y][arguments.position.x] = arguments.value />
	</cffunction>

	<cffunction name="getValue" access="public" returntype="any" output="false">
		<cfargument name="position" type="struct" required="true" />
		<cfargument name="default" type="any" required="false" />

		<cfif hasValue(arguments.position)>
			<cfreturn variables.grid[arguments.position.y][arguments.position.x] />
		</cfif>

		<cfif StructKeyExists(arguments, 'default')>
			<cfreturn arguments.default />
		</cfif>

		<cfthrow message="Found no value for position { x: #arguments.position.x#, y: #arguments.position.y# }" />
	</cffunction>

	<cffunction name="hasValue" access="public" returntype="boolean" output="false">
		<cfargument name="position" type="struct" required="true" />

		<cfreturn StructKeyExists(variables.grid, arguments.position.y) && StructKeyExists(variables.grid[arguments.position.y], arguments.position.x) />
	</cffunction>

	<cffunction name="countValues" access="public" returntype="numeric" output="false">
		<cfargument name="value" type="any" required="true" />

		<cfset var num = 0 />
		<cfset var x = '' />
		<cfset var y = '' />
		<cfloop collection="#variables.grid#" item="y">
			<cfloop collection="#variables.grid[y]#" item="x">
				<cfif variables.grid[y][x] eq arguments.value>
					<cfset num++ />
				</cfif>
			</cfloop>
		</cfloop>

		<cfreturn num />
	</cffunction>

	<cffunction name="getMinX" access="public" returntype="numeric" output="false">
		<cfreturn variables.minX />
	</cffunction>

	<cffunction name="getMaxX" access="public" returntype="numeric" output="false">
		<cfreturn variables.maxX />
	</cffunction>

	<cffunction name="getMinY" access="public" returntype="numeric" output="false">
		<cfreturn variables.minY />
	</cffunction>

	<cffunction name="getMaxY" access="public" returntype="numeric" output="false">
		<cfreturn variables.maxY />
	</cffunction>

	<cffunction name="getSlice" access="public" returntype="Grid" output="false">
		<cfargument name="position1" type="struct" required="true" />
		<cfargument name="position2" type="struct" required="true" />

		<cfset var gridSlice = CreateObject('component', 'Grid').init() />
		<cfset var x = '' />
		<cfset var y = '' />
		<cfset var position = '' />
		<cfloop from="#Min(arguments.position1.x, arguments.position2.x)#" to="#Max(arguments.position1.x, arguments.position2.x)#" index="x">
			<cfloop from="#Min(arguments.position1.y, arguments.position2.y)#" to="#Max(arguments.position1.y, arguments.position2.y)#" index="y">
				<cfset position = { x = x, y = y } />
				<cfset gridSlice.setValue(position, getValue(position)) />
			</cfloop>
		</cfloop>

		<cfreturn gridSlice />
	</cffunction>

	<cffunction name="putSlice" access="public" returntype="void" output="false">
		<cfargument name="topLeftPosition" type="struct" required="true" />
		<cfargument name="gridSlice" type="Grid" required="true" />

		<cfset var x = '' />
		<cfset var y = '' />
		<cfset var fromSlicePosition = '' />
		<cfset var toGridPosition = '' />
		<cfloop from="#arguments.gridSlice.getMinY()#" to="#arguments.gridSlice.getMaxY()#" index="y">
			<cfloop from="#arguments.gridSlice.getMinX()#" to="#arguments.gridSlice.getMaxX()#" index="x">
				<cfset fromSlicePosition = { x = x, y = y } />
				<cfset toGridPosition = { x = arguments.topLeftPosition.x + x - arguments.gridSlice.getMinX() , y = arguments.topLeftPosition.y + y - arguments.gridSlice.getMinY() } />
				<cfset setValue(toGridPosition, arguments.gridSlice.getValue(fromSlicePosition)) />
			</cfloop>
		</cfloop>
	</cffunction>

	<cffunction name="getTransposedGrid" access="public" returntype="Grid" output="false">
		<cfset var transposedGrid = CreateObject('component', 'Grid').init() />
		<cfset var x = '' />
		<cfset var y = '' />
		<cfloop from="#getMinY()#" to="#getMaxY()#" index="y">
			<cfloop from="#getMinX()#" to="#getMaxX()#" index="x">
				<cfset transposedGrid.setValue({ x = y, y = x }, getValue({ x = x, y = y })) />
			</cfloop>
		</cfloop>

		<cfreturn transposedGrid />
	</cffunction>

	<cffunction name="getFlippedGrid" access="public" returntype="Grid" output="false">
		<cfargument name="axisToFlipAround" type="string" required="true" />

		<cfset var flippedGrid = CreateObject('component', 'Grid').init() />
		<cfset var x = '' />
		<cfset var y = '' />
		<cfset var newX = '' />
		<cfset var newY = '' />
		<cfloop from="#getMinY()#" to="#getMaxY()#" index="y">
			<cfloop from="#getMinX()#" to="#getMaxX()#" index="x">
				<cfswitch expression="#arguments.axisToFlipAround#">
					<cfcase value="y">
						<cfset newX = getMaxX() - (x - getMinX()) />
						<cfset newY = y />
					</cfcase>
					<cfcase value="x">
						<cfset newX = x />
						<cfset newY = getMaxY() - (y - getMinY()) />
					</cfcase>
					<cfdefaultcase>
						<cfthrow message="Unexpected" />
					</cfdefaultcase>
				</cfswitch>
				<cfset flippedGrid.setValue({ x = newX, y = newY }, getValue({ x = x, y = y })) />
			</cfloop>
		</cfloop>

		<cfreturn flippedGrid />
	</cffunction>

	<cffunction name="getClockwiseRotatedGrid" access="public" returntype="Grid" output="false">
		<cfreturn this.getTransposedGrid().getFlippedGrid('y') />
	</cffunction>

	<cffunction name="move" access="public" returntype="struct" output="false">
		<cfargument name="position" type="struct" required="true" />
		<cfargument name="direction" type="string" required="true" />

		<cfset var newPosition = StructCopy(arguments.position) />

		<cfswitch expression="#arguments.direction#">
			<cfcase value="UP">
				<cfset newPosition.y-- />
			</cfcase>
			<cfcase value="LEFT">
				<cfset newPosition.x-- />
			</cfcase>
			<cfcase value="DOWN">
				<cfset newPosition.y++ />
			</cfcase>
			<cfcase value="RIGHT">
				<cfset newPosition.x++ />
			</cfcase>
			<cfdefaultcase>
				<cfthrow message="Unexpected direction: #arguments.direction#" />
			</cfdefaultcase>
		</cfswitch>

		<cfreturn newPosition />
	</cffunction>

	<cffunction name="turnLeft" access="public" returntype="string" output="false">
		<cfargument name="direction" type="string" required="true" />

		<cfswitch expression="#arguments.direction#">
			<cfcase value="UP">
				<cfreturn 'LEFT' />
			</cfcase>
			<cfcase value="LEFT">
				<cfreturn 'DOWN' />
			</cfcase>
			<cfcase value="DOWN">
				<cfreturn 'RIGHT' />
			</cfcase>
			<cfcase value="RIGHT">
				<cfreturn 'UP' />
			</cfcase>
			<cfdefaultcase>
				<cfthrow message="Unexpected direction: #arguments.direction#" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="turnRight" access="public" returntype="string" output="false">
		<cfargument name="direction" type="string" required="true" />

		<cfswitch expression="#arguments.direction#">
			<cfcase value="UP">
				<cfreturn 'RIGHT' />
			</cfcase>
			<cfcase value="LEFT">
				<cfreturn 'UP' />
			</cfcase>
			<cfcase value="DOWN">
				<cfreturn 'LEFT' />
			</cfcase>
			<cfcase value="RIGHT">
				<cfreturn 'DOWN' />
			</cfcase>
			<cfdefaultcase>
				<cfthrow message="Unexpected direction: #arguments.direction#" />
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="getStruct" access="public" returntype="struct" output="false">
		<cfreturn variables.grid />
	</cffunction>

</cfcomponent>