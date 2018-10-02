<cfinclude template="/fam/icap/use.cfm">
<cfinclude template="/fam/lo.cfm">
<style>
    table.s .tablesorter-header {
      cursor: pointer;
    }
    table.s .tablesorter-header:after {
      content: "";
      float: right;
      margin-top: 7px;
      border-width: 0 4px 4px;
      border-style: solid;
      border-color: #000000 transparent;
      visibility: hidden;
    }
    table.s .tablesorter-headerSortUp, table.s .tablesorter-headerSortDown {
      background-color: #f7f7f9;
      text-shadow: 0 1px 1px rgba(255, 255, 255, 0.75);
    }
    table.s .tablesorter-header:hover:after {
      visibility: visible;
    }
    table.s .tablesorter-headerSortDown:after, table.s .tablesorter-headerSortDown:hover:after {
      visibility: visible;
      filter: alpha(opacity=60);
      -moz-opacity: 0.6;
      opacity: 0.6;
    }
    table.s .tablesorter-headerSortUp:after {
      border-bottom: none;
      border-left: 4px solid transparent;
      border-right: 4px solid transparent;
      border-top: 4px solid #000000;
      visibility: visible;
      -webkit-box-shadow: none;
      -moz-box-shadow: none;
      box-shadow: none;
      filter: alpha(opacity=60);
      -moz-opacity: 0.6;
      opacity: 0.6;background-color:white;border-top:thick solid;
    }
  table.tablesorter thead tr .header {
    background-repeat: no-repeat;
    background-position: center right;
    cursor: pointer;
  }
  table.tablesorter thead tr .headerSortUp {
    background-image: url(/static/build/events/asc.gif);
  }
  table.tablesorter thead tr .headerSortDown {
    background-image: url(/static/build/events/desc.gif);
  }
</style>
<cfif structKeyExists(form, 'icteam_id') and (#session.icap_role# EQ 'M' OR #session.icap_role# EQ 'C' OR #session.icap_role# EQ 'I') >
    <cfquery name="get_area" datasource="ICAP_Prod" maxrows=1>
    select icteam_area, icteam_id from icap_teams where icteam_id = '#form.icteam_id#'
    </cfquery>
    <cfif #session.icap_role# EQ 'M' OR (#session.icap_role# EQ 'C' and #session.icap_area# EQ #get_area.icteam_area# ) OR (#session.icap_role# EQ 'I' and #session.icap_team# EQ #get_area.icteam_id#) >
        <cfif structKeyExists(form, 'open_one')>
            <cfquery name="set_one" datasource="ICAP_Prod">
            insert into icap_openings (position_id,status,status_date,created,created_by) values (<cfqueryparam value="#form.position_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#form.status#" cfsqltype="cf_sql_varchar" maxlength="50">,'#today#','#today#','#session.user_webcaaf#')
            </cfquery>
            <cfquery name="update_status" datasource="ICAP_Prod">
            update icap_positions_status SET position_status = <cfqueryparam value="#form.status#" cfsqltype="cf_sql_varchar" maxlength="100">,updated = '#today#',updated_by = <cfqueryparam value="#session.user_webcaaf#" cfsqltype="cf_sql_varchar" maxlength="50"> where position_id = <cfqueryparam value="#form.position_id#" cfsqltype="cf_sql_integer" maxlength="5"> and icteam_id = <cfqueryparam value="#form.icteam_id#" cfsqltype="cf_sql_integer" maxlength="5">
            </cfquery>
        </cfif>
        <cfif structKeyExists(form, 'reset_one')>
            <cfquery name="set_one" datasource="ICAP_Prod">
            insert into icap_selections (position_id,application_id,status,status_date,created,created_by) values (<cfqueryparam value="#form.position_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#form.application_id#" cfsqltype="cf_sql_integer" maxlength="7">,<cfqueryparam value="#form.status#" cfsqltype="cf_sql_varchar" maxlength="50">,'#today#','#today#','#session.user_webcaaf#')
            </cfquery>
        </cfif>
    </cfif>
</cfif>
<cfif isdefined('q')>
    <cfset session.q = #q#>
 <cfelse>
    <cfset session.q = ''>
</cfif>
<cfif #session.icap_role# EQ 'C'>
    <cfset fa = '#session.icap_area#'>
    <cfset ft = ''>
    <cfset fu = ''>
 <cfelseif #session.icap_role# EQ 'I'>
    <cfset fa = '#session.icap_area#'>
    <cfset ft = ''>
    <cfset fu = ''>
 <cfelseif #session.icap_role# EQ 'A'>
    <cfset fa = ''>
    <cfset ft = ''>
    <cfset fu = '#session.user_webcaaf#'>
</cfif>
<cfset dateq = ''>
<cfset qyyyy = ''>
<cfset qmm = ''>
<cfset qdd = ''>
<cfif #cgi.query_string# NEQ ''>
    <cfif #cgi.query_string# CONTAINS 'date='>
        <cfset dateq = Right( cgi.query_string, 16) />
        <cfset dateq = Right( dateq, 10) />
        <cfset qyyyy = listFirst(dateq, "-") />
        <cfset qmm = listGetAt(dateq, 2, "-") /> 
        <cfset qdd = listLast(dateq, "-") />
        <cfset dateq = createdate(qyyyy,qmm,qdd)>
     <cfelseif #fa# EQ 'California'>
        <cfset dateq = createdate(2017,10,01)>
     <cfelseif #fa# EQ 'PNW'>
        <cfset dateq = createdate(2017,11,26)>
     <cfelseif #fa# EQ 'Southwest'>
        <cfset dateq = createdate(2016,11,01)>
     <cfelseif #fa# EQ 'Great Basin'>
        <cfset dateq = createdate(2016,11,27)>
     <cfelse>
        <cfset dateq = createdate(2017,01,01)>
    </cfif>
</cfif>
<cfif #cgi.query_string# EQ '' or #session.q# NEQ ''>
 <cfif #fa# EQ 'California'>
    <cfset dateq = createdate(2017,10,01)>
 <cfelseif #fa# EQ 'PNW'>
    <cfset dateq = createdate(2017,11,26)>
 <cfelseif #fa# EQ 'Southwest'>
    <cfset dateq = createdate(2016,11,01)>
 <cfelseif #fa# EQ 'Great Basin'>
    <cfset dateq = createdate(2016,11,27)>
 <cfelse>
    <cfset dateq = createdate(2017,01,01)>
 </cfif>
</cfif>
<cfif #cgi.query_string# EQ '' and #session.q# EQ ''>
    <cfset oa = 'no'>
</cfif>
<cfset areaq = ''>
<cfset teamq = ''>
<cfset positionq = ''>
<cfset userq = ''>
<cfset posidq = ''>
<cfif #cgi.query_string# NEQ ''>
    <cfif #cgi.query_string# CONTAINS '&'>
        <cfset a = cgi.query_string.Split("&")>
        <cfif #a[1]# CONTAINS 'area='>
            <cfset areaq = REReplaceNoCase(a[1], "area=", "") />
            <cfset areaq = REReplace(areaq,"%20"," ","all")>
         <cfelseif #a[1]# CONTAINS 'team='>
            <cfset teamq = REReplaceNoCase(a[1], "team=", "") />
            <cfset teamq = REReplace(teamq,"%20"," ","all")>
        </cfif>
        <cfif #a[2]# CONTAINS 'position='>
            <cfset positionq = REReplaceNoCase(a[2], "position=", "") />
        </cfif>
     <cfelseif #cgi.query_string# CONTAINS 'area='>
        <cfset areaq = REReplaceNoCase(cgi.query_string, "area=", "") />
        <cfset areaq = REReplace(areaq,"%20"," ","all")>
     <cfelseif #cgi.query_string# CONTAINS 'team='>
        <cfset teamq = REReplaceNoCase(cgi.query_string, "team=", "") />
        <cfset teamq = REReplace(teamq,"%20"," ","all")>
     <cfelseif #cgi.query_string# CONTAINS 'position='>
        <cfset positionq = REReplaceNoCase(cgi.query_string, "position=", "") />
        <cfset positionq = REReplace(positionq,"%20"," ","all")>
     <cfelseif #cgi.query_string# CONTAINS 'user='>
        <cfset userq = REReplaceNoCase(cgi.query_string, "user=", "") />
        <cfset userq = REReplace(userq,"%20"," ","all")>
     <cfelseif #cgi.query_string# CONTAINS 'posid='>
        <cfset posidq = REReplaceNoCase(cgi.query_string, "posid=", "") />
        <cfset posidq = REReplace(posidq,"%20"," ","all")>
    </cfif>
</cfif>
<cfif #cgi.query_string# NEQ '' and  #areaq# EQ '' and #teamq# EQ '' and #positionq# EQ '' and #userq# EQ '' and #posidq# EQ '' and #dateq# EQ ''>
 <cfelse>
    <cfset cols = 'p.icteam_id,t.icteam_name,t.icteam_area,p.position_id,p.position_code,p.position_title,p.updated,p.updated_by,pu.email_address as puemail,s.position_status,oo.status_date as supdated,oo.created_by as supdated_by,su.email_address as suemail,<cfif #dateq# NEQ ''>count(distinct(case when aa.updated >= cast(#dateq# as date) then aa.applicant_id end))<cfelse>count(distinct aa.applicant_id)</cfif> as applicants,<cfif #dateq# NEQ ''>count(distinct(case when aa.updated >= cast(#dateq# as date) then aa.application_id end))<cfelse>count(distinct aa.application_id)</cfif> as applications,oo.status'>
    <cfif #teamq# NEQ '' and #positionq# NEQ ''>
        <cfset heads = '_,_,_,_,position code,position,_,_,_,position status,status updated,_,status updated by,applicant count,application count,position status'>
     <cfelseif #teamq# NEQ '' and #positionq# EQ ''>
        <cfset heads = '_,_,_,_,position code,position,_,_,_,position status,status updated,_,status updated by,applicant count,application count,position status'>
     <cfelseif #teamq# EQ '' and #positionq# NEQ ''>
        <cfset heads = '_,team name,_,_,_,_,_,_,_,position status,status updated,_,status updated by,applicant count,application count,position status'>
     <cfelse>
        <cfset heads = '_,team name,_,_,position code,position,_,_,_,position status,status updated,_,status updated by,applicant count,application count,position status'>
    </cfif>
    <cfset refs = 'icteam_id,icteam_name,_,position_id,position_code,_,_,updated_by,updated_by,_,_,supdated_by,supdated_by,_,_,_,_,_'>
    <cfset rebs = 'p.icteam_id,icap/selections/?team=,_,p.position_id,icap/selections/?position=,icap/selections/?position=,p.updated,p.updated_by,users/?,s.position_status,s.updated as supdated,s.updated_by as supdated_by,users/?,count(distinct q.applicant_id) as applicants,count(distinct aa.application_id) as applications,_'>
    <cfquery name="tada" datasource="ICAP_Prod" maxrows=9000 result="tr1">
    select p.icteam_id,t.icteam_name,t.icteam_area,p.position_id,p.position_code,p.position_title,p.updated,p.updated_by,pu.email_address as puemail,s.position_status,oo.status_date as supdated,oo.created_by as supdated_by,su.email_address as suemail,
    <cfif #dateq# NEQ ''>
        count(distinct(case when aa.updated >= cast(#dateq# as date) then aa.applicant_id end))
     <cfelse>
        count(distinct aa.applicant_id)
    </cfif> as applicants,
    <cfif #dateq# NEQ ''>
        count(distinct(case when aa.updated >= cast(#dateq# as date) then aa.application_id end))
     <cfelse>
        count(distinct aa.application_id)
    </cfif> as applications,oo.status from icap_positions p left join icap_teams t on p.icteam_id = t.icteam_id left outer join Region_6.dbo.login pu on p.updated_by = pu.webcaaf_id left outer join icap_positions_status s on p.position_id = s.position_id left outer join icap_positions_applicants q on p.position_id = q.position_id left outer join icap_applicants a on q.applicant_id = a.applicant_id left outer join Region_6.dbo.login au on a.applicant_eauth_id = au.webcaaf_id left outer join icap_applications aa on p.position_id = aa.position_id outer apply (select TOP 1 * from icap_openings oo where oo.position_id = p.position_id order by oo.status_date desc) as oo left outer join Region_6.dbo.login su on oo.created_by = su.webcaaf_id
    <cfif  #areaq# NEQ '' and #positionq# NEQ ''>
        where t.icteam_area = '#areaq#' and p.position_code = '#positionq#'
     <cfelseif  #areaq# NEQ ''>
        where t.icteam_area = '#areaq#'
     <cfelseif  #teamq# NEQ '' and #positionq# NEQ ''>
        where t.icteam_name = '#teamq#' and p.position_code = '#positionq#'
     <cfelseif  #teamq# NEQ ''>
        where t.icteam_name = '#teamq#'
     <cfelseif  #positionq# NEQ ''>
        where p.position_code = '#positionq#'
     <cfelseif  #userq# NEQ ''>
        where a.applicant_eauth_id = '#userq#'
     <cfelseif  #posidq# NEQ ''>
        where p.position_id = '#posidq#'
     <cfelseif #session.q# NEQ ''>
        where a.applicant_nameiii like '%#session.q#%'
    </cfif>
    <cfif #areaq# NEQ '' or #teamq# NEQ '' or #positionq# NEQ '' or #userq# NEQ '' or #posidq# NEQ '' or #session.q# NEQ ''>
        <cfif #session.icap_role# EQ 'C'>
            and t.icteam_area = '#fa#'
        </cfif>
        <cfif #session.icap_role# EQ 'I'>
            and t.icteam_area = '#fa#'
        </cfif>
        <cfif #session.icap_role# EQ 'A'>
            and a.applicant_eauth_id = '#fu#'
        </cfif>
     <cfelse>
        <cfif #session.icap_role# EQ 'C'>
         where t.icteam_area = '#fa#'
        </cfif>
        <cfif #session.icap_role# EQ 'I'>
         where t.icteam_area = '#fa#'
        </cfif>
        <cfif #session.icap_role# EQ 'A'>
         where a.applicant_eauth_id = '#fu#'
        </cfif>
    </cfif>
    group by p.position_id,p.position_code,p.position_title,p.icteam_id,t.icteam_name,t.icteam_area,p.updated,p.updated_by,pu.email_address,s.position_status,oo.status_date,oo.created_by,su.email_address,oo.status,oo.status_date order by t.icteam_name asc, position_code asc
    </cfquery>
    <cfif #posidq# NEQ '' and #tada.recordcount# EQ 0>
        <cfquery name="tada" datasource="ICAP_Prod" maxrows=9000 result="tr2">
        select p.icteam_id,t.icteam_name,t.icteam_area,p.position_id,p.position_code,p.position_title,p.updated,p.updated_by,pu.email_address as puemail,s.position_status,oo.status_date as supdated,oo.created_by as supdated_by,su.email_address as suemail,count(distinct q.applicant_id) as applicants,count(distinct aa.application_id) as applications,oo.status from icap_positions p left join icap_teams t on p.icteam_id = t.icteam_id left outer join Region_6.dbo.login pu on p.updated_by = pu.webcaaf_id left outer join icap_positions_status s on p.position_id = s.position_id left outer join icap_positions_applicants q on p.position_id = q.position_id left outer join icap_applicants a on q.applicant_id = a.applicant_id left outer join Region_6.dbo.login au on a.applicant_eauth_id = au.webcaaf_id left outer join icap_applications aa on p.position_id = aa.position_id outer apply (select TOP 1 * from icap_openings oo where oo.position_id = p.position_id order by oo.status_date desc) as oo left outer join Region_6.dbo.login su on oo.created_by = su.webcaaf_id where p.position_id = '#posidq#'
        <cfif #session.icap_role# EQ 'C'>
            and t.icteam_area = '#fa#'
        </cfif>
        <cfif #session.icap_role# EQ 'I'>
            and t.icteam_area = '#fa#'
        </cfif>
        <cfif #session.icap_role# EQ 'A'>
            and a.applicant_eauth_id = '#fu#'
        </cfif>
        group by p.icteam_id,t.icteam_name,t.icteam_area,p.position_id,p.position_code,p.position_title,p.updated,p.updated_by,pu.email_address,s.position_status,oo.status_date,oo.created_by,su.email_address,oo.status order by t.icteam_name asc, position_code asc
        </cfquery>
    </cfif>

    <cfif isdefined('oa')>
    <cfelseif #areaq# NEQ '' or #teamq# NEQ '' or #positionq# NEQ '' or #userq# NEQ '' or #posidq# NEQ '' or #session.q# NEQ '' or #dateq# NEQ ''>
        <cfset ca = 'q.icteam_id,t.icteam_name,t.icteam_area,position_applicant_id,q.position_id,p.position_code,s.position_status,q.applicant_id,a.applicant_eauth_id,a.applicant_namei,a.applicant_nameii,a.applicant_nameiii,a.applicant_IQCS,q.applicant_type,q.applicant_valid,q.closed,q.closed_by,ucemail,q.updated,q.updated_by,uuemail,aa.application_consideration,aa.application_accept_deny,aa.application_valid,aa.updated as aaupdated,aa.updated_by as aaupdated_by,uaa.email_address as uaaemail,a.applicant_retired,a.applicant_fq_email_type,a.applicant_agency_address,a.applicant_city,a.applicant_country,a.applicant_area,a.applicant_zip_code,a.applicant_dispatch_agency,a.applicant_agreement_holder_agency,a.applicant_email_address,a.applicant_work_phone,a.applicant_home_phone,a.applicant_cell_phone,a.applicant_pager_number,a.applicant_dispatch_phone,a.applicant_fax_phone,a.applicant_jet_port,a.applicant_weight,a.applicant_agency,ss.status_date,ss.created_by,uss.email_address as ussemail,ss.status,aa.application_id,applicant_qualifications,application_qualifications'>
        <cfif #teamq# NEQ '' and #positionq# NEQ ''>
            <cfquery name="get_area" datasource="ICAP_Prod" maxrows=1>
            select icteam_area, icteam_id from icap_teams where icteam_name = '#teamq#'
            </cfquery>
            <cfset aheads = '_,_,_,_,_,_,_,_,_,_,first,middle,last,_,_,_,_,_,_,_,_,_,application consideration,_,application valid,application updated,_,application updated by,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,status updated,_,status updated by,selection status,_,_,_,_,_,_'>
         <cfelseif #teamq# NEQ '' and #positionq# EQ ''>
            <cfquery name="get_area" datasource="ICAP_Prod" maxrows=1>
            select icteam_area, icteam_id from icap_teams where icteam_name = '#teamq#'
            </cfquery>
            <cfset aheads = '_,_,_,_,_,position code,position,_,_,_,first,middle,last,_,_,_,_,_,_,_,_,_,application consideration,_,application valid,application updated,_,application updated by,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,status updated,_,status updated by,selection status,_,_,_,_,_,_'>
         <cfelseif #teamq# EQ '' and #positionq# NEQ ''>
            <cfset aheads = '_,team name,_,_,_,_,position,_,_,_,first,middle,last,_,_,_,_,_,_,_,_,_,application consideration,_,application valid,application updated,_,application updated by,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,status updated,_,status updated by,selection status,_,_,_,_,_,_'>
         <cfelseif #userq# NEQ ''>
            <cfquery name="get_user" datasource="ICAP_Prod">
            select applicant_namei,applicant_nameii,applicant_nameiii from icap_applicants where applicant_eauth_id = '#userq#'
            </cfquery>
            <cfif #get_user.recordcount# EQ 0>
            <cfquery name="get_user" datasource="FAMDB">
            select firstname as applicant_namei,'' as applicant_nameii, lastname as applicant_nameiii from users where username = '#userq#'
            </cfquery>
            </cfif>
            <cfset aheads = '_,team name,_,_,_,position code,position,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,application consideration,_,application valid,application updated,_,application updated by,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,status updated,_,status updated by,selection status,_,_,_,_,_,_'>
         <cfelse>
            <cfset aheads = '_,team name,_,_,_,position code,position,_,_,_,first,middle,last,_,_,_,_,_,_,_,_,_,application consideration,_,application valid,application updated,_,application updated by,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,status updated,_,status updated by,selection status,_,_,_,_,_,_'>
        </cfif>
        <cfset arefs = '_,icteam_name,_,_,_,position_code,_,_,_,_,_,_,applicant_eauth_id,_,_,_,_,_,ucemail,_,updated_by,updated_by,_,_,_,_,aaupdated_by,aaupdated_by,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,created_by,_,_,_,_,_,_,_'>
        <cfset arebs = '_,icap/selections/?team=,_,position_applicant_id,q.position_id,icap/selections/?position=,_,_,p.position_id,_,q.applicant_id,a.applicant_eauth_id,icap/selections/?user=,_,_,icap/applicants,q.applicant_type,q.applicant_valid,users/?,q.closed_by,users,users/?,q.updated_by,users,aa.application_consideration,aa.application_accept_deny,_,users/?,this,users/?,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,users/?,ss.updated_by,users/?,ss.status,_,_,_,_,_,_'>
        <cfquery name="oada" datasource="ICAP_Prod" maxrows=90000>
        select p.icteam_id,t.icteam_name,t.icteam_area,ISNULL(q.position_applicant_id,'') AS position_applicant_id,aa.position_id,p.position_code,p.position_title,s.position_status,aa.applicant_id,a.applicant_eauth_id,fu.firstname,a.applicant_nameii,fu.lastname,a.applicant_IQCS,ISNULL(q.applicant_type,'') AS applicant_type,ISNULL(q.applicant_valid,'') AS applicant_valid,ISNULL(q.closed,'') AS closed,ISNULL(q.closed_by,'') AS closed_by,uc.email_address as ucemail,ISNULL(q.updated,'') AS updated,ISNULL(q.updated_by,'') AS updated_by,uu.email_address as uuemail,aa.application_consideration,aa.application_accept_deny,aa.application_valid,aa.updated as aaupdated,aa.updated_by as aaupdated_by,uaa.email_address as uaaemail,a.applicant_retired,a.applicant_fq_email_type,a.applicant_agency_address,a.applicant_city,a.applicant_country,a.applicant_area,a.applicant_zip_code,a.applicant_dispatch_agency,a.applicant_agreement_holder_agency,a.applicant_email_address,a.applicant_work_phone,a.applicant_home_phone,a.applicant_cell_phone,a.applicant_pager_number,a.applicant_dispatch_phone,a.applicant_fax_phone,a.applicant_jet_port,a.applicant_weight,a.applicant_agency,ss.status_date,ss.created_by,uss.email_address as ussemail,ss.status,aa.application_id,applicant_qualifications,application_qualifications,a.applicant_namei,a.applicant_nameiii,fu.email from icap_applications aa left join icap_positions p on aa.position_id = p.position_id outer apply (select TOP 1 * from icap_positions_applicants q where q.position_id = p.position_id and q.applicant_id = aa.applicant_id order by q.updated desc) as q left join icap_teams t on p.icteam_id = t.icteam_id left join icap_applicants a on aa.applicant_id = a.applicant_id left outer join Region_6.dbo.login u on a.applicant_eauth_id = u.webcaaf_id left outer join Region_6.dbo.login uc on q.closed_by = uc.webcaaf_id left outer join Region_6.dbo.login uu on q.updated_by = uu.webcaaf_id left outer join Region_6.dbo.login uaa on aa.updated_by = uaa.webcaaf_id left outer join icap_positions_status s on p.position_id = s.position_id outer apply (select TOP 1 * from icap_selections ss where ss.position_id = p.position_id and ss.application_id = aa.application_id order by ss.status_date desc) as ss left outer join Region_6.dbo.login uss on ss.created_by = uss.webcaaf_id left outer join FAMDB.dbo.users fu on a.applicant_eauth_id = fu.username
        <cfif #areaq# NEQ '' and #positionq# NEQ ''>
            where t.icteam_area = '#areaq#' and p.position_code = '#positionq#'
         <cfelseif  #areaq# NEQ ''>
            where t.icteam_area = '#areaq#'
         <cfelseif  #teamq# NEQ '' and #positionq# NEQ ''>
            where t.icteam_name = '#teamq#' and p.position_code = '#positionq#'
         <cfelseif  #teamq# NEQ ''>
            where t.icteam_name = '#teamq#'
         <cfelseif  #positionq# NEQ ''>
            where p.position_code = '#positionq#'
         <cfelseif  #userq# NEQ ''>
            where a.applicant_eauth_id = '#userq#'
         <cfelseif  #posidq# NEQ ''>
            where p.position_id = '#posidq#'
         <cfelseif #session.q# NEQ ''>
            where a.applicant_nameiii like '%#session.q#%'
        </cfif>
        <cfif #areaq# NEQ '' or #teamq# NEQ '' or #positionq# NEQ '' or #userq# NEQ '' or #posidq# NEQ '' or #session.q# NEQ ''>
            <cfif #session.icap_role# EQ 'C'>
                and t.icteam_area = '#fa#'
            </cfif>
            <cfif #session.icap_role# EQ 'I'>
                and t.icteam_area = '#fa#'
            </cfif>
            <cfif #session.icap_role# EQ 'A'>
                and a.applicant_eauth_id = '#fu#'
            </cfif>
         <cfelse>
            <cfif #session.icap_role# EQ 'C'>
                where t.icteam_area = '#fa#'
            </cfif>
            <cfif #session.icap_role# EQ 'I'>
                where t.icteam_area = '#fa#'
            </cfif>
            <cfif #session.icap_role# EQ 'A'>
                where a.applicant_eauth_id = '#fu#'
            </cfif>
        </cfif>
        <cfif #dateq# NEQ ''>
            and aa.updated >= cast(#dateq# as date)
        </cfif>
        order by t.icteam_name asc, position_code asc, q.updated desc, aa.updated desc
        </cfquery>
    </cfif>
</cfif>
<div class="" style="padding-right:20px;">
<cfif isDefined('tada') >
<cfset cols = getMetadata(tada)>
<cfset colList = "">
<cfloop from="1" to="#arrayLen(cols)#" index="x"> <cfset colList = listAppend(colList, cols[x].name)> </cfloop>
<div class="panel panel-info" style="max-width:none;">
<div class="panel-heading">
<h3 class="panel-title">
<cfif #areaq# NEQ '' and #positionq# NEQ ''>
<cfoutput>#tada.recordcount# <a href="/fam/icap/selections/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Positions</span></strong> in <a href="/fam/icap/selections/?area=#areaq#"><strong>#areaq#</strong></a> <strong><span class="text-muted">Area</span></strong></cfoutput>
<cfelseif #areaq# NEQ ''>
<cfoutput>#tada.recordcount# <strong><span class="text-muted">Positions</span></strong> in <a href="/fam/icap/selections/?area=#areaq#"><strong>#areaq#</strong></a> <strong><span class="text-muted">Area</span></strong></cfoutput>
<cfelseif #teamq# NEQ '' and #positionq# NEQ ''>
<cfoutput>#tada.recordcount# <a href="/fam/icap/selections/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Positions</span></strong> on <a href="/fam/icap/selections/?team=#teamq#"><strong>#teamq#</strong></a></cfoutput>
<cfelseif #teamq# NEQ ''>
<cfoutput>#tada.recordcount# <strong><span class="text-muted">Positions</span></strong> on <a href="/fam/icap/selections/?team=#teamq#"><strong>#teamq#</strong></a></cfoutput>
<cfelseif #positionq# NEQ ''>
<cfoutput>#tada.recordcount# <a href="/fam/icap/selections/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Positions</span></strong></cfoutput>
<cfelseif #userq# NEQ ''>
<cfoutput>#tada.recordcount# <strong><span class="text-muted">Positions</span></strong> with <strong><span class="text-muted">Applications</span></strong> by <strong><span class="text-muted">User</span> <a href="/fam/icap/selections/?user=#userq#"><cfif #get_user.applicant_nameIII# NEQ "">#get_user.applicant_nameI# #get_user.applicant_nameII# #get_user.applicant_nameIII#<cfelse>NO NAME</cfif></strong></a></cfoutput>
<cfelseif #posidq# NEQ ''>
<cfoutput>#tada.recordcount# <strong><span class="text-muted">Positions</span></strong> with <a href="/fam/icap/selections/?posid=#posidq#"><strong><span class="text-muted">Position ID</span> #posidq#</strong></a></cfoutput>
<cfelse>
<cfoutput>#tada.recordcount#</cfoutput> <strong><span class="text-muted">Positions</span></strong>
</cfif>
    <span class="form-inline pull-right">
    <span style='margin-right:10px;'>
    </span>
    <form class="form-inline pull-right" style="max-width:300px;" action="/fam/icap/selections/" method="post" enctype="multipart/form-data">
    <div class="input-group input-group-sm">
        <input type="text" class="form-control" style="height:21px;" name="q" size="30" maxlength="30" value="<cfif #session.q# NEQ ''><cfoutput>#session.q#</cfoutput></cfif>" placeholder="search by applicant last name">
        <span class="input-group-btn" style="font-size: 10px !important;">
        <button class="btn btn-default btn-xs" style="height:21px;padding-top:1px;" type="submit" name="submit">search</button>
        </span>
    </div>
    </form>
    </span>
</h3>
</div>
<div class="panel-body">
<cfoutput query="FAMDB_user">
    <cfif #icap_role# EQ 'M'>You are <strong>National Administrator</strong>, so the table below is not filtered. Applicant reports are availble from the <a href='/fam/icap/reports/'><strong>reports page</strong></a>.
    <cfelseif #icap_role# EQ 'C'>You are <strong>GACC Coordinator</strong> for <strong>#icap_area#</strong> Area, so the table below is filtered to show only <strong>#icap_area#</strong> Area positions and applications. Use the 'position status' to open or close positions. Applicant reports are availble from the <a href='/fam/icap/reports/'><strong>reports page</strong></a>.
    <cfelseif #icap_role# EQ 'I'>You are <strong>Incident Commander</strong> for <strong>#icteam_name#</strong> Team, so the table below is filtered to show only <strong>#icap_area#</strong> Area positions and applications. Use the 'position status' to open or close positions. Applicant reports are availble from the <a href='/fam/icap/reports/'><strong>reports page</strong></a>.
    <cfelseif #icap_role# EQ 'A'>The table below is filtered to show only your applications.
    <cfelseif #icap_role# EQ ''><strong>Blank user access -- request access to do better.</strong><br></cfif>
</cfoutput>
</div>
<table class="tablesorter table table-bordered table-condensed table-hover" id="s1">
<thead>
<tr id="heads" style="display:table-row !important">
<cfoutput>
<cfif len(heads)>
    <cfloop list="#heads#" index='head'>
    <cfif head NEQ '_'>
    <th data-sortable-col><small>#head#</small></th>
    </cfif>
    </cfloop>
 <cfelse>
    <cfloop list="#collist#" index='head'>
    <th data-sortable-col><small>#head#</small></th>
    </cfloop>
</cfif>
</cfoutput>
</tr>
</thead>

<tbody>
<cfoutput query="tada">
<tr class="<cfif position_status EQ 'Open'>text-success<cfelseif position_status EQ 'Closed'>text-warning</cfif>">
<cfset n = 1>
<cfloop index="col" list="#collist#">
<cfif len(heads)>
    <cfset hd = #listgetat(heads,n)#>
    <cfif hd NEQ '_'>
        <cfset rf = #listgetat(refs,n)#>
        <cfif col EQ 'status'>
            <td style='min-width:110px'><small>
            <cfif #session.icap_role# EQ 'M' OR (#session.icap_role# EQ 'C' and #session.icap_area# EQ #icteam_area# ) OR (#session.icap_role# EQ 'I' and #session.icap_team# EQ #icteam_id#) >
                <form class='form-inline' action="./?team=#icteam_name#&position=#position_code#" method="post">
                    <input class="hidden" type="hidden" name="position_id" value="#position_id#">
                    <input class="hidden" type="hidden" name="icteam_id" value="#icteam_id#">
                    <select class="form-control input-sm" type="select" name="status">
                    <cfset olist = 'Open,Closed,Locked,Deleted' />
                    <cfif listfind(olist,#status#) EQ '0'><option value="" selected disabled></option></cfif>
                    <option value="Open" <cfif #status# EQ 'Open'>selected</cfif>>Open</option>
                    <option value="Closed" <cfif #status# EQ 'Closed'>selected</cfif>>Closed</option>
                    <option value="Locked" <cfif #status# EQ 'Locked'>selected</cfif>>Locked</option>
                    <option value="Deleted" <cfif #status# EQ 'Deleted'>selected</cfif>>Deleted</option>
                    </select>
                    <input class="hidden" type="hidden" name="open_one" value="">
                    <input class="btn btn-warning btn-xs pull-right" type="submit" name="status_fm" value="Set">
                </form>
             <cfelse>
                #status#
            </cfif>
            </small></td>
         <cfelseif col EQ 'position_title'>
            <td style='min-width:110px'><small>
            <a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'><cfelseif position_status EQ 'Closed'><strong class='text-warning'></cfif>#position_title#</strong></a>
            </small></td>
         <cfelseif col EQ 'position_status'>
            <td style='min-width:110px'><small>
            <a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'>Open</strong><cfelseif position_status EQ 'Closed'><strong class='text-warning'>Closed</strong></cfif></a>
            </small></td>
         <cfelseif col EQ 'applicants'>
            <td style='text-align:right;'><small>
            <a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'>#tada[col][currentRow]#</strong><cfelseif position_status EQ 'Closed'><strong class='text-warning'>#tada[col][currentRow]#</strong></cfif></a>
            </small></td>
         <cfelseif col EQ 'applications'>
            <td style='text-align:right;'><small>
            <a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'>#tada[col][currentRow]#</strong><cfelseif position_status EQ 'Closed'><strong class='text-warning'>#tada[col][currentRow]#</strong></cfif></a>
            </small></td>
         <cfelseif rf NEQ '_'>
            <cfset rfx = rf>
            <cfset rbx = #listgetat(rebs,n)#>
            <td<cfif isNumeric(tada[col][currentRow])> style='text-align:right;'</cfif>><small>
            <a href='/fam/#rbx##tada[rfx][currentRow]#'><cfif isDate(tada[col][currentRow])>#dateformat(tada[col][currentRow], 'yyyy-mm-dd')#<cfelseif col EQ 'changed'>#tostring(tada[col][currentrow])#<cfelse>#tada[col][currentRow]#</cfif></a>
            </small></td>
         <cfelse>
            <td<cfif isNumeric(tada[col][currentRow])> style='text-align:right;'</cfif>><small>
            <cfif isDate(tada[col][currentRow])>#dateformat(tada[col][currentRow], 'yyyy-mm-dd')#<cfelseif col EQ 'changed'>#tostring(tada[col][currentrow])#<cfelse>#tada[col][currentRow]#</cfif>
            </small></td>
        </cfif>
    </cfif>
 <cfelse>
    <td<cfif isNumeric(tada[col][currentRow])> style='text-align:right;'</cfif>><small><cfif isDate(tada[col][currentRow])>#dateformat(tada[col][currentRow], 'yyyy-mm-dd')#<cfelseif col EQ 'changed'>#tostring(tada[col][currentrow])#<cfelse>#tada[col][currentRow]#</cfif></small></td>
</cfif>
<cfset n = n + 1>
</cfloop>
</tr>
</cfoutput>
</tbody>
</table>
<div class="panel-footer small">
<cfoutput query="FAMDB_user">
        <cfif #icap_role# EQ 'M'>You are <strong>National Administrator</strong>, so the table above is not filtered.
        <cfelseif #icap_role# EQ 'C'>You are <strong>GACC Coordinator</strong> for <strong>#icap_area#</strong> Area, so the table above is filtered to show only <strong>#icap_area#</strong> Area positions and applications.
        <cfelseif #icap_role# EQ 'I'>You are <strong>Incident Commander</strong> for <strong>#icteam_name#</strong> Team, so the table above is filtered to show only <strong>#icap_area#</strong> Area positions and applications.
        <cfelseif #icap_role# EQ 'A'>The table above is filtered to show only your applications.
        <cfelseif #icap_role# EQ ''><strong>Blank user access -- request access to do better.</strong><br></cfif>
</cfoutput>
</div>
</div>
</cfif>
<cfif isDefined('vada')>
<cfset vols = getMetadata(vada)>
<cfset volList = "">
<cfloop from="1" to="#arrayLen(vols)#" index="x"> <cfset volList = listAppend(volList, vols[x].name)> </cfloop>
<div class="panel panel-info" style="max-width:none;">
<div class="panel-heading">
<h3 class="panel-title">
<cfif isDefined('vheads')>
<strong>Position</strong> <cfoutput>#vada.position_code# <strong>&sect</strong> #vada.icteam_name#</cfoutput>
    <span class="form-inline pull-right">
    <span style=''>
        <button class="btn btn-default btn-xs" type="edit" name="Edit">Edit position</button> 
    </span>
    </span>
<cfelse>
</cfif>
</h3>
</div>
<div class="panel-body">
<cfif isDefined('vheads')>
<div class='col-xs-12 col-sm-4 col-md-4 col-lg-4'>
<cfoutput query="vada">
<cfset n = 1>
    <table class="tablesorter table table-bordered table-condensed table-hover" id="s2">
    <cfloop index="vol" list="#vollist#">
    <tr>
    <cfif len(vheads)>
        <cfset hd = #listgetat(vheads,n)#>
        <cfif hd NEQ '_'>
            <th  data-sortable-col style='max-width:90px;text-align:right;'><strong>#hd#</strong></th>
            <cfset rf = #listgetat(vrefs,n)#>
            <cfif isNumeric(vada[vol][currentRow])>
                <td style='padding-left:10px;text-align:right;'>
            <cfelse>
                <td style='padding-left:10px;'>
            </cfif>
                <cfif vol EQ 'position_status'>
                <a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'>Open</strong><cfelseif position_status EQ 'Closed'><strong class='text-warning'>Closed</strong></cfif></a>
                <cfelseif vol EQ 'applicants'>
                <a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'>#vada[vol][currentRow]#</strong><cfelseif position_status EQ 'Closed'><strong class='text-warning'>#vada[vol][currentRow]#</strong></cfif></a>
                <cfelseif vol EQ 'applications'>
                <a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'>#vada[vol][currentRow]#</strong><cfelseif position_status EQ 'Closed'><strong class='text-warning'>#vada[vol][currentRow]#</strong></cfif></a>
                <cfelseif rf NEQ '_'>
                <cfset rfx = rf>
                <cfset rbx = #listgetat(vrebs,n)#>
                <a href='/fam/#rbx##vada[rfx][currentRow]#'>
                <cfif isDate(vada[vol][currentRow])>
                #dateformat(vada[vol][currentRow], 'yyyy-mm-dd')#
                <cfelseif vol EQ 'changed'>
                #tostring(vada[vol][currentrow])#
                <cfelse>
                #vada[vol][currentRow]#
                </cfif>
                </a>
            <cfelse>
                <cfif isDate(vada[vol][currentRow])>
                #dateformat(vada[vol][currentRow], 'yyyy-mm-dd')#
                <cfelseif vol EQ 'changed'>
                #tostring(vada[vol][currentrow])#
                <cfelse>
                #vada[vol][currentRow]#
                </cfif>
            </cfif>
            </td>
        </cfif>
    <cfelse>
        <th data-sortable-col style='max-width:90px;text-align:right;'><strong>#hd#</strong></th>
        <td style='padding-left:10px;'>
        <cfif isDate(vada[vol][currentRow])>
        #dateformat(vada[vol][currentRow], 'yyyy-mm-dd')#
        <cfelseif vol EQ 'changed'>
        #tostring(vada[vol][currentrow])#
        <cfelse>
        #vada[vol][currentRow]#
        </cfif>
        </td>
    </cfif>
    <cfset n = n + 1>
    </tr>
    </cfloop>
    </table>
</cfoutput>
</div>
</cfif>
<div class="panel-footer small">
<cfoutput query="FAMDB_user">
        <cfif #icap_role# EQ 'M'>You are <strong>National Administrator</strong>, so the table above is not filtered.
        <cfelseif #icap_role# EQ 'C'>You are <strong>GACC Coordinator</strong> for <strong>#icap_area#</strong> Area, so the table above is filtered to show only <strong>#icap_area#</strong> Area positions and applications.
        <cfelseif #icap_role# EQ 'I'>You are <strong>Incident Commander</strong> for <strong>#icteam_name#</strong> Team, so the table above is filtered to show only <strong>#icap_area#</strong> Area positions and applications.
        <cfelseif #icap_role# EQ 'A'>The table above is filtered to show only your applications.
        <cfelseif #icap_role# EQ ''><strong>Blank user access -- request access to do better.</strong><br></cfif>
</cfoutput>
</div>
</div>
</div>
</cfif>
<cfif isDefined('oada')>
<cfloop query="oada">
    <cfset j = QuerySetCell(oada, 'position_applicant_id', oada.currentrow, oada.currentrow) />
</cfloop>
<cfset ca = getMetadata(oada)>
<cfset colList = "">
<cfloop from="1" to="#arrayLen(ca)#" index="x"> <cfset colList = listAppend(colList, ca[x].name)> </cfloop>
<div class="panel panel-info" style="max-width:none;">
<div class="panel-heading">
<h3 class="panel-title">
<cfif isDefined('vada')>
<cfoutput>#oada.recordcount#</cfoutput> <a href="/fam/icap/selections/"><strong><span class="text-muted">Applicants</span></strong></a> for <cfoutput><strong>#vada.position_code#</strong> <strong>&sect</strong> <strong>#vada.icteam_name#</strong></cfoutput>
    <span class="form-inline pull-right">
    </span>
<cfelse>
<cfif  #areaq# NEQ '' and #positionq# NEQ ''>
<cfoutput>#oada.recordcount# <strong><span class="text-muted">Applicants</span></strong> for #tada.recordcount# <a href="/fam/icap/selections/?position=#positionq#"><strong>#positionq#</strong></a><strong><span class="text-muted">Positions</span></strong> in <a href="/fam/icap/selections/?area=#areaq#"><strong>#areaq#</strong></a> <strong><span class="text-muted">Area</span></strong></cfoutput>
<cfelseif  #areaq# NEQ ''>
<cfoutput>#oada.recordcount# <strong><span class="text-muted">Applicants</span></strong> for #tada.recordcount# <strong><span class="text-muted">Positions</span></strong> in <a href="/fam/icap/selections/?area=#areaq#"><strong>#areaq#</strong></a> <strong><span class="text-muted">Area</span></strong></cfoutput>
<cfelseif  #teamq# NEQ '' and #positionq# NEQ ''>
<cfoutput>#oada.recordcount# <strong><span class="text-muted">Applicants</span></strong> for #tada.recordcount# <a href="/fam/icap/selections/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Positions</span></strong> on <a href="/fam/icap/selections/?team=#teamq#"><strong>#teamq#</strong></a></cfoutput>
<cfelseif #teamq# NEQ ''>
<cfoutput>#oada.recordcount# <strong><span class="text-muted">Applicants</span></strong> for #tada.recordcount# <strong><span class="text-muted">Positions</span></strong> on <a href="/fam/icap/selections/?team=#teamq#"><strong>#teamq#</strong></a></cfoutput>
<cfelseif  #positionq# NEQ ''>
<cfoutput>#oada.recordcount# <strong><span class="text-muted">Applicants</span></strong> for #tada.recordcount# <a href="/fam/icap/selections/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Positions</span></strong></cfoutput>
<cfelseif  #userq# NEQ ''>
<cfoutput>#oada.recordcount# <strong><span class="text-muted">Applications</span></strong> for #tada.recordcount# <strong><span class="text-muted">Positions</span></strong> by <strong><span class="text-muted">User</span> <a href="/fam/icap/selections/?user=#userq#"><cfif #get_user.applicant_nameIII# NEQ "">#get_user.applicant_nameI# #get_user.applicant_nameII# #get_user.applicant_nameIII#<cfelse>NO NAME</cfif></strong></a></cfoutput>
<cfelseif #posidq# NEQ ''>
<cfoutput>#oada.recordcount# <strong><span class="text-muted">Applicants</span></strong> for #tada.recordcount# <strong><span class="text-muted">Positions</span></strong> with <a href="/fam/icap/selections/?posid=#posidq#"><strong><span class="text-muted">Position ID</span> #posidq#</strong></a></cfoutput>
<cfelse>
<cfoutput>#oada.recordcount# <strong><span class="text-muted">Applicants</span></strong> for #tada.recordcount# <strong><span class="text-muted">Positions</span></strong></cfoutput>
</cfif>
    <span class="form-inline pull-right">
    <span style='margin-right:10px;'>
    </span>
    <cfif #teamq# NEQ '' and #positionq# NEQ ''>
        <cfif #session.icap_role# EQ 'M' OR (#session.icap_role# EQ 'C' and #session.icap_area# EQ #get_area.icteam_area# ) OR (#session.icap_role# EQ 'I' and #session.icap_team# EQ #get_area.icteam_id#) >
        <form class="form-inline pull-right" name="reset_fm" action="/fam/icap/selections/?team=<cfoutput>#teamq#&position=#positionq#</cfoutput>" method="post" enctype="multipart/form-data">
        <input class="btn btn-warning btn-xs" type="submit" name="reset_fm" value="Reset!">
        <cfoutput query="FAMDB_user">
            <input class="hidden" type="hidden" name="user_webcaaf" value="#username#">
            <input class="hidden" type="hidden" name="user_firstname" value="#firstname#">
            <input class="hidden" type="hidden" name="user_lastname" value="#lastname#">
            <input class="hidden" type="hidden" name="user_email" value="#email#">
        </cfoutput>
            <input class="hidden" type="hidden" name="position_id" value="<cfoutput>#tada.position_id#</cfoutput>">
            <input class="hidden" type="hidden" name="icteam_id" value="<cfoutput>#tada.icteam_id#</cfoutput>">
            <input class="hidden" type="hidden" name="reset_all" value="">
        </form>
        </cfif>
    </cfif>
    </span>
</cfif>
</h3>
</div>
<div class="panel-body">
<cfoutput query="FAMDB_user">
        <cfif #icap_role# EQ 'M'>You are <strong>National Administrator</strong>, so the table below is not filtered. Applicant reports are availble from the <a href='/fam/icap/reports/'><strong>reports page</strong></a>.
        <cfelseif #icap_role# EQ 'C'>You are <strong>GACC Coordinator</strong> for <strong>#icap_area#</strong> Area, so the table below is filtered to show only <strong>#icap_area#</strong> Area positions and applications. Use the 'selection status' to select applicants into a position. Applicant reports are availble from the <a href='/fam/icap/reports/'><strong>reports page</strong></a>.
        <cfelseif #icap_role# EQ 'I'>You are <strong>Incident Commander</strong> for <strong>#icteam_name#</strong> Team, so the table below is filtered to show only <strong>#icap_area#</strong> Area positions and applications. Use the 'selection status' to select applicants into a position. Applicant reports are availble from the <a href='/fam/icap/reports/'><strong>reports page</strong></a>.
        <cfelseif #icap_role# EQ 'A'>The table below is filtered to show only your applications.
        <cfelseif #icap_role# EQ ''><strong>Blank user access -- request access to do better.</strong><br></cfif>
</cfoutput>
</div>
<table class="tablesorter table table-bordered table-condensed table-striped" id="s3">
<thead>
<cfoutput>
<th><span class="caret"></span>
</th>
<cfif len(aheads)>
    <cfloop list="#aheads#" index='head'>
    <cfif head NEQ '_'>
        <th data-sortable-col><small>#head#</small></th>
    </cfif>
    </cfloop>
 <cfelse>
    <cfloop list="#collist#" index='head'>
        <th data-sortable-col><small>#head#</small></th>
    </cfloop>
</cfif>
</cfoutput>
</thead>
<tbody>
<style>
div.c {
  size: 0.8em;
}
div.c label {
  font-size: 0.8em;
}
div.c input {
  font-size: 0.8em;
}
</style>
<cfoutput query="oada">
<tr class="<cfif position_status EQ 'Open' and application_valid EQ 'Y'>text-success<cfelseif position_status EQ 'Open' and application_valid EQ 'N'>text-success<cfelseif position_status EQ 'Closed' and application_valid EQ 'Y'>text-warning<cfelseif position_status EQ 'Closed' and application_valid EQ 'N'>text-warning</cfif> <cfif status NEQ ''>success</cfif>" role="tab" id="h_#position_applicant_id#">
<td>
<a role="button" data-toggle="collapse" data-parent="##accordion" href="##c_#position_applicant_id#" aria-expanded="true" aria-controls="c_#position_applicant_id#"><span class="caret"></span>
<div class="_#position_applicant_id#icon" style="width: 10px;height: 10px;border-radius: 50%;"></div>
</a>
</td>
<cfset n = 1>
<cfloop index="ca" list="#collist#">
<cfif len(aheads)>
    <cfset hd = #listgetat(aheads,n)#>
    <cfif hd NEQ '_'>
        <cfset rf = #listgetat(arefs,n)#>
        <cfif ca EQ 'position_status'>
            <td style='min-width:110px'><small>
            <a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'>Open</strong><cfelseif position_status EQ 'Closed'><strong class='text-warning'>Closed</strong></cfif></a>
            </small></td>
        <cfelseif ca EQ 'applicants'>
            <td style='text-align:right;'><small>
            <a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'>#oada[ca][currentRow]#</strong><cfelseif position_status EQ 'Closed'><strong class='text-warning'>#oada[ca][currentRow]#</strong></cfif></a>
            </small></td>
        <cfelseif ca EQ 'applications'>
            <td style='text-align:right;'><small>
            <a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'>#oada[ca][currentRow]#</strong><cfelseif position_status EQ 'Closed'><strong class='text-warning'>#oada[ca][currentRow]#</strong></cfif></a>
            </small></td>
         <cfelseif ca EQ 'status'>
            <td style='min-width:140px'><small>
            <cfif #session.icap_role# EQ 'M' OR (#session.icap_role# EQ 'C' and #session.icap_area# EQ #icteam_area# ) OR (#session.icap_role# EQ 'I' and #session.icap_team# EQ #icteam_id#) >
                <form class='form-inline' action="./?team=#icteam_name#&position=#position_code#" method="post">
                    <input class="hidden" type="hidden" name="position_id" value="#position_id#">
                    <input class="hidden" type="hidden" name="icteam_id" value="#icteam_id#">
                    <input class="hidden" type="hidden" name="application_id" value="#application_id#">
                    <select class="form-control input-sm" type="select" name="status">
                    <cfset statuslist = 'PRIMARY,ALTERNATE,SHARE,APPRENTICE,TRAINEE,REJECTED,WITHDRAWN' />
                    <cfif listfind(statuslist,#status#) EQ '0'><option value="" selected disabled></option></cfif>
                    <option value="" selected></option>
                    <option value="PRIMARY" <cfif #status# EQ 'PRIMARY'>selected</cfif>>PRIMARY</option>
                    <option value="ALTERNATE" <cfif #status# EQ 'ALTERNATE'>selected</cfif>>ALTERNATE</option>
                    <option value="SHARE" <cfif #status# EQ 'SHARE'>selected</cfif>>SHARE</option>
                    <option value="APPRENTICE" <cfif #status# EQ 'APPRENTICE'>selected</cfif>>APPRENTICE</option>
                    <option value="TRAINEE" <cfif #status# EQ 'TRAINEE'>selected</cfif>>TRAINEE</option>
                    <option value="REJECTED" <cfif #status# EQ 'REJECTED'>selected</cfif>>REJECTED</option>
                    <option value="WITHDRAWN" <cfif #status# EQ 'WITHDRAWN'>selected</cfif>>WITHDRAWN</option>
                    </select>
                    <input class="hidden" type="hidden" name="reset_one" value="">
                    <input class="btn btn-warning btn-xs pull-right" type="submit" name="status_fm" value="Set">
                </form>
             <cfelse>
                #status#
            </cfif>
            <cfquery name="apsels" datasource="ICAP_Prod" maxrows=90000  result="ar1">
                select t.icteam_name, p.position_id, p.position_code, ss.* from icap_applications aa left join icap_positions p on aa.position_id = p.position_id outer apply (select TOP 1 * from icap_positions_applicants q where q.position_id = p.position_id and q.applicant_id = aa.applicant_id order by q.updated desc) as q left join icap_teams t on p.icteam_id = t.icteam_id left join icap_applicants a on aa.applicant_id = a.applicant_id left outer join Region_6.dbo.login u on a.applicant_eauth_id = u.webcaaf_id left outer join Region_6.dbo.login uc on q.closed_by = uc.webcaaf_id left outer join Region_6.dbo.login uu on q.updated_by = uu.webcaaf_id left outer join Region_6.dbo.login uaa on aa.updated_by = uaa.webcaaf_id left outer join icap_positions_status s on p.position_id = s.position_id outer apply (select TOP 1 * from icap_selections ss where ss.position_id = p.position_id and ss.application_id = aa.application_id order by ss.status_date desc) as ss left outer join Region_6.dbo.login uss on ss.created_by = uss.webcaaf_id where a.applicant_eauth_id = '#applicant_eauth_id#' and ss.status <> '' and ss.status <> 'REJECTED' and ss.status <> 'WITHDRAWN' and p.position_id <> '#position_id#'
                <cfif #dateq# NEQ ''>
                and aa.updated >= cast(#dateq# as date)
                </cfif>
                order by t.icteam_name asc, position_code asc, q.updated desc, aa.updated desc
            </cfquery>
            <cfif #apsels.recordcount# NEQ 0>
                <cfloop query='apsels'><a href='/fam/icap/selections/?team=#icteam_name#&position=#position_code#'><span class='pull-left small'>#status#</span> <span class='pull-right small'>#icteam_name#</span></a><br></cfloop>
            </cfif>
            </small></td>
         <cfelseif rf NEQ '_'>
            <cfset rfx = rf>
            <cfset rbx = #listgetat(arebs,n)#>
            <td<cfif isNumeric(oada[ca][currentRow])> style='text-align:right;'</cfif>><small>
            <a href='/fam/#rbx##oada[rfx][currentRow]#'><cfif isDate(oada[ca][currentRow])><cfif hd CONTAINS 'fuel moisture'>#oada[ca][currentRow]#<cfelse>#dateformat(oada[ca][currentRow], 'yyyy-mm-dd')#</cfif><cfelseif ca EQ 'changed'>#tostring(oada[ca][currentrow])#<cfelse>#oada[ca][currentRow]#</cfif></a>
            </small></td>
         <cfelse>
            <td<cfif isNumeric(oada[ca][currentRow])> style='text-align:right;'</cfif>><small>
            <cfif isDate(oada[ca][currentRow])><cfif hd CONTAINS 'fuel moisture'>#oada[ca][currentRow]#<cfelse>#dateformat(oada[ca][currentRow], 'yyyy-mm-dd')#</cfif><cfelseif ca EQ 'changed'>#tostring(oada[ca][currentrow])#<cfelse>#oada[ca][currentRow]#</cfif>
            </small></td>
        </cfif>
    </cfif>
 <cfelse>
    <td<cfif isNumeric(oada[ca][currentRow])> style='text-align:right;'</cfif>><small>
    <cfif isDate(oada[ca][currentRow])><cfif hd CONTAINS 'fuel moisture'>#oada[ca][currentRow]#<cfelse>#dateformat(oada[ca][currentRow], 'yyyy-mm-dd')#</cfif><cfelseif ca EQ 'changed'>#tostring(oada[ca][currentrow])#<cfelse>#oada[ca][currentRow]#</cfif>
    </small></td>
</cfif>
<cfset n = n + 1>
</cfloop>
</tr>
<tr id="c_#position_applicant_id#" class="panel-collapse collapse" role="tabpanel" aria-labelledby="h_#position_applicant_id#">
<td class="_#position_applicant_id#bc">
</td>
<cfset n = 18>
<td colspan=#n#>
<div class='row'>
<div class='col-xs-4 col-sm-4 col-md-4 col-lg-4 c'>
<label>Position ID:</label>
<span class='pull-right'>#position_id#</span>
<br>
<label>Name:</label>
<span class='pull-right'><cfif #applicant_nameIII# NEQ "">#applicant_nameI# #applicant_nameII# #applicant_nameIII#<cfelse>#firstname# #lastname#</cfif></span>
<br>
<label>IQCS:</label>
<span class='pull-right'>#applicant_IQCS#</span>
<br>
<label>AD/EFF:</label>
<span class='pull-right'>#applicant_retired#</span>
<br>
<label>Agency:</label>
<span class='pull-right'>
<cfif #applicant_fq_email_type# EQ "">
    #applicant_agency#
<cfelse>
    <cfif #applicant_fq_email_type# EQ "FED">
Federal agency
    <cfelseif #applicant_fq_email_type# EQ "WA_s">
Washington state
    <cfelseif #applicant_fq_email_type# EQ "WA_c">
Washington county
    <cfelseif #applicant_fq_email_type# EQ "WA_r">
Washington rural fire district
    <cfelseif #applicant_fq_email_type# EQ "OR_s">
Oregon state
    <cfelseif #applicant_fq_email_type# EQ "OR_c">
Oregon county
    <cfelseif #applicant_fq_email_type# EQ "OR_r">
Oregon rural fire district
    <cfelse>
#applicant_fq_email_type#
    </cfif>
</cfif>
</span>
<br>
<label>Agency address:</label>
<span class='pull-right'>#applicant_agency_address#</span>
<br>
<label>Dispatch agency:</label>
<span class='pull-right'>#applicant_dispatch_agency#</span>
<br>
<label>Agreement holder agency:</label>
#applicant_agreement_holder_agency#
<br>
<label>State of residence:</label>
<span class='pull-right'>#applicant_jet_port#</span>
<br>
</div>
<div class='col-xs-4 col-sm-4 col-md-4 col-lg-4 c'>
<label>Applicant City:</label>
<span class='pull-right'>#applicant_city#</span>
<br>
<label>Applicant State:</label>
<span class='pull-right'>#applicant_area#</span>
<br>
<label>Applicant Zip:</label>
<span class='pull-right'>#applicant_zip_code#</span>
<br>
<label>Applicant Country:</label>
<span class='pull-right'>#applicant_country#</span>
<br>
<label>Email:</label>
<span class='pull-right'><cfif #applicant_email_address# NEQ "">#applicant_email_address#<cfelse>#email#</cfif></span>
<br>
<label>Work phone:</label>
<span class='pull-right'>#applicant_work_phone#</span>
<br>
<label>Home phone:</label>
<span class='pull-right'>#applicant_home_phone#</span>
<br>
<label>Cell phone:</label>
<span class='pull-right'>#applicant_cell_phone#</span>
<br>
<label>Pager:</label>
<span class='pull-right'>#applicant_pager_number#</span>
<br>
<label>Dispatch phone:</label>
<span class='pull-right'>#applicant_dispatch_phone#</span>
<br>
<label>Fax:</label>
<span class='pull-right'>#applicant_fax_phone#</span>
<br>
</div>
<div class='col-xs-4 col-sm-4 col-md-4 col-lg-4 c'>
<cfquery name="check_files" datasource="ICAP_Prod">
select attachment_name,attachment_added,attachment_original_size from icap_attachments where applicant_id = #applicant_id#
</cfquery>
        <table class='table table-condensed table-bordered small'>
        <thead>
            <tr style='background:Gainsboro;'>
              <th colspan='2'>File Uploads</th>
            </tr>
        </thead>
        <tbody>
        <tr>
            <th>file</th>
            <th>date</th>
        </tr>
        <cfif #check_files.recordcount# NEQ 0>
            <cfloop query="check_files">
            <tr>
            <td><a href="http://162.79.30.150/ICAP/#attachment_name#" target="_blank">#attachment_name#</a></td>
            <td><span class='pull-right'>#attachment_added#</span></td>
            </tr>
            </cfloop>
        <cfelse>
        <tr>
        NO FILES ATTACHED
        </tr>
        </cfif>
        </tbody>
        </table>
<br>
</div>
</div>
<div class='row'>
<div class='col-xs-4 col-sm-4 col-md-4 col-lg-4 c'>
    <label>Qualifications:</label>
    <span class='pull-right'>#applicant_qualifications#</span>
</div>
<div class='col-xs-4 col-sm-4 col-md-4 col-lg-4 c'>
    <label>Supplemental:</label>
    <span class='pull-right'>#application_qualifications#</span>
</div>
</div>
</td>
</tr>
</cfoutput>
</tbody>
</table>
<div class="panel-footer small">
<cfoutput query="FAMDB_user">
    <cfif #icap_role# EQ 'M'>You are <strong>National Administrator</strong>, so the table above is not filtered.
    <cfelseif #icap_role# EQ 'C'>You are <strong>GACC Coordinator</strong> for <strong>#icap_area#</strong> Area, so the table above is filtered to show only <strong>#icap_area#</strong> Area positions and applications.
    <cfelseif #icap_role# EQ 'I'>You are <strong>Incident Commander</strong> for <strong>#icteam_name#</strong> Team, so the table above is filtered to show only <strong>#icap_area#</strong> Area positions and applications.
    <cfelseif #icap_role# EQ 'A'>The table above is filtered to show only your applications.
    <cfelseif #icap_role# EQ ''><strong>Blank user access -- request access to do better.</strong><br></cfif>
</cfoutput>
</div>
</div>
</cfif>
<cfif #userq# NEQ ''>
<cfset roles = "M,C,I">
<cfif ListFindNoCase(roles,'#FAMDB_user.icap_role#') GT 0>
<cfquery name="pna" datasource="ICAP_Prod">
select t.icteam_id,t.icteam_area,t.icteam_name,p.position_id,p.position_code,p.position_title,s.position_status from icap_positions p left join icap_teams t on p.icteam_id = t.icteam_id left outer join icap_positions_status s on p.position_id = s.position_id <cfif #famdb_user.icap_role# EQ 'C'>where t.icteam_area = '#famdb_user.icap_area#'<cfelseif #famdb_user.icap_role# EQ 'I'>where t.icteam_name = '#famdb_user.icteam_name#'</cfif>
</cfquery>
    <div>
        <table class="tablesorter table table-condensed table-bordered table-striped small" id="p1">
        <thead>
            <th class='info' colspan=3>Click a position below to add an application to that position for <cfif #get_user.applicant_nameIII# NEQ ""><cfoutput>#get_user.applicant_nameI# #get_user.applicant_nameII# #get_user.applicant_nameIII#</cfoutput><cfelse>this NO NAME applicant</cfif></th>
        </thead>
        <tbody>
    <cfloop query="pna">
        <cfoutput>
        <tr>
            <td><a href="/fam/icap/positions/?pos=#position_id#&add_special=#userq#&con=">#icteam_name#</a></td>
            <td><a href="/fam/icap/positions/?pos=#position_id#&add_special=#userq#&con=">#position_code#</a></td>
            <td><a href="/fam/icap/positions/?pos=#position_id#&add_special=#userq#&con=">#position_title#</a></td>
        </tr>
        </cfoutput>
    </cfloop>
        </tbody>
        </table>
    </div>
</cfif>
</cfif>
</div>
<cfinclude template="/fam/gutter.cfm">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.28.15/js/jquery.tablesorter.min.js"></script>
  <script type="text/javascript" id="js">
      $("table").tablesorter();
  </script>
  </body>
</html>