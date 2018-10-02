<cfset StructClear(session)>
<cfset session.user_webcaaf = getHttpRequestData().headers["usdaeauthid"]>
<cfset session.user_email = getHttpRequestData().headers["usdaemail"]>
<cfset session.user_lastname = getHttpRequestData().headers["usdalastname"]>
<cfset session.user_firstname = getHttpRequestData().headers["usdafirstname"]>
<cfquery name="FAMDB_user" datasource="FAMDB" maxrows=1>
select u.*,t.icteam_name,t.icteam_area,a.applicant_gaac_type from dbo.users u left join icap_teams t on u.icap_team = t.icteam_id left outer join ICAP_Prod.dbo.icap_applicants a on u.username = a.applicant_eauth_id where u.username = '#session.user_webcaaf#'
</cfquery>
<cfif #FAMDB_user.recordcount# EQ 1>
<cfset session.admin = '#FAMDB_user.admin#'>
<cfif FAMDB_user.icap_admin EQ 1>
<cfset session.icap_admin = '1'>
<cfset session.icap_use = '1'>
<cfelseif FAMDB_user.icap_use EQ 'Y'>
<cfset session.icap_admin = ''>
<cfset session.icap_use = '1'>
<cfelse>
<cfset session.icap_admin = ''>
<cfset session.icap_use = '1'>
</cfif>
<cfset session.icap_role = #FAMDB_user.icap_role#>
<cfset session.icap_area = #FAMDB_user.icap_area#>
<cfset session.icap_team = #FAMDB_user.icap_team#>
<cfelse>
<cflocation url="/fam/">
</cfif>
<cfif session.icap_role EQ ''>
<cfset session.icap_role = 'A'>
</cfif>

<cfset today = '#DateFormat(now(),"mm/dd/yyyy")# #TimeFormat(now(),"hh:mm:ss tt")#'>
<cfset caw = "icap">
<cfset cos = "N,C,I">
<cfif ListFindNoCase(cos,'#FAMDB_user.icap_role#') GT 0>
	<cfset barn = "<a href='/fam/icap/' style='color:white;'>icap</a>
	<a href='/fam/icap/applicant/' style='color:red;'>step 1: applicant</a>
	<a href='/fam/icap/positions/' style='color:orange;'>step 2: positions</a>
	<a href='/fam/icap/selections/' style='color:limegreen;'>selections</a>
	">
<cfelse>
	<cfset barn = "<a href='/fam/icap/' style='color:white;'>icap</a>
	<a href='/fam/icap/applicant/' style='color:red;'>step 1: applicant</a>
	<a href='/fam/icap/positions/' style='color:orange;'>step 2: positions</a>
	">
</cfif>