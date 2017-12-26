<cfcomponent output="false">

	<cffunction name="runAndReturnNumSentValues" access="public" returntype="numeric" output="false">
		<cfargument name="input" type="string" required="true" />
		<cfargument name="outQueue" type="Queue" required="true" />
		<cfargument name="inQueue" type="Queue" required="true" />
		<cfargument name="initialRegisterValues" type="struct" required="true" />

		<cfset javaMath = CreateObject('java', 'java.lang.Math') />

		<cfset var instructions = [] />
		<cfset var line = '' />
		<cfloop list="#arguments.input#" item="line" delimiters="#Chr(10)#">
			<cfset ArrayAppend(instructions, ListToArray(Trim(line), Chr(32))) />
		</cfloop>

		<cfset variables.registers = StructCopy(arguments.initialRegisterValues) />

		<cfset var numSentValues = 0 />

		<cfset var ip = 1 />
		<cfset var instruction = '' />
		<cfloop condition="ip gte 1 && ip lte #ArrayLen(instructions)#">
			<cfset instruction = instructions[ip] />
			<cfswitch expression="#instruction[1]#">
				<cfcase value="add">
					<cfset setRegisterValue(instruction[2], javaMath.addExact(getRegisterValue(instruction[2]), getValue(instruction[3]))) />
				</cfcase>
				<cfcase value="jgz">
					<cfif getValue(instruction[2]) gt 0>
						<cfset ip += getValue(instruction[3]) - 1 />
					</cfif>
				</cfcase>
				<cfcase value="mod">
					<cfset setRegisterValue(instruction[2], javaMath.floorMod(getRegisterValue(instruction[2]), getValue(instruction[3]))) />
				</cfcase>
				<cfcase value="mul">
					<cfset setRegisterValue(instruction[2], javaMath.multiplyExact(getRegisterValue(instruction[2]), getValue(instruction[3]))) />
				</cfcase>
				<cfcase value="rcv">
					<cftry>
						<cfset setRegisterValue(instruction[2], arguments.inQueue.poll(timeoutInMilliseconds = 1000)) />
						<cfcatch type="Queue.PollTimeout">
							<cfbreak />
						</cfcatch>
					</cftry>
				</cfcase>
				<cfcase value="set">
					<cfset setRegisterValue(instruction[2], getValue(instruction[3])) />
				</cfcase>
				<cfcase value="snd">
					<cfset arguments.outQueue.add(getValue(instruction[2])) />
					<cfset numSentValues++ />
				</cfcase>
				<cfdefaultcase>
					<cfthrow message="Unexpected mnemonic: #instruction[1]#" />
				</cfdefaultcase>
			</cfswitch>

			<cfset ip++ />
		</cfloop>

		<cfreturn numSentValues />
	</cffunction>

	<cffunction name="setRegisterValue" access="private" returntype="void" output="false">
		<cfargument name="register" type="string" required="true" />
		<cfargument name="value" type="numeric" required="true" />

		<cfset variables.registers[arguments.register] = CreateObject('java', 'java.lang.Long').init(arguments.value) />
	</cffunction>

	<cffunction name="getRegisterValue" access="private" returntype="numeric" output="false">
		<cfargument name="register" type="string" required="true" />

		<cfreturn variables.registers[arguments.register] />
	</cffunction>

	<cffunction name="getValue" access="private" returntype="numeric" output="false">
		<cfargument name="valueOrRegister" type="string" required="true" />

		<cfif IsNumeric(arguments.valueOrRegister)>
			<cfreturn CreateObject('java', 'java.lang.Long').init(arguments.valueOrRegister) />
		</cfif>

		<cfreturn getRegisterValue(arguments.valueOrRegister) />
	</cffunction>

</cfcomponent>