<cfcomponent output="false">

	<cffunction name="run" access="public" returntype="struct" output="false">
		<cfargument name="input" type="string" required="true" />
		<cfargument name="initialRegisterValues" type="struct" required="true" />

		<cfset var instructions = [] />
		<cfset var line = '' />
		<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
			<cfset ArrayAppend(instructions, ListToArray(Trim(line), Chr(32))) />
		</cfloop>

		<cfset variables.registers = {} />
		<cfset var i = '' />
		<cfloop from="#Asc('a')#" to="#Asc('h')#" index="i">
			<cfset variables.registers[Chr(i)] = 0 />
		</cfloop>
		<cfset StructAppend(variables.registers, arguments.initialRegisterValues)>

		<cfset var counters = {
			numberOfAdditions = 0,
			numberOfJumpsGreaterThanZeroTaken = 0,
			numberOfJumpsNotZeroTaken = 0,
			numberOfModuli = 0,
			numberOfMultiplications = 0,
			numberOfSets = 0,
			numberOfSubtractions = 0
		} />

		<cfset var ip = 1 />
		<cfset var instruction = '' />
		<cfloop condition="ip gte 1 && ip lte #ArrayLen(instructions)#">
			<cfset instruction = instructions[ip] />
			<cfswitch expression="#instruction[1]#">
				<cfcase value="add">
					<cfset setRegisterValue(instruction[2], getRegisterValue(instruction[2]) + getValue(instruction[3])) />
					<cfset counters.numberOfAdditions++ />
				</cfcase>
				<cfcase value="jgz">
					<cfif getValue(instruction[2]) gt 0>
						<cfset ip += getValue(instruction[3]) - 1 />
						<cfset counters.numberOfJumpsGreaterThanZeroTaken++ />
					</cfif>
				</cfcase>
				<cfcase value="jnz">
					<cfif getValue(instruction[2]) neq 0>
						<cfset ip += getValue(instruction[3]) - 1 />
						<cfset counters.numberOfJumpsNotZeroTaken++ />
					</cfif>
				</cfcase>
				<cfcase value="mod">
					<cfset setRegisterValue(instruction[2], getRegisterValue(instruction[2]) % getValue(instruction[3])) />
					<cfset counters.numberOfModuli++ />
				</cfcase>
				<cfcase value="mul">
					<cfset setRegisterValue(instruction[2], getRegisterValue(instruction[2]) * getValue(instruction[3])) />
					<cfset counters.numberOfMultiplications++ />
				</cfcase>
				<cfcase value="set">
					<cfset setRegisterValue(instruction[2], getValue(instruction[3])) />
					<cfset counters.numberOfSets++ />
				</cfcase>
				<cfcase value="sub">
					<cfset setRegisterValue(instruction[2], getRegisterValue(instruction[2]) - getValue(instruction[3])) />
					<cfset counters.numberOfSubtractions++ />
				</cfcase>
				<cfdefaultcase>
					<cfthrow message="Unexpected mnemonic: #instruction[1]#" />
				</cfdefaultcase>
			</cfswitch>

			<cfset ip++ />
		</cfloop>

		<cfreturn { registers = variables.registers, counters = counters } />
	</cffunction>

	<cffunction name="setRegisterValue" access="private" returntype="void" output="false">
		<cfargument name="register" type="string" required="true" />
		<cfargument name="value" type="numeric" required="true" />

		<cfset variables.registers[arguments.register] = arguments.value />
	</cffunction>

	<cffunction name="getRegisterValue" access="private" returntype="numeric" output="false">
		<cfargument name="register" type="string" required="true" />

		<cfreturn variables.registers[arguments.register] />
	</cffunction>

	<cffunction name="getValue" access="private" returntype="numeric" output="false">
		<cfargument name="valueOrRegister" type="string" required="true" />

		<cfif IsNumeric(arguments.valueOrRegister)>
			<cfreturn arguments.valueOrRegister />
		</cfif>

		<cfreturn getRegisterValue(arguments.valueOrRegister) />
	</cffunction>

</cfcomponent>