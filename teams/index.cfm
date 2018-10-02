<cfinclude template="/fam/icap/use.cfm">
<cfif structKeyExists(form, 'teams')>
<cfset ser = ''>
<cfset serp = ''>
<cfoutput>
<cfloop list="#form.fieldnames#" index="i">
<cfset serp = "{#i#:#form[i]#}"
><cfset ser = ser & serp & '<br>'>
</cfloop>
</cfoutput>
</cfif>
<cfif structKeyExists(form, 'teams')>
<cfloop item="field" collection="#form#">
<cfif findNoCase("team_", field)>
<cfset icteam_id = listLast(field, "_")>
<cfquery datasource="ICAP_Prod">
update dbo.icap_teams set icteam_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form[field]#"> where icteam_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#icteam_id#">
</cfquery>
</cfif>
</cfloop>
</cfif>
<cfif structKeyExists(form, 'teams')>
<cfset msg_text = "Team records edited - <a class=""alert-link"" href=""/fam/users/?#session.user_webcaaf#"">#session.user_firstname# #session.user_lastname#</a> (<a class=""alert-link"" href=""/fam/users/?#session.user_webcaaf#"">#session.user_email#</a>).">
<cfset msg_status = "success">
</cfif>
<cfinclude template="/fam/lo.cfm">
<cfif isdefined('q')>
<cfset session.q = #q#>
<cfelse>
<cfset session.q = ''>
</cfif>
<form name="teams" action="/fam/icap/teams/" method="post" enctype="multipart/form-data">
<div class="panel panel-info" style="max-width:880px;">
<div class="panel-heading">
<h3 class="panel-title">
<a href="/fam/icap/teams/"><strong>Editing Team Records</strong></a>
<span class="pull-right"><input class="btn btn-primary btn-xs" type="submit" name="teams" value="Save">
</h3>
</div>
<div class="panel-body form-inline">
<cfquery name="ada" datasource="ICAP_Prod">
select * from icap_teams a
<cfif #FAMDB_User.icap_role# EQ 'M'>
<cfelseif #FAMDB_User.icap_role# EQ 'C'>
where icteam_area = '#FAMDB_User.icap_area#'
<cfelseif #FAMDB_User.icap_role# EQ 'I'>
where icteam_name = '#FAMDB_User.icteam_name#'
</cfif>
order by icteam_area, icteam_name
</cfquery>
<cfoutput query="FAMDB_user">
<input class="hidden" type="hidden" name="user_webcaaf" value="#username#">
<input class="hidden" type="hidden" name="user_firstname" value="#firstname#">
<input class="hidden" type="hidden" name="user_lastname" value="#lastname#">
<input class="hidden" type="hidden" name="user_email" value="#email#">
</cfoutput>
<table class='table table-bordered table-condensed'>
<thead>
<th>ID</th>
<th>Area</th>
<th>Team</th>
</thead>
<cfoutput query='ada'>
<tr>
<td>
    <div class="form-group form-group-sm">
     <span class='pull-right'><p class="form-control-static input-sm" name="icteam_id_#icteam_id#">#icteam_id#</p>
     <input class="hidden" type="hidden" id="icteam_id_#icteam_id#" name="icteam_id_#icteam_id#" value="#icteam_id#" disabled>
     </span>
    </div>
</td>
<td>
    <div class="form-group form-group-sm">
     <span class=''><input type="text" class="form-control input-sm" id="icteam_area_#icteam_id#" value="#icteam_area#" name="icteam_area_#icteam_id#" disabled></span>
    </div>
</td>
<td>
    <div class="form-group form-group-sm">
     <span class=''><input type="text" class="form-control input-sm" id="icteam_name_#icteam_id#" value="#icteam_name#" name="icteam_name_#icteam_id#"></span>
    </div>
</td>
</tr>
</cfoutput>
</table>
</div>
</form>
</cfif>
</div>
</div>
</div>
<cfinclude template="/fam/gutter.cfm">
</body>
</html>