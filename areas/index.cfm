<cfinclude template="/fam/icap/use.cfm">
<cfif structKeyExists(form, 'areas')>
<cfset ser = ''>
<cfset serp = ''>
<cfoutput>
<cfloop list="#form.fieldnames#" index="i">
<cfset serp = "{#i#:#form[i]#}"
><cfset ser = ser & serp & '<br>'>
</cfloop>
</cfoutput>
</cfif>
<cfif structKeyExists(form, 'areas')>
<cfloop item="field" collection="#form#">
<cfif findNoCase("area_", field)>
<cfset area_id = listLast(field, "_")>
<cfquery datasource="ICAP_Prod">
update dbo.icap_areas set area = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form[field]#"> where area_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#area_id#">
</cfquery>
</cfif>
</cfloop>
</cfif>
<cfif structKeyExists(form, 'areas')>
<cfset msg_text = "Area records edited - <a class=""alert-link"" href=""/fam/users/?#session.user_webcaaf#"">#session.user_firstname# #session.user_lastname#</a> (<a class=""alert-link"" href=""/fam/users/?#session.user_webcaaf#"">#session.user_email#</a>).">
<cfset msg_status = "success">
</cfif>
<cfinclude template="/fam/lo.cfm">
<cfif isdefined('q')>
<cfset session.q = #q#>
<cfelse>
<cfset session.q = ''>
</cfif>
<cfif #cgi.query_string# NEQ ''>
<cfelseif #session.q# NEQ ''>
<cfelse>
<form name="areas" action="/fam/icap/areas/" method="post" enctype="multipart/form-data">
<div class="panel panel-info" style="max-width:880px;">
<div class="panel-heading">
<h3 class="panel-title">
<a href="/fam/icap/areas/"><strong>Editing Area Records</strong></a>
<span class="pull-right"><input class="btn btn-primary btn-xs" type="submit" name="areas" value="Save">
</h3>
</div>
<div class="panel-body form-inline">
<cfquery name="ada" datasource="ICAP_Prod">
select * from icap_areas a order by area
</cfquery>
<cfoutput query="FAMDB_user">
<input class="hidden" type="hidden" name="user_webcaaf" value="#username#">
<input class="hidden" type="hidden" name="user_firstname" value="#firstname#">
<input class="hidden" type="hidden" name="user_lastname" value="#lastname#">
<input class="hidden" type="hidden" name="user_email" value="#email#">
</cfoutput>
<cfoutput query='ada'>
<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
<div class='col-xs-12 col-sm-5 col-md-4 col-lg-4 c' style="max-width:280px;">
<div class="form-group form-group-sm">
<label class="control-label">ID:</label>
<span class='pull-right'><input type="text" class="form-control input-sm" id="area_id_#area_id#" value="#area_id#" name="area_id_#area_id#" disabled></span>
</div>
</div>
<div class='col-xs-12 col-sm-7 col-md-8 col-lg-8 c pull-right' style="max-width:420px;margin-left:10px;">
<div class="form-group form-group-sm">
<label class="control-label">Area:</label>
<span class='pull-right'><input type="text" class="form-control input-sm" id="area_#area_id#" value="#area#" name="area_#area_id#"></span>
</div>
</div>
</div>
</cfoutput>
</div>
</form>
</cfif>
</div>
</div>
</div>
<cfinclude template="/fam/gutter.cfm">
</body>
</html>
