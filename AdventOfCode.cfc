<cfcomponent output="false">

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

</cfcomponent>