<cfinclude template="/fam/icap/use.cfm">
<cfset roles = "M,C,I">
<cfif ListFindNoCase(roles,'#FAMDB_user.icap_role#') GT 0>
<cfset areaq = ''>
<cfset teamq = ''>
<cfset positionq = ''>
<cfset userq = ''>
<cfif #cgi.query_string# NEQ '' >
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
<cfif '#FAMDB_user.icap_role#' EQ 'A'>
<cfset userq = '#FAMDB_user.username#'>
<cfelse>
<cfset userq = REReplaceNoCase(cgi.query_string, "user=", "") />
<cfset userq = REReplace(userq,"%20"," ","all")>
</cfif>
</cfif>
</cfif>
<cfquery name='get_team' datasource="ICAP_Prod" maxrows=90000>
select t.icteam_name, t.icteam_area from icap_teams t where t.icteam_name = '#teamq#'
</cfquery>
<cfset fa = '#get_team.icteam_area#'>
<cfif #cgi.query_string# NEQ '' >
<cfif #cgi.query_string# CONTAINS 'reno='>
<cfset teamq = REReplaceNoCase(cgi.query_string, "reno=", "") />
<cfset teamq = REReplace(teamq,"%20"," ","all")>
<cfquery name='reno' datasource='ICAP_Prod'>
select * from dbo.icap_applications aa left join icap_positions p on aa.position_id = p.position_id outer apply (select TOP 1 * from icap_positions_applicants q where q.position_id = p.position_id and q.applicant_id = aa.applicant_id order by q.updated desc) as q left join icap_teams t on p.icteam_id = t.icteam_id where t.icteam_name = '#teamq#'
</cfquery>
<cfloop query='reno' >
<cfquery name='notified' datasource='ICAP_Prod' result='renod'>
update dbo.icap_applications set notified_at = NULL, notified_as = NULL where application_id = #application_id#
</cfquery>
</cfloop>
<cfdump var='#renod#'><cfabort>
</cfif>
</cfif>
<cfif #cgi.query_string# NEQ ''>
<cfif #cgi.query_string# CONTAINS 'date='>
<cfset dateq = Right( cgi.query_string, 16) />
<cfset dateq = Right( dateq, 10) />
<cfset qyyyy = listFirst(dateq, "-") />
<cfset qmm = listGetAt(dateq, 2, "-") /> 
<cfset qdd = listLast(dateq, "-") />
<cfset dateq = createdate(qyyyy,qmm,qdd)>
<cfelseif #fa# EQ 'California'>
<cfset dateq = createdate(2016,10,01)>
<cfelseif #fa# EQ 'PNW'>
<cfset dateq = createdate(2016,09,30)>
<cfelseif #fa# EQ 'Southwest'>
<cfset dateq = createdate(2016,11,01)>
<cfelseif #fa# EQ 'Great Basin'>
<cfset dateq = createdate(2016,11,27)>
<cfelse>
<cfset dateq = createdate(2016,01,01)>
</cfif>
<cfelseif #fa# EQ 'California'>
<cfset dateq = createdate(2016,10,01)>
<cfset oa = 'no'>
<cfelseif #fa# EQ 'PNW'>
<cfset dateq = createdate(2016,09,30)>
<cfset oa = 'no'>
<cfelseif #fa# EQ 'Southwest'>
<cfset dateq = createdate(2016,11,01)>
<cfset oa = 'no'>
<cfelseif #fa# EQ 'Great Basin'>
<cfset dateq = createdate(2016,11,27)>
<cfset oa = 'no'>
<cfelse>
<cfset dateq = createdate(2016,01,01)>
<cfset oa = 'no'>
</cfif>
<cfquery name='get_team_applications' datasource="ICAP_Prod" maxrows=90000>
select distinct t.icteam_name,p.position_title,p.position_code,s.position_status,a.applicant_namei,a.applicant_nameii,a.applicant_nameiii,a.applicant_agency,a.applicant_gaac_type,a.applicant_gaac_typeI,a.applicant_email_address,a.applicant_IQCS,a.applicant_retired,aa.application_curr_year,a.applicant_ao_allowed,ss.status,ss.status_date,q.applicant_type,t.icteam_area,a.applicant_city,a.applicant_area,a.applicant_zip_code,aa.application_valid,a.applicant_fq_email_type,aa.application_id from icap_applications aa left join icap_positions p on aa.position_id = p.position_id outer apply (select TOP 1 * from icap_positions_applicants q where q.position_id = p.position_id and q.applicant_id = aa.applicant_id order by q.updated desc) as q left join icap_teams t on p.icteam_id = t.icteam_id left join icap_applicants a on aa.applicant_id = a.applicant_id left outer join Region_6.dbo.login u on a.applicant_eauth_id = u.webcaaf_id left outer join Region_6.dbo.login uc on q.closed_by = uc.webcaaf_id left outer join Region_6.dbo.login uu on q.updated_by = uu.webcaaf_id left outer join Region_6.dbo.login uaa on aa.updated_by = uaa.webcaaf_id left outer join icap_positions_status s on p.position_id = s.position_id outer apply (select TOP 1 * from icap_selections ss where ss.position_id = p.position_id and ss.application_id = aa.application_id order by ss.status_date desc) as ss
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
where p.position_code like '%#session.q#%'
</cfif>
<cfif #dateq# NEQ ''>
and ss.status_date >= cast(#dateq# AS DATE)
</cfif>
and ss.status <> '' and notified_at is null and ss.status <> 'REJECTED' and ss.status <> 'WITHDRAWN' order by t.icteam_name ASC, position_code ASC
</cfquery>
<cfloop query='get_team_applications' >
<cfif #applicant_email_address# NEQ "" >
<cfmail from="fireportal@usda.gov" to="#applicant_email_address#" subject="Selection status for #icteam_name# #position_title#" type="html">
*** DO NOT REPLY ***<br/>
<br/>
This email is generated by the Incident Command Application Program, developed by the USDA Forest Service to support recruitment and selection of Incident Management Team positions.<br/>
<br/>
<b>You have been selected.</b><br>
<br>
Team: #icteam_name#<br/>
Position: #position_title# (#position_code#)<br/>
Selection: #status#<br/>
<br/>
You will be contacted by the Incident Commander with any change of status to your application.
</cfmail>
<cfquery name='notified' datasource='ICAP_Prod'>
update dbo.icap_applications set notified_at = '#today#', notified_as = '#status#' where application_id = #application_id#
</cfquery>
<cfoutput>
 #applicant_namei# #applicant_nameii# #applicant_nameiii# (#applicant_email_address#) - #icteam_name# - #position_title# (#position_code#) - #status#<br/>
</cfoutput>
</cfif>
</cfloop>
<cfset msg_text = "#get_team_applications.recordcount# notifications sent for <a class=""alert-link"" href=""/fam/icap/selections/?team=#teamq#"">#teamq#</a>.">
<cfset msg_maxwid = '880px'>
<cfset msg_status = "success">
<cfinclude template="/fam/lo.cfm">
</cfif>
<cfinclude template="/fam/gutter.cfm">
</body>
</html>