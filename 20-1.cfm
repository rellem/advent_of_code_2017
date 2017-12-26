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
	<cfset var id = '' />
	<cfloop from="1" to="1000" index="tick">
		<cfloop collection="#particles#" item="id">
			<cfset particle = particles[id] />
			<cfset particle.v.x += particle.a.x />
			<cfset particle.v.y += particle.a.y />
			<cfset particle.v.z += particle.a.Z />
			<cfset particle.p.x += particle.v.x />
			<cfset particle.p.y += particle.v.y />
			<cfset particle.p.z += particle.v.z />
		</cfloop>
	</cfloop>

	<cfset particle = particles[0] />
	<cfset var minDistance = Abs(particle.p.x) + Abs(particle.p.y) + Abs(particle.p.z) />
	<cfset var closest = 0 />
	<cfset var distance = '' />
	<cfloop collection="#particles#" item="id">
		<cfset particle = particles[id] />
		<cfset distance = Abs(particle.p.x) + Abs(particle.p.y) + Abs(particle.p.z) />
		<cfif distance lt minDistance>
			<cfset minDistance = distance />
			<cfset closest = id />
		</cfif>
	</cfloop>

	<cfreturn closest />
</cffunction>

<cfset testCases = [
	{
		input = 'p=< 3,0,0>, v=< 2,0,0>, a=<-1,0,0>
p=< 4,0,0>, v=< 0,0,0>, a=<-2,0,0>',
		expectedOutput = 0
	},
	{
		input = Trim(FileRead(ExpandPath('20.txt'))),
		expectedOutput = 144
	}
] />
<cfinclude template="test_runner_include.cfm" />
