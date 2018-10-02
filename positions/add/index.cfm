<cfinclude template="/fam/icap/use.cfm">
<cfinclude template="/fam/lo.cfm">
<cfset today = '#DateFormat(now(),"mm/dd/yyyy")# #TimeFormat(now(),"hh:mm:ss tt")#'>
<cfif structKeyExists(form, 'icteam_id')>
<cfquery name="add_position" datasource="ICAP_Prod">
insert into dbo.icap_positions (icteam_id,position_type,position_code,position_title,position_description,updated,updated_by) values (<cfqueryparam value="#form.icteam_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#form.position_type#" cfsqltype="cf_sql_varchar" maxlength="100">,<cfqueryparam value="#form.position_code#" cfsqltype="cf_sql_varchar" maxlength="4">,<cfqueryparam value="#form.position#" cfsqltype="cf_sql_varchar" maxlength="60">,<cfqueryparam value="#form.position_description#" cfsqltype="cf_sql_longvarchar">,'#today#','#session.user_webcaaf#')
</cfquery>
<cfquery name="get_last_id" datasource="ICAP_Prod" maxrows="1">
select icteam_id,position_id from icap_positions WHERE position_code = <cfqueryparam value="#form.position_code#" cfsqltype="cf_sql_varchar" maxlength="5"> order by position_id DESC
</cfquery>
<cfquery name="insert_status" datasource="ICAP_Prod">
insert into icap_positions_status (position_id,icteam_id,position_status,updated,updated_by) values (<cfqueryparam value="#get_last_id.position_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#get_last_id.icteam_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#form.position_status#" cfsqltype="cf_sql_varchar" maxlength="100">,'#today#',<cfqueryparam value="#session.user_webcaaf#" cfsqltype="cf_sql_varchar" maxlength="50">)
</cfquery>
Position added to single team
<cfelse>
<cfform name="pos_fm" action="/fam/icap/positions/add/" method="post" enctype="multipart/form-data">
<div class="panel panel-default" style="max-width:880px;">
<div class="panel-heading">
<h3 class="panel-title">
Adding a Position to a Single Team
<span class="pull-right"><input class="btn btn-primary btn-xs" type="submit" name="pos_fm" value="Save">
</h3>
</div>
<div class="panel-body form-horizontal">
<cfoutput query="FAMDB_user">
<input class="hidden" type="hidden" name="user_webcaaf" value="#username#">
<input class="hidden" type="hidden" name="user_firstname" value="#firstname#">
<input class="hidden" type="hidden" name="user_lastname" value="#lastname#">
<input class="hidden" type="hidden" name="user_email" value="#email#">
</cfoutput>
<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
<div class='col-xs-12 col-sm-5 col-md-4 col-lg-4 c' style="max-width:280px;">
<div class='col-xs-12 col-sm-7 col-md-8 col-lg-8 c pull-right' style="max-width:420px;margin-left:10px;">
<div class="form-group form-group-sm">
<label class="control-label">Team:</label>
<span class='pull-right'>
<cfselect name="icteam_id" class="form-control input-sm" >
<option value disabled selected></option>
<cfquery name="teams" datasource="ICAP_Prod">
select icteam_id, icteam_name from icap_teams order by icteam_name
</cfquery>
<cfoutput query="teams">
<option value="#icteam_id#">#icteam_name#</option>
</cfoutput>
</cfselect>
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Position Type:</label>
<span class='pull-right'>
<cfselect name="position_type" class="form-control input-sm" >
<option value="Command">Command</option>
<option value="Operations">Operations</option>
<option value="Planning">Planning</option>
<option value="Logistics">Logistics</option>
<option value="Finance">Finance</option>
</cfselect>
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Position Type:</label>
<span class='pull-right'>
<select name="position_status">
<option selected value="Closed">Closed</option>
<option value="Open">Open</option>
</select>
</span>
</div>
</div>
</div>
<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
<div class='col-xs-12 col-sm-6 col-md-6 col-lg-6 c'>
<div class="form-group form-group-sm">
<label class="control-label">Position Code:</label>
<span class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
<cfinput name="position_code" type="text" size="10" maxlength="4" required="yes">
</span>
</div>
</div>
<div class='col-xs-12 col-sm-6 col-md-6 col-lg-6 c'>
<div class="form-group form-group-sm">
<label class="control-label">Position:</label>
<span class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
<cfinput name="position" type="text" size="70" maxlength="60" required="yes">
</span>
</div>
</div>
<div class='col-xs-12 col-sm-6 col-md-6 col-lg-6 c'>
<div class="form-group form-group-sm">
<label class="control-label">Position Description:</label>
<span class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
<cftextarea class="form-control input-sm" name="position_description" rows="15" cols="22" style="height:72px;"><cfoutput></cfoutput></cftextarea>
</span>
</div>
</div>
</div>
</div>
</div>
</cfform>
</cfif>
</div>
<cfinclude template="/fam/gutter.cfm">
</body>
</html>