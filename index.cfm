<cfoutput>
<!DOCTYPE html>
<html>
<head>
	<title>Advent of Code 2017 - rellem's solutions in CFML</title>
	<style type="text/css">
		table { border-collapse: collapse; }
		table, th, td { border: 1px solid grey; }
		th { text-align: left; padding: 2px 8px 2px 8px; }
		td { padding: 1px 8px 1px 8px; }
	</style>
</head>
<body>
<table>
	<thead>
		<tr>
			<th>Puzzle</th>
			<th style="width: 10em;">Runtime on Lucee 5.2.4.37 in seconds</th>
			<th style="width: 10em;">Runtime on Adobe ColdFusion 2016.0.0.298074 in seconds</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td><a href="1-1.cfm">1-1</a></td>
			<td>0.01</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="1-2.cfm">1-2</a></td>
			<td>0.01</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="2-1.cfm">2-1</a></td>
			<td>0.01</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="2-2.cfm">2-2</a></td>
			<td>0.01</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="3-1.cfm">3-1</a></td>
			<td>0.1</td>
			<td>0.05</td>
		</tr>
		<tr>
			<td><a href="3-2.cfm">3-2</a></td>
			<td>0.01</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="4-1.cfm">4-1</a></td>
			<td>0.01</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="4-2.cfm">4-2</a></td>
			<td>0.02</td>
			<td>0.02</td>
		</tr>
		<tr>
			<td><a href="5-1.cfm">5-1</a></td>
			<td>0.25</td>
			<td>0.25</td>
		</tr>
		<tr>
			<td><a href="5-2.cfm">5-2</a></td>
			<td>19</td>
			<td>15</td>
		</tr>
		<tr>
			<td><a href="6-1.cfm">6-1</a></td>
			<td>0.04</td>
			<td>0.03</td>
		</tr>
		<tr>
			<td><a href="6-2.cfm">6-2</a></td>
			<td>0.04</td>
			<td>0.03</td>
		</tr>
		<tr>
			<td><a href="7-1.cfm">7-1</a></td>
			<td>0.01</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="7-2.cfm">7-2</a></td>
			<td>0.02</td>
			<td>0.03</td>
		</tr>
		<tr>
			<td><a href="8-1.cfm">8-1</a></td>
			<td>0.01</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="8-2.cfm">8-2</a></td>
			<td>0.01</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="9-1.cfm">9-1</a></td>
			<td>0.02</td>
			<td>0.02</td>
		</tr>
		<tr>
			<td><a href="9-2.cfm">9-2</a></td>
			<td>0.02</td>
			<td>0.03</td>
		</tr>
		<tr>
			<td><a href="10-1.cfm">10-1</a></td>
			<td>0.01</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="10-2.cfm">10-2</a></td>
			<td>0.07</td>
			<td>0.04</td>
		</tr>
		<tr>
			<td><a href="11-1.cfm">11-1</a></td>
			<td>0.01</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="11-2.cfm">11-2</a></td>
			<td>0.02</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="12-1.cfm">12-1</a></td>
			<td>0.02</td>
			<td>0.04</td>
		</tr>
		<tr>
			<td><a href="12-2.cfm">12-2</a></td>
			<td>0.4</td>
			<td>0.6</td>
		</tr>
		<tr>
			<td><a href="13-1.cfm">13-1</a></td>
			<td>0.01</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="13-2.cfm">13-2</a></td>
			<td>10</td>
			<td>9</td>
		</tr>
		<tr>
			<td><a href="14-1.cfm">14-1</a></td>
			<td>3.5</td>
			<td>2.5</td>
		</tr>
		<tr>
			<td><a href="14-2.cfm">14-2</a></td>
			<td>3.5</td>
			<td>2.5</td>
		</tr>
		<tr>
			<td><a href="15-1.cfm">15-1</a></td>
			<td>140</td>
			<td>350</td>
		</tr>
		<tr>
			<td><a href="15-2.cfm">15-2</a></td>
			<td>120</td>
			<td>330</td>
		</tr>
		<tr>
			<td><a href="16-1.cfm">16-1</a></td>
			<td>0.06</td>
			<td>0.1</td>
		</tr>
		<tr>
			<td><a href="16-2.cfm">16-2</a></td>
			<td>2</td>
			<td>2</td>
		</tr>
		<tr>
			<td><a href="17-1.cfm">17-1</a></td>
			<td>0.01</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="17-2.cfm">17-2</a></td>
			<td>16</td>
			<td>7</td>
		</tr>
		<tr>
			<td><a href="18-1.cfm">18-1</a></td>
			<td>0.01</td>
			<td>0.02</td>
		</tr>
		<tr>
			<td><a href="18-2.cfm">18-2</a></td>
			<td>1.5</td>
			<td>1.5</td>
		</tr>
		<tr>
			<td><a href="19-1.cfm">19-1</a></td>
			<td>0.3</td>
			<td>0.6</td>
		</tr>
		<tr>
			<td><a href="19-2.cfm">19-2</a></td>
			<td>0.3</td>
			<td>0.5</td>
		</tr>
		<tr>
			<td><a href="20-1.cfm">20-1</a></td>
			<td>2.5</td>
			<td>4</td>
		</tr>
		<tr>
			<td><a href="20-2.cfm">20-2</a></td>
			<td>2.5</td>
			<td>4</td>
		</tr>
		<tr>
			<td><a href="21-1.cfm">21-1</a></td>
			<td>0.3</td>
			<td>0.7</td>
		</tr>
		<tr>
			<td><a href="21-2.cfm">21-2</a></td>
			<td>130</td>
			<td>390</td>
		</tr>
		<tr>
			<td><a href="22-1.cfm">22-1</a></td>
			<td>0.1</td>
			<td>0.2</td>
		</tr>
		<tr>
			<td><a href="22-2.cfm">22-2</a></td>
			<td>55</td>
			<td>160</td>
		</tr>
		<tr>
			<td><a href="23-1.cfm">23-1</a></td>
			<td>0.1</td>
			<td>0.2</td>
		</tr>
		<tr>
			<td><a href="23-2.cfm">23-2</a></td>
			<td>0.01</td>
			<td>0.01</td>
		</tr>
		<tr>
			<td><a href="24-1.cfm">24-1</a></td>
			<td>17</td>
			<td>25</td>
		</tr>
		<tr>
			<td><a href="24-2.cfm">24-2</a></td>
			<td>20</td>
			<td>27</td>
		</tr>
		<tr>
			<td><a href="25-1.cfm">25-1</a></td>
			<td>16</td>
			<td>13</td>
		</tr>
		</tr>
	</tbody>
</table>
</body>
</html>
</cfoutput>