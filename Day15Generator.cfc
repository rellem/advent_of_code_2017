<cfcomponent output="false">

	<cffunction name="init" access="public" output="false">
		<cfargument name="startingValue" type="numeric" required="true" />
		<cfargument name="factor" type="numeric" required="true" />

		<cfset variables.math = CreateObject('java', 'java.lang.Math') />

		<cfset variables.value = CreateObject('java', 'java.lang.Long').init(arguments.startingValue) />
		<cfset variables.factor = CreateObject('java', 'java.lang.Long').init(arguments.factor) />
		<cfset variables.divisor = CreateObject('java', 'java.lang.Long').init('2147483647') />

		<cfreturn this />
	</cffunction>

	<cffunction name="next" access="public" returntype="numeric" output="false">
		<!--- Digging down into Java seems to be the only way to make this work on Adobe ColdFusion.
		Doing a straigh-forward ((value * factor) % divisor) results in:
		"Cannot convert the value 1.8360891185E10 to an integer because it cannot fit inside an integer."
		Lucee works either way. --->
		<cfset variables.value = math.floorMod(math.multiplyExact(variables.value, variables.factor), variables.divisor) />
		<cfreturn variables.value />
	</cffunction>

	<cffunction name="nextMultipleOf" access="public" returntype="numeric" output="false">
		<cfargument name="multipleOf" type="numeric" required="true" />

		<cfloop condition="true">
			<cfset next() />
			<cfif variables.value % arguments.multipleOf eq 0>
				<cfreturn variables.value />
			</cfif>
		</cfloop>
	</cffunction>

</cfcomponent>