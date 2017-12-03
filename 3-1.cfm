<cffunction name="solve" returntype="numeric">
	<cfargument name="input" required="true" />

	<cfset var x = 0 />
	<cfset var y = 0 />
	<cfset var direction = 'E' />

	<cfset var minX = 0 />
	<cfset var maxX = 0 />
	<cfset var minY = 0 />
	<cfset var maxY = 0 />

	<cfset var i = '' />
	<cfloop from="1" to="#arguments.input - 1#" index="i">
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
	</cfloop>

	<cfreturn Abs(x) + Abs(y) />
</cffunction>

<cfoutput><p>solve(1) = #solve(1)# (expecting 0)</p></cfoutput>
<cfoutput><p>solve(12) = #solve(12)# (expecting 3)</p></cfoutput>
<cfoutput><p>solve(23) = #solve(23)# (expecting 2)</p></cfoutput>
<cfoutput><p>solve(1024) = #solve(1024)# (expecting 31)</p></cfoutput>
<cfoutput><p>solve(325489) = #solve(325489)#</p></cfoutput>
