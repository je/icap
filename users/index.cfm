<cfinclude template="/fam/icap/use.cfm">
<cfinclude template="/fam/lo.cfm">
<cfif #session.admin# EQ 1 and #cgi.query_string# EQ 'deteam_all_nonics' >

<cfelseif #session.admin# EQ 1 and #cgi.query_string# EQ 'demote_all_ics' >

<cfelseif #session.admin# EQ 1 or #session.icap_role# EQ 'C' or #session.icap_role# EQ 'M'>
	<cfquery name="tada" datasource="FAMDB">
	select firstname, lastname, username, email, t.icteam_name, icap_role, icap_area, icap_team,icap_use from dbo.users u left join ICAP_Prod.dbo.icap_teams t on icteam_id = icap_team where icap_use in (1,2) and icap_role in ('C','I') order by lastname, firstname
	</cfquery>
	<cfset cols = 'firstname,lastname,username,email,icteam_name,icap_role,icap_area,icap_team,icap_use'>
	<cfset heads = 'firstname,lastname,none,email,icteam_name,icap_role,icap_area,icap_team,none'>
	<cfset refs = 'none,none,none,username,icteam_name,none,icap_area,none,none'>
	<cfset rebs = 'none,none,none,users,icteam_name,none,icap_area,none,none'>
	<cfset cols = getMetadata(tada)>
	<cfset colList = "">
	<cfloop from="1" to="#arrayLen(cols)#" index="x"> <cfset colList = listAppend(colList, cols[x].name)> </cfloop>
	<div class="panel panel-default" style="">
		<div class="panel-heading">
			<h3 class="panel-title">
				<cfoutput>#tada.recordcount#</cfoutput> <strong>Users</strong>
			</h3>
		</div>
		<table class="table table-bordered table-condensed">
			<thead>
				<cfoutput>
				<cfif len(heads)>
				<cfloop list="#heads#" index='head'>
				<cfif head NEQ 'none'>
				<th>#head#</th>
				</cfif>
				</cfloop>
				<cfelse>
				<cfloop list="#collist#" index='head'>
				<th>#head#</th>
				</cfloop>
				</cfif>
				</cfoutput>
			</thead>
			<tbody>
				<cfoutput query="tada">
				<tr class="<cfif #icap_role# EQ "C">warning</cfif>">
				<cfset n = 1>
				<cfloop index="col" list="#collist#">
				<cfif len(heads)>
				<cfset hd = #listgetat(heads,n)#>
				<cfif hd NEQ 'none'>
				<cfset rf = #listgetat(refs,n)#>
				<td>
				<cfif rf NEQ 'none'>
				<cfset rfx = rf>
				<cfset rbx = #listgetat(rebs,n)#>
				<a href='/fam/#rbx#/?#tada[rfx][currentRow]#'><cfif isDate(tada[col][currentRow])>#dateformat(tada[col][currentRow], 'yyyy-mm-dd')#<cfelseif col EQ 'changed'>#tostring(tada[col][currentrow])#<cfelse>#tada[col][currentRow]#</cfif></a>
				<cfelse>
				<cfif isDate(tada[col][currentRow])>#dateformat(tada[col][currentRow], 'yyyy-mm-dd')#<cfelseif col EQ 'changed'>#tostring(tada[col][currentrow])#<cfelse>#tada[col][currentRow]#</cfif>
				</cfif>
				</td>
				</cfif>
				<cfelse>
				<td><cfif isDate(tada[col][currentRow])>#dateformat(tada[col][currentRow], 'yyyy-mm-dd')#<cfelseif col EQ 'changed'>#tostring(tada[col][currentrow])#<cfelse>#tada[col][currentRow]#</cfif></td>
				</cfif>
				<cfset n = n + 1>
				</cfloop>
				</tr>
				</cfoutput>
			</tbody>
		</table>
	</div>
</cfif>
<cfinclude template="/fam/gutter.cfm">
</body>
</html>