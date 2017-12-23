<cfcomponent output="false">

	<cffunction name="init" access="public" returntype="Queue" output="false">
		<cfset variables.lockName = 'Queue-' & CreateUUID() />
		<cfset variables.queue = [] />
		<cfreturn this />
	</cffunction>

	<cffunction name="add" access="public" returntype="void" output="false">
		<cfargument name="value" type="any" required="true" />

		<cflock name="#variables.lockName#" timeout="60">
			<cfset ArrayAppend(variables.queue, arguments.value) />
		</cflock>
	</cffunction>

	<cffunction name="poll" access="public" returntype="any" output="false">
		<cfargument name="timeoutInMilliseconds" type="numeric" required="true" />

		<cfset var startTickCount = GetTickCount() />
		<cfset var value = '' />
		<cfloop condition="GetTickCount() - startTickCount lte arguments.timeoutInMilliseconds">
			<cflock name="#variables.lockName#" timeout="60">
				<cfif ArrayLen(variables.queue) gt 0>
					<cfset value = variables.queue[1] />
					<cfset ArrayDeleteAt(variables.queue, 1) />
					<cfreturn value />
				</cfif>
			</cflock>
			<cfset Sleep(10) />
		</cfloop>
		<cfthrow type="Queue.PollTimeout" message="Poll timeout" />
	</cffunction>

</cfcomponent>