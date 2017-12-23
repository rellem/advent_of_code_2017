<cfcomponent output="false">

	<cffunction name="isPrime" access="public" returntype="boolean" output="false">
		<cfargument name="n" type="numeric" required="true" />

		<cfif arguments.n lte 1>
			<cfreturn false />
		<cfelseif arguments.n lte 3>
			<cfreturn true />
		<cfelseif arguments.n % 2 eq 0 || arguments.n % 3 eq 0>
			<cfreturn false />
		</cfif>

		<cfset var i = 5 />
		<cfloop condition="i * i lte arguments.n">
			<cfif arguments.n % i eq 0 || arguments.n % (i + 2) eq 0>
				<cfreturn false />
			</cfif>
			<cfset i += 6 />
		</cfloop>

		<cfreturn true />
	</cffunction>

	<cffunction name="arrayOfNumbersToHexString" access="public" returntype="string" output="false">
		<cfargument name="arrayOfNumbers" type="array" required="true" />

		<cfset var hexString = '' />
		<cfset var number = '' />
		<cfset var hs = '' />
		<cfloop array="#arguments.arrayOfNumbers#" item="number">
			<cfset hs = FormatBaseN(number, 16) />
			<cfif Len(hs) eq 1>
				<cfset hs = '0' & hs />
			</cfif>
			<cfset hexString &= hs />
		</cfloop>

		<cfreturn LCase(hexString) />
	</cffunction>

	<cffunction name="getKnotHash" access="public" returntype="string" output="false">
		<cfargument name="input" required="true" />
		<cfargument name="numberOfNumbers" default="256" />
		<cfargument name="numberOfRounds" default="64" />
		<cfargument name="numberOfBlocks" default="16" />

		<cfset var numbers = [] />
		<cfset var i = '' />
		<cfloop from="0" to="#arguments.numberOfNumbers - 1#" index="i">
			<cfset ArrayAppend(numbers, i) />
		</cfloop>

		<cfset var lengths = [] />
		<cfset var inputIndex = '' />
		<cfloop from="1" to="#Len(input)#" index="inputIndex">
			<cfset ArrayAppend(lengths, Asc(Mid(arguments.input, inputIndex, 1))) />
		</cfloop>
		<cfset ArrayAppend(lengths, ListToArray('17,31,73,47,23'), true) />

		<cfset var pos = 0 />
		<cfset var skipSize = 0 />
		<cfset var roundIndex = '' />
		<cfset var length = '' />
		<cfset var offset = '' />
		<cfset var indexFromStart = '' />
		<cfset var indexFromEnd = '' />
		<cfloop from="1" to="#arguments.numberOfRounds#" index="roundIndex">
			<cfloop array="#lengths#" item="length">
				<cfloop from="0" to="#Floor(length / 2) - 1#" index="offset">
					<cfset indexFromStart = (pos + offset) % arguments.numberOfNumbers + 1 />
					<cfset indexFromEnd = (pos + length - 1 - offset) % arguments.numberOfNumbers + 1 />
					<cfset ArraySwap(numbers, indexFromStart, indexFromEnd) />
				</cfloop>

				<cfset pos = (pos + length + skipSize) % arguments.numberOfNumbers />
				<cfset skipSize++ />
			</cfloop>
		</cfloop>

		<cfset var numbersPerBlock = arguments.numberOfNumbers / arguments.numberOfBlocks />
		<cfset var denseHash = [] />
		<cfset var blockIndex = '' />
		<cfset var numberIndex = '' />
		<cfset var blockValue = '' />
		<cfset var number = '' />
		<cfloop from="1" to="#arguments.numberOfBlocks#" index="blockIndex">
			<cfset blockValue = 0 />
			<cfloop from="1" to="#numbersPerBlock#" index="numberIndex">
				<cfset number = numbers[(blockIndex - 1) * numbersPerBlock + numberIndex] />
				<cfset blockValue = BitXOR(blockValue, number) />
			</cfloop>
			<cfset ArrayAppend(denseHash, blockValue) />
		</cfloop>

		<cfreturn arrayOfNumbersToHexString(denseHash) />
	</cffunction>

	<cffunction name="dance" access="public" returntype="string" output="false">
		<cfargument name="programs" type="string" required="true" />
		<cfargument name="moves" type="string" required="true" />

		<cfset var numberOfPrograms = Len(arguments.programs) />

		<cfset var programsByName = {} />
		<cfset var programsByPos = {} />
		<cfset var pos = '' />
		<cfset var program = '' />
		<cfloop from="0" to="#numberOfPrograms - 1#" index="pos">
			<cfset program = { pos = pos, name = Mid(arguments.programs, pos + 1, 1) } />
			<cfset programsByName[program.name] = program />
			<cfset programsByPos[program.pos] = program />
		</cfloop>

		<cfset var move = '' />
		<cfset var name = '' />
		<cfset var pos1 = '' />
		<cfset var pos2 = '' />
		<cfset var program1 = '' />
		<cfset var program2 = '' />
		<cfset var name1 = '' />
		<cfset var name2 = '' />
		<cfloop list="#arguments.moves#" item="move">
			<cfswitch expression="#Left(move, 1)#">
				<cfcase value="s"><!--- shift to right --->
					<cfloop collection="#programsByName#" item="name">
						<cfset program = programsByName[name] />
						<cfset program.pos = (program.pos + Mid(move, 2, 100)) mod numberOfPrograms />
						<cfset programsByPos[program.pos] = program />
					</cfloop>
				</cfcase>
				<cfcase value="x"> <!--- swap by pos --->
					<cfset pos1 = ListGetAt(Mid(move, 2, 100), 1, '/') />
					<cfset pos2 = ListGetAt(Mid(move, 2, 100), 2, '/') />
					<cfset program1 = programsByPos[pos1] />
					<cfset program2 = programsByPos[pos2] />
					<cfset program1.pos = pos2 />
					<cfset program2.pos = pos1 />
					<cfset programsByPos[program1.pos] = program1 />
					<cfset programsByPos[program2.pos] = program2 />
				</cfcase>
				<cfcase value="p"> <!--- swap by name --->
					<cfset name1 = ListGetAt(Mid(move, 2, 100), 1, '/') />
					<cfset name2 = ListGetAt(Mid(move, 2, 100), 2, '/') />
					<cfset program1 = programsByName[name1] />
					<cfset program2 = programsByName[name2] />
					<cfset pos1 = program1.pos />
					<cfset pos2 = program2.pos />
					<cfset program1.pos = pos2 />
					<cfset program2.pos = pos1 />
					<cfset programsByPos[program1.pos] = program1 />
					<cfset programsByPos[program2.pos] = program2 />
				</cfcase>
				<cfdefaultcase>
					<cfthrow message="Unexpected move: #move#" />
				</cfdefaultcase>
			</cfswitch>
		</cfloop>

		<cfset var programsAfterDance = '' />
		<cfloop from="0" to="#numberOfPrograms - 1#" index="pos">
			<cfset programsAfterDance &= programsByPos[pos].name />
		</cfloop>

		<cfreturn programsAfterDance />
	</cffunction>

</cfcomponent>