<cfinclude template="/fam/icap/use.cfm">
<cfinclude template="/fam/lo.cfm">
<div class="panel panel-info" style="max-width:880px;">
	<div class="panel-heading">
		<h3 class="panel-title">
		<strong>Incident Command Application</strong>
		</h3>
	</div>
	<div class="panel-body">
		<cfoutput query="FAMDB_User">
		<h4 class="panel-title">Hello <cfif #icap_admin# EQ 1>system operator<cfelseif #icap_use# EQ 1>user</cfif> <strong>#firstname# #lastname#</strong> (<strong>#email#</strong>). As
		<cfif #icap_role# EQ 'M'><strong>National Administrator</strong>, you can <strong><a href="/fam/icap/areas/">edit area records</a></strong>, <strong><a href="/fam/icap/teams/">edit team records</a></strong>, <strong><a href="/fam/icap/selections/">open/close/add positions</a></strong>, or <strong><a href="/fam/icap/selections/">select applicants for a position</a></strong>.
		<br>
		<br>
		As an <strong>applicant</strong> in <strong>#applicant_gaac_type#</strong> Area, you can also <strong><a href="/fam/icap/applicant/">edit your applicant record</a></strong>, <strong><a href="/fam/icap/positions/">browse and apply to positions</a></strong>, or <strong><a href="/fam/icap/positions/?user=#username#">view your application history</a></strong>.
		<cfelseif #icap_role# EQ 'C'>
		<strong>GACC Coordinator</strong> for <strong>#icap_area#</strong> Area, you can <strong><a href="/fam/icap/teams/">edit team records</a></strong>, <strong><a href="/fam/icap/selections/">open/close/add positions</a></strong>, or <strong><a href="/fam/icap/selections/">select applicants for a position</a></strong>.
		<br>
		<br>
		As an <strong>applicant</strong> in <strong>#applicant_gaac_type#</strong> Area, you can also <strong><a href="/fam/icap/applicant/">edit your applicant record</a></strong>, <strong><a href="/fam/icap/positions/">browse and apply to positions</a></strong>, or <strong><a href="/fam/icap/positions/?user=#username#">view your application history</a></strong>.
		<cfelseif #icap_role# EQ 'I'>
		<strong>Incident Commander</strong> for <strong>#icteam_name#</strong> Team, you can <strong><a href="/fam/icap/teams/">edit your team record</a></strong>, <strong><a href="/fam/icap/selections/">open/close/add positions</a></strong>, or <strong><a href="/fam/icap/selections/">select applicants for a position</a></strong>.
		<br>
		<br>
		As an <strong>applicant</strong> in <strong>#applicant_gaac_type#</strong> Area, you can also <strong><a href="/fam/icap/applicant/">edit your applicant record</a></strong>, <strong><a href="/fam/icap/positions/">browse and apply to positions</a></strong>, or <strong><a href="/fam/icap/positions/?user=#username#">view your application history</a></strong>.
		<cfelseif #icap_role# EQ 'A'>
		an <strong>Applicant</strong> in <strong>#applicant_gaac_type#</strong> Area, you can <strong><a href="/fam/icap/applicant/">edit your applicant record</a></strong>, <strong><a href="/fam/icap/positions/">browse and apply to positions</a></strong>, or <strong><a href="/fam/icap/positions/?user=#username#">view your application history</a></strong>.
		<cfelseif #icap_role# EQ ''>
		a <strong>user with no assigned role</strong>, so you can't do much.
		<cfelse>
		</cfif>
		</h4>
		</cfoutput>
		<br>
		<br>
		<h3 class="panel-title">
		<strong>Information for 2017-2018</strong>
		</h3>
		<table class="table table-bordered table-striped">
		<caption>
			The <strong>Incident Command Application</strong> was developed to facilitate Incident Management Teams in recruiting for and filling team positions. These positions are only for temporary assignments during an incident.<br>
			<br>
			All positions listed follow National Wildfire Coordination Group (NWCG) standard positions found in <a href="https://www.nwcg.gov/pms/docs/pms310-1.pdf" target="_blank">PMS 310-1 Wildland Fire Qualification System Guide</a>.  In order to apply to any position you must meet the qualifications and training as outlined in the 310-1 and be certified through your respective agency.
		</caption>
		<thead>
			<th>GACC</th>
			<th>Open Dates</th>
			<th>Contact</th>
		</thead>
		<tbody>
		<tr>
			<td>Alaska</td>
			<td>2017 Jul 01 - 2017 Oct 31 for IC positions<br>
			2017 Jul 01 - 2018 Jan 06 for other positions</td>
			<td>Peter Butteri <span class='pull-right'>907 356-5874</span></td>
		</tr>
		<tr>
			<td>California</td>
			<td>2017 Oct 01 - 2017 Oct 29 for IC positions<br>
			2017 Dec 01 - 2018 Jan 15 for other positions</td>
			<td>Van Arroyo <span class='pull-right'>916 978-4442</span></td>
		</tr>
		<tr>
			<td>Eastern</td>
			<td>2017 Sep 01 - 2017 Oct 15</td>
			<td>Brendan Neylon <span class='pull-right'>414 944-3811</span></td>
		</tr>
		<tr>
			<td>Great Basin</td>
			<td>2017 Nov 21 - 2018 Jan 13</td>
			<td>John "JP" Platt <span class='pull-right'>801 531-5320</span><br>
			Jana Barabochkine <span class='pull-right'>801 531-5320</span></td>
		</tr>
		<tr>
			<td>Northern Rockies</td>
			<td>2017 Dec 05 - 2018 Jan 20</td>
			<td>Judy Heintz <span class='pull-right'>406 329-4880</span></td>
		</tr>
		<tr>
			<td>Rocky Mountain</td>
			<td>2017 Nov 01 - 2017 Dec 01</td>
			<td>Troy Hagan <span class='pull-right'>303 445-4331</span></td>
		</tr>
		<tr>
			<td>Southern</td>
			<td>2017 Sep 01 - 2017 Sep 30</td>
			<td>Tracy Robinson <span class='pull-right'>678 320-3002</span></td>
		</tr>
		<tr>
			<td>Southwest</td>
			<td>2017 Nov 01 - 2017 Nov 30</td>
			<td>Kevin Ditmanson <span class='pull-right'>505 842-3473</span></td>
		</tr>
		<tr>
			<td>Pacific Northwest</td>
			<td>2017 Oct 30 - 2017 Nov 10 for IC positions<br>
			 2017 Nov 27 - 2018 Jan 08 for other positions</td>
			<td>Jennifer Bammert <span class='pull-right'>360 902-1300</span></td>
		</tr>
		</tbody>
		</table>
	</div>
<cfinclude template="/fam/gutter.cfm">
</div>
</body>
</html>