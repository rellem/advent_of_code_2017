<cfcomponent output="false">

	<cffunction name="init" access="public" returntype="Grid" output="false">
		<cfset variables.grid = {} />
		<cfreturn this />
	</cffunction>

	<cffunction name="setValue" access="public" returntype="void" output="false">
		<cfargument name="position" type="struct" required="true" />
		<cfargument name="value" required="true" />

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