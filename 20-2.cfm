<cffunction name="solve" output="false">
	<cfargument name="input" required="true" />

	<cfset var particles = {} />
	<cfset var particle = '' />
	<cfset var line = '' />
	<cfset var lineIndex = '' />
	<cfset var words = '' />
	<cfloop list="#arguments.input#" item="line" index="lineIndex" delimiters="#Chr(10)#">
		<cfset line = Trim(line) />
		<cfset line = Replace(line, 'p', '') />
		<cfset line = Replace(line, 'v', '') />
		<cfset line = Replace(line, 'a', '') />
		<cfset line = Replace(line, '=', '', 'all') />
		<cfset line = Replace(line, '<', '', 'all') />
		<cfset line = Replace(line, '>', '', 'all') />
		<cfset line = Replace(line, ',', ' ', 'all') />
		<cfset line = Replace(line, '', ' ', 'all') />
		<cfset words = ListToArray(line, Chr(32)) />

		<cfset particle = {
			id = lineIndex - 1,
			p = {
				x = words[1],
				y = words[2],
				z = words[3]
			},
			v = {
				x = words[4],
				y = words[5],
				z = words[6]
			},
			a = {
				x = words[7],
				y = words[8],
				z = words[9]
			}
		} />
		<cfset particles[particle.id] = particle />
	</cfloop>

	<cfset var tick = '' />
	<cfset var idsByPos = '' />
	<cfset var pos = '' />
	<cfset var ids = '' />
	<cfset var id = '' />
	<cfloop from="1" to="1000" index="tick">
		<cfset idsByPos = {} />
		<cfloop collection="#particles#" item="id">
			<cfset particle = particles[id] />
			<cfset particle.v.x += particle.a.x />
			<cfset particle.v.y += particle.a.y />
			<cfset particle.v.z += particle.a.Z />
			<cfset particle.p.x += particle.v.x />
			<cfset particle.p.y += particle.v.y />
			<cfset particle.p.z += particle.v.z />
			<cfset pos = particle.p.x & '-' & particle.p.y & '-' & particle.p.z />
			<cfif !StructKeyExists(idsByPos, pos)>
				<cfset idsByPos[pos] = [] />
			</cfif>
			<cfset ArrayAppend(idsByPos[pos], id) />
		</cfloop>
		<cfloop collection="#idsByPos#" item="pos">
			<cfset ids = idsByPos[pos] />
			<cfif ArrayLen(ids) eq 1>
				<cfcontinue />
			</cfif>
			<cfloop array="#ids#" item="id">
				<cfset StructDelete(particles, id) />
			</cfloop>
		</cfloop>
	</cfloop>

	<cfreturn StructCount(particles) />
</cffunction>

<cfset testCases = [
	{
		input = 'p=<-6,0,0>, v=< 3,0,0>, a=< 0,0,0>
p=<-4,0,0>, v=< 2,0,0>, a=< 0,0,0>
p=<-2,0,0>, v=< 1,0,0>, a=< 0,0,0>
p=< 3,0,0>, v=<-1,0,0>, a=< 0,0,0>',
		expectedOutput = 1
	},
	{
		input = Trim(FileRead(ExpandPath('20.txt'))),
		expectedOutput = 477
	}
] />
<cfinclude template="test_runner_include.cfm" />
