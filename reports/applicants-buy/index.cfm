<cfinclude template="/fam/icap/use.cfm">

<cfinclude template="/fam/lo.cfm">

<cfif isdefined('q')>
    <cfset session.q = #q#>
 <cfelse>
    <cfset session.q = ''>
</cfif>

<cfif #session.icap_role# EQ 'C'>
    <cfset fa = #session.icap_area#>
    <cfset ft = ''>
    <cfset fu = ''>
</cfif>

<cfif #session.icap_role# EQ 'I'>
    <cfset fa = #session.icap_area#>
    <cfset ft = ''>
    <cfset fu = ''>
</cfif>

<cfif #session.icap_role# EQ 'A'>
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
    VADA + OADA (single position plus position applicants by /?id - temp disabled by the posidq EQ '' above)
 <cfelse>
    <!--TADA + OADA (all positions plus position applicants) -->
    <cfset cols = 'p.icteam_id,t.icteam_name,t.icteam_area,p.position_id,p.position_code,p.updated,p.updated_by,pu.email_address as puemail,s.position_status,s.updated as supdated,s.updated_by as supdated_by,su.email_address as suemail,<cfif #dateq# NEQ ''>count(DISTINCT(case when aa.updated >= CAST(#dateq# AS DATE) then aa.applicant_id end))<cfelse>count(DISTINCT aa.applicant_id)</cfif> as applicants,<cfif #dateq# NEQ ''>count(DISTINCT(case when aa.updated >= CAST(#dateq# AS DATE) then aa.application_id end))<cfelse>count(DISTINCT aa.application_id)</cfif> as applications,oo.status_date,oo.status'>

    <cfif #teamq# NEQ '' and #positionq# NEQ ''>
        <cfset heads = '_,_,_,_,_,position updated,_,position updated by,position status,status updated,_,status updated by,applicant count,application count,status date,status'>
     <cfelseif #teamq# NEQ '' and #positionq# EQ ''>
        <cfset heads = '_,_,_,_,position code,position updated,_,position updated by,position status,status updated,_,status updated by,applicant count,application count,status date,status'>
     <cfelseif #teamq# EQ '' and #positionq# NEQ ''>
        <cfset heads = '_,team name,_,_,_,position updated,_,position updated by,position status,status updated,_,status updated by,applicant count,application count,status date,status'>
     <cfelse>
        <cfset heads = '_,team name,_,_,position code,position updated,_,position updated by,position status,status updated,_,status updated by,applicant count,application count,status date,status'>
    </cfif>

    <cfset refs = 'icteam_id,icteam_name,_,position_id,position_code,_,updated_by,puemail,_,_,supdated_by,suemail,_,_,_,_'>

    <cfset rebs = 'p.icteam_id,icap/selections/?team=,_,p.position_id,icap/selections/?position=,p.updated,p.updated_by,users/?,s.position_status,s.updated as supdated,s.updated_by as supdated_by,users/?,count(DISTINCT q.applicant_id) as applicants,count(DISTINCT aa.application_id) as applications,_,_'>

    <cfquery name="tada" datasource="ICAP_Prod" maxrows=9000>
    SELECT p.icteam_id,t.icteam_name,t.icteam_area,p.position_id,p.position_code,p.updated,p.updated_by,pu.email_address as puemail,s.position_status,s.updated as supdated,s.updated_by as supdated_by,su.email_address as suemail,
    <cfif #dateq# NEQ ''>
        count(DISTINCT(case when aa.updated >= CAST(#dateq# AS DATE) then aa.applicant_id end))
     <cfelse>
        count(DISTINCT aa.applicant_id)
    </cfif> as applicants,
    <cfif #dateq# NEQ ''>
        count(DISTINCT(case when aa.updated >= CAST(#dateq# AS DATE) then aa.application_id end))
     <cfelse>
        count(DISTINCT aa.application_id)
    </cfif> as applications,oo.status_date,oo.status
    FROM icap_positions p
    LEFT JOIN icap_teams t
    ON p.icteam_id = t.icteam_id
    LEFT OUTER JOIN Region_6.dbo.login pu
    ON p.updated_by = pu.webcaaf_id
    LEFT OUTER JOIN icap_positions_status s
    ON p.position_id = s.position_id
    LEFT OUTER JOIN Region_6.dbo.login su
    ON s.updated_by = su.webcaaf_id
    LEFT OUTER JOIN icap_positions_applicants q
    ON p.position_id = q.position_id
    LEFT OUTER JOIN icap_applicants a
    ON q.applicant_id = a.applicant_id
    LEFT OUTER JOIN Region_6.dbo.login au
    ON a.applicant_eauth_id = au.webcaaf_id
    LEFT OUTER JOIN icap_applications aa
    ON p.position_id = aa.position_id
    OUTER APPLY (SELECT TOP 1 * 
    FROM icap_openings oo
    WHERE oo.position_id = p.position_id
    ORDER BY oo.status_date DESC) as oo
    <cfif #areaq# NEQ '' and #positionq# NEQ ''>
        where t.icteam_area = '#areaq#'
        and p.position_code = '#positionq#'
     <cfelseif  #areaq# NEQ ''>
        where t.icteam_area = '#areaq#'
     <cfelseif  #teamq# NEQ '' and #positionq# NEQ ''>
        where t.icteam_name = '#teamq#'
        and p.position_code = '#positionq#'
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
        and aa.updated >= CAST(#dateq# AS DATE)
    </cfif>
    and p.position_code in ('BUYL','BUYM')
    GROUP BY p.position_id,p.position_code,p.icteam_id,t.icteam_name,t.icteam_area,p.updated,p.updated_by,pu.email_address,s.position_status,s.updated,s.updated_by,su.email_address,oo.status,oo.status_date
    ORDER BY t.icteam_name ASC, position_code ASC
    </cfquery>

    <cfif #posidq# NEQ '' and #tada.recordcount# EQ 0>
        <cfquery name="tada" datasource="ICAP_Prod" maxrows=9000>
        SELECT p.icteam_id,t.icteam_name,t.icteam_area,p.position_id,p.position_code,p.updated,p.updated_by,pu.email_address as puemail,s.position_status,s.updated as supdated,s.updated_by as supdated_by,su.email_address as suemail,count(DISTINCT q.applicant_id) as applicants,count(DISTINCT aa.application_id) as applications,oo.status_date,oo.status
        FROM icap_positions p
        LEFT JOIN icap_teams t
        ON p.icteam_id = t.icteam_id
        LEFT OUTER JOIN Region_6.dbo.login pu
        ON p.updated_by = pu.webcaaf_id
        LEFT OUTER JOIN icap_positions_status s
        ON p.position_id = s.position_id
        LEFT OUTER JOIN Region_6.dbo.login su
        ON s.updated_by = su.webcaaf_id
        LEFT OUTER JOIN icap_positions_applicants q
        ON p.position_id = q.position_id
        LEFT OUTER JOIN icap_applicants a
        ON q.applicant_id = a.applicant_id
        LEFT OUTER JOIN Region_6.dbo.login au
        ON a.applicant_eauth_id = au.webcaaf_id
        LEFT OUTER JOIN icap_applications aa
        ON p.position_id = aa.position_id
        OUTER APPLY (SELECT TOP 1 * 
                     FROM icap_openings oo
                     WHERE oo.position_id = p.position_id
                     ORDER BY oo.status_date DESC) as oo
        where p.position_id = '#posidq#'
        <cfif #session.icap_role# EQ 'C'>
            and t.icteam_area = '#fa#'
        </cfif>
        <cfif #session.icap_role# EQ 'I'>
            and t.icteam_area = '#fa#'
        </cfif>
        <cfif #session.icap_role# EQ 'A'>
            and a.applicant_eauth_id = '#fu#'
        </cfif>
        <cfif #dateq# NEQ ''>
            and aa.updated >= CAST(#dateq# AS DATE)
        </cfif>
        and p.position_code in ('BUYL','BUYM')
        GROUP BY p.icteam_id,t.icteam_name,t.icteam_area,p.position_id,p.position_code,p.updated,p.updated_by,pu.email_address,s.position_status,s.updated,s.updated_by,su.email_address,oo.status,oo.status_date
        ORDER BY t.icteam_name ASC, position_code ASC
        </cfquery>
    </cfif>

    <cfif #areaq# NEQ '' or #teamq# NEQ '' or #positionq# NEQ '' or #userq# NEQ '' or #posidq# NEQ '' or #session.q# NEQ '' or #dateq# NEQ ''>
        <cfset ca = 'q.icteam_id,t.icteam_name,t.icteam_area,position_applicant_id,q.position_id,p.position_code,s.position_status,q.applicant_id,a.applicant_eauth_id,a.applicant_namei,a.applicant_nameii,a.applicant_nameiii,a.applicant_IQCS,q.applicant_type,q.applicant_valid,q.closed,q.closed_by,ucemail,q.updated,q.updated_by,uuemail,aa.application_consideration,aa.application_accept_deny,aa.application_valid,aa.updated as aaupdated,aa.updated_by as aaupdated_by,uaa.email_address as uaaemail,a.applicant_retired,a.applicant_fq_email_type,a.applicant_agency_address,a.applicant_city,a.applicant_country,a.applicant_area,a.applicant_zip_code,a.applicant_dispatch_agency,a.applicant_agreement_holder_agency,a.applicant_email_address,a.applicant_work_phone,a.applicant_home_phone,a.applicant_cell_phone,a.applicant_pager_number,a.applicant_dispatch_phone,a.applicant_fax_phone,a.applicant_jet_port,a.applicant_weight,a.applicant_agency,ss.status_date,ss.status,aa.application_id'>

<cfset colss = 'Team,Position applied,Position code,Position current,Applicant First,Applicant Middle,Applicant Last,Applicant Agency,Dispatch Office,Applicant Email,Applicant IQCS,AD/EFF,Current Year,Supervisor Approval,Selected/Not Selected,App. Type,IC Status,Area,Cell Phone,Work Phone,Home Phone,Mailing Address,City,State,Zip,Date'>

<cfset ca = 't.icteam_name,p.position_title,p.position_code,s.position_status,a.applicant_namei,a.applicant_nameii,a.applicant_nameiii,a.applicant_id,a.applicant_agency,a.applicant_gaac_type,a.applicant_gaac_typeI,a.applicant_email_address,a.applicant_IQCS,a.applicant_retired,aa.application_curr_year,a.applicant_ao_allowed,ss.status,q.applicant_type,aa.application_consideration,t.icteam_area,a.applicant_cell_phone,a.applicant_work_phone,a.applicant_home_phone,a.applicant_agency_address,a.applicant_city,a.applicant_area,a.applicant_zip_code,aa.updated as aaupdated,aa.application_valid,a.applicant_fq_email_type'>


        <cfif #teamq# NEQ '' and #positionq# NEQ ''>
            <cfquery name="get_area" datasource="ICAP_Prod" maxrows=1>
            SELECT icteam_area, icteam_id
            from icap_teams
            where icteam_name = '#teamq#'
            </cfquery>
            <cfset aheads = 'Team,Position,Code,_,First,Middle,Last,ID,Applicant Agency,Area,Dispatch Office,Email,IQCS,AD/EFF,Application Year,Supervisor Approval,Selected/Not Selected,Type,IC Status,Area,Cell Phone,Work Phone,Home Phone,Mailing Address,City,State,Zip,Date,_,_'>
         <cfelseif #teamq# NEQ '' and #positionq# EQ ''>
            <cfquery name="get_area" datasource="ICAP_Prod" maxrows=1>
            SELECT icteam_area, icteam_id
            from icap_teams
            where icteam_name = '#teamq#'
            </cfquery>
            <cfset aheads = 'Team,Position,Code,_,First,Middle,Last,ID,Applicant Agency,Area,Dispatch Office,Email,IQCS,AD/EFF,Application Year,Supervisor Approval,Selected/Not Selected,Type,IC Status,Area,Cell Phone,Work Phone,Home Phone,Mailing Address,City,State,Zip,Date,_,_'>
         <cfelseif #teamq# EQ '' and #positionq# NEQ ''>
            <cfset aheads = 'Team,Position,Code,_,First,Middle,Last,ID,Applicant Agency,Area,Dispatch Office,Email,IQCS,AD/EFF,Application Year,Supervisor Approval,Selected/Not Selected,Type,IC Status,Area,Cell Phone,Work Phone,Home Phone,Mailing Address,City,State,Zip,Date,_,_'>
         <cfelseif #userq# NEQ ''>
            <cfquery name="get_user" datasource="ICAP_Prod">
            SELECT applicant_namei,applicant_nameii,applicant_nameiii
            from icap_applicants
            where applicant_eauth_id = '#userq#'
            </cfquery>
            <cfset aheads = 'Team,Position,Code,_,First,Middle,Last,ID,Applicant Agency,Area,Dispatch Office,Email,IQCS,AD/EFF,Application Year,Supervisor Approval,Selected/Not Selected,Type,IC Status,Area,Cell Phone,Work Phone,Home Phone,Mailing Address,City,State,Zip,Date,_,_'>
         <cfelse>
            <cfset aheads = 'Team,Position,Code,_,First,Middle,Last,ID,Applicant Agency,Area,Dispatch Office,Email,IQCS,AD/EFF,Application Year,Supervisor Approval,Selected/Not Selected,Type,IC Status,Area,Cell Phone,Work Phone,Home Phone,Mailing Address,City,State,Zip,Date,_,_'>
        </cfif>

        <cfset arefs = 'icteam_name,position_title,position_code,_,applicant_namei,applicant_nameii,applicant_nameiii,applicant_id,applicant_agency,applicant_gaac_type,applicant_gaac_typeI,applicant_email_address,applicant_IQCS,applicant_retired,application_curr_year,applicant_ao_allowed,status,applicant_type,applicant_type,icteam_area,applicant_cell_phone,applicant_work_phone,applicant_home_phone,applicant_agency_address,applicant_city,applicant_area,applicant_zip_code,aaupdated,_,_'>

        <cfset arefs = '_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_'>

        <cfset arebs = 't.icteam_name,p.position_title,p.position_code,_,a.applicant_namei,a.applicant_nameii,a.applicant_nameiii,a.applicant_id,a.applicant_agency,a.applicant_gaac_type,a.applicant_gaac_typeI,a.applicant_email_address,a.applicant_IQCS,a.applicant_retired,aa.application_curr_year,a.applicant_ao_allowed,ss.status,q.applicant_type,q.applicant_type,t.icteam_area,a.applicant_cell_phone,a.applicant_work_phone,a.applicant_home_phone,a.applicant_agency_address,a.applicant_city,a.applicant_area,a.applicant_zip_code,aa.updated as aaupdated,_,_'>

        <cfquery name="oada" datasource="ICAP_Prod" maxrows=90000>
        SELECT t.icteam_name,p.position_title,p.position_code,s.position_status,a.applicant_namei,a.applicant_nameii,a.applicant_nameiii,a.applicant_id,a.applicant_agency,a.applicant_gaac_type,a.applicant_gaac_typeI,a.applicant_email_address,a.applicant_IQCS,a.applicant_retired,aa.application_curr_year,a.applicant_ao_allowed,ss.status,q.applicant_type,aa.application_consideration,t.icteam_area,a.applicant_cell_phone,a.applicant_work_phone,a.applicant_home_phone,a.applicant_agency_address,a.applicant_city,a.applicant_area,a.applicant_zip_code,aa.updated as aaupdated,aa.application_valid,a.applicant_fq_email_type
        FROM icap_applications aa
        LEFT JOIN icap_positions p
        ON aa.position_id = p.position_id
        OUTER APPLY (SELECT TOP 1 * 
                     FROM icap_positions_applicants q
                     WHERE q.position_id = p.position_id
                     AND q.applicant_id = aa.applicant_id
                     ORDER BY q.updated DESC) as q
        LEFT JOIN icap_teams t
        ON p.icteam_id = t.icteam_id
        LEFT JOIN icap_applicants a
        ON aa.applicant_id = a.applicant_id
        LEFT OUTER JOIN Region_6.dbo.login u
        ON a.applicant_eauth_id = u.webcaaf_id 
        LEFT OUTER JOIN Region_6.dbo.login uc
        ON q.closed_by = uc.webcaaf_id 
        LEFT OUTER JOIN Region_6.dbo.login uu
        ON q.updated_by = uu.webcaaf_id
        LEFT OUTER JOIN Region_6.dbo.login uaa
        ON aa.updated_by = uaa.webcaaf_id
        LEFT OUTER JOIN icap_positions_status s
        ON p.position_id = s.position_id
        OUTER APPLY (SELECT TOP 1 * 
                     FROM icap_selections ss
                     WHERE ss.position_id = p.position_id
                     AND ss.application_id = aa.application_id
                     ORDER BY ss.status_date DESC) as ss
        <cfif #areaq# NEQ '' and #positionq# NEQ ''>
            where t.icteam_area = '#areaq#'
            and p.position_code = '#positionq#'
         <cfelseif  #areaq# NEQ ''>
            where t.icteam_area = '#areaq#'
         <cfelseif  #teamq# NEQ '' and #positionq# NEQ ''>
            where t.icteam_name = '#teamq#'
            and p.position_code = '#positionq#'
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
            and aa.updated >= CAST(#dateq# AS DATE)
        </cfif>
        and p.position_code in ('BUYL','BUYM')
        ORDER BY t.icteam_name ASC, position_code ASC, q.updated DESC, aa.updated DESC
        </cfquery>
    </cfif>
</cfif>

<div class="" style="padding-right:20px;">

<cfif isDefined('tada') and not isDefined('oada')>
<cfset cols = getMetadata(tada)>
<cfset colList = "">
<cfloop from="1" to="#arrayLen(cols)#" index="x"> <cfset colList = listAppend(colList, cols[x].name)> </cfloop>

<div class="panel panel-info" style="max-width:none;">
<div class="panel-heading">
<h3 class="panel-title">
<cfif #areaq# NEQ '' and #positionq# NEQ ''>
<cfoutput>#tada.recordcount# <a href="/fam/icap/selections/?position=#positionq#"><strong>#positionq#</strong></a> <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a> in <a href="/fam/icap/selections/?area=#areaq#"><strong>#areaq#</strong></a> <strong><span class="text-muted">Area</span></strong></cfoutput>
<cfelseif  #areaq# NEQ ''>
<cfoutput>#tada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a> in <a href="/fam/icap/selections/?area=#areaq#"><strong>#areaq#</strong></a> <strong><span class="text-muted">Area</span></strong></cfoutput>
<cfelseif  #teamq# NEQ '' and #positionq# NEQ ''>
<cfoutput>#tada.recordcount# <a href="/fam/icap/selections/?position=#positionq#"><strong>#positionq#</strong></a> <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a> on <a href="/fam/icap/selections/?team=#teamq#"><strong>#teamq#</strong></a> <strong><span class="text-muted">Team</span></strong></cfoutput>
<cfelseif #teamq# NEQ ''>
<cfoutput>#tada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a> on <a href="/fam/icap/selections/?team=#teamq#"><strong>#teamq#</strong></a> <strong><span class="text-muted">Team</span></strong></cfoutput>
<cfelseif #positionq# NEQ ''>
<cfoutput>#tada.recordcount# <a href="/fam/icap/selections/?position=#positionq#"><strong>#positionq#</strong></a> <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a></cfoutput>
<cfelseif #userq# NEQ ''>
<cfoutput>#tada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a> with <a href="/fam/icap/selections/"><strong><span class="text-muted">Applications</span></strong></a> by <a href="/fam/icap/selections/?user=#userq#"><strong><span class="text-muted">User</span> #get_user.applicant_namei# #get_user.applicant_nameii# #get_user.applicant_nameiii#</strong></a></cfoutput>
<cfelseif #posidq# NEQ ''>
<cfoutput>#tada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a> with <a href="/fam/icap/selections/?posid=#posidq#"><strong><span class="text-muted">Position ID</span> #posidq#</strong></a></cfoutput>
<cfelse>
<cfoutput>#tada.recordcount#</cfoutput> <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a>
</cfif>
    <span class="form-inline pull-right">
    <span style='margin-right:10px;'>
    </span>
    <form class="form-inline pull-right" style="max-width:300px;" action="/fam/icap/selections/" method="post" enctype="multipart/form-data">
    <div class="input-group input-group-sm">
        <input type="text" class="form-control" name="q" size="30" maxlength="30" placeholder="<cfif #session.q# NEQ ''><cfoutput>#session.q#</cfoutput></cfif>">
        <span class="input-group-btn" style="font-size: 10px !important;">
        <button class="btn btn-default btn-xs" type="button">Search</button>
        </span>
    </div>
    </form>
    </span>
</h3>
</div>

<div class="panel-body">
<cfoutput query="FAMDB_user">
        <cfif #icap_role# EQ 'M'>You are <strong>National Administrator</strong>, so the table below is not filtered.
        <cfelseif #icap_role# EQ 'C'>You are <strong>GACC Coordinator</strong> for <strong>#icap_area#</strong> Area, so the table below is filtered to show only <strong>#icap_area#</strong> Area positions and applications.
        <cfelseif #icap_role# EQ 'I'>You are <strong>Incident Commander</strong> for <strong>#icteam_name#</strong> Team, so the table below is filtered to show only <strong>#icap_area#</strong> Area positions and applications.
        <cfelseif #icap_role# EQ 'A'>The table below is filtered to show only your applications.
        <cfelseif #icap_role# EQ ''><strong>Blank user access -- request access to do better.</strong><br></cfif>
</cfoutput>
</div>

<table class="table table-bordered table-condensed">
<thead>
<cfoutput>
<cfif len(heads)>
<cfloop list="#heads#" index='head'>
<cfif head NEQ '_'>
<th><small>#head#</small></th>
</cfif>
</cfloop>
<cfelse>
<cfloop list="#collist#" index='head'>
<th><small>#head#</small></th>
</cfloop>
</cfif>
</cfoutput>
</thead>

<tbody>
<cfoutput query="tada">
<tr class="">
<cfset n = 1>
<cfloop index="col" list="#collist#">
<cfif len(heads)>
    <cfset hd = #listgetat(heads,n)#>
    <cfif hd NEQ '_'>
        <cfset rf = #listgetat(refs,n)#>
        <td>
        <small>
        <cfif col EQ 'position_status'>
        <a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'>Open</strong><cfelseif position_status EQ 'Closed'><strong class='text-warning'>Closed</strong></cfif></a>
        <cfelseif rf NEQ '_'>
            <cfset rfx = rf>
            <cfset rbx = #listgetat(rebs,n)#>
            <a href='/fam/#rbx##tada[rfx][currentRow]#'><cfif isDate(tada[col][currentRow])>#dateformat(tada[col][currentRow], 'yyyy-mm-dd')#<cfelseif col EQ 'changed'>#tostring(tada[col][currentrow])#<cfelse>#tada[col][currentRow]#</cfif></a>
        <cfelse>
            <cfif isDate(tada[col][currentRow])>#dateformat(tada[col][currentRow], 'yyyy-mm-dd')#<cfelseif col EQ 'changed'>#tostring(tada[col][currentrow])#<cfelse>#tada[col][currentRow]#</cfif>
        </cfif>
        </small>
        </td>
    </cfif>
<cfelse>
    <td><small><cfif isDate(tada[col][currentRow])>#dateformat(tada[col][currentRow], 'yyyy-mm-dd')#<cfelseif col EQ 'changed'>#tostring(tada[col][currentrow])#<cfelse>#tada[col][currentRow]#</cfif></small></td>
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
<a href="/fam/icap/selections/"><strong>Position</strong></a> <cfoutput>#vada.position_code# <strong>&sect</strong> #vada.icteam_name#</cfoutput>
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
    <table class='table table-condensed table-bordered'>
    <cfloop index="vol" list="#vollist#">
    <tr>
    <cfif len(vheads)>
        <cfset hd = #listgetat(vheads,n)#>
        <cfif hd NEQ '_'>
            <td style='max-width:90px;text-align:right;'><strong>#hd#</strong></td>
            <cfset rf = #listgetat(vrefs,n)#>
            <cfif isNumeric(vada[vol][currentRow])>
                <td style='padding-left:10px;text-align:right;'>
            <cfelse>
                <td style='padding-left:10px;'>
            </cfif>
                <cfif vol EQ 'position_status'>
                <a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'>Open</strong><cfelseif position_status EQ 'Closed'><strong class='text-warning'>Closed</strong></cfif></a>
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
        <td style='max-width:90px;text-align:right;'><strong>#hd#</strong></td>
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
<cfoutput>#oada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Applicants</span></strong></a> for #tada.recordcount# <a href="/fam/icap/selections/?position=#positionq#"><strong>#positionq#</strong></a> <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a> in <a href="/fam/icap/selections/?area=#areaq#"><strong>#areaq#</strong></a> <strong><span class="text-muted">Area</span></strong></cfoutput>
<cfelseif  #areaq# NEQ ''>
<cfoutput>#oada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Applicants</span></strong></a> for #tada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a> in <a href="/fam/icap/selections/?area=#areaq#"><strong>#areaq#</strong></a> <strong><span class="text-muted">Area</span></strong></cfoutput>
<cfelseif  #teamq# NEQ '' and #positionq# NEQ ''>
<cfoutput>#oada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Applicants</span></strong></a> for #tada.recordcount# <a href="/fam/icap/selections/?position=#positionq#"><strong>#positionq#</strong></a> <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a> on <a href="/fam/icap/selections/?team=#teamq#"><strong>#teamq#</strong></a> <strong><span class="text-muted">Team</span></strong></cfoutput>
<cfelseif #teamq# NEQ ''>
<cfoutput>#oada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Applicants</span></strong></a> for #tada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a> on <a href="/fam/icap/selections/?team=#teamq#"><strong>#teamq#</strong></a> <strong><span class="text-muted">Team</span></strong></cfoutput>
<cfelseif  #positionq# NEQ ''>
<cfoutput>#oada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Applicants</span></strong></a> for #tada.recordcount# <a href="/fam/icap/selections/?position=#positionq#"><strong>#positionq#</strong></a> <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a></cfoutput>
<cfelseif  #userq# NEQ ''>
<cfoutput>#oada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Applications</span></strong></a> for #tada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a> by <a href="/fam/icap/selections/?user=#userq#"><strong><span class="text-muted">User</span> #get_user.applicant_namei# #get_user.applicant_nameii# #get_user.applicant_nameiii#</strong></a></cfoutput>
<cfelseif #posidq# NEQ ''>
<cfoutput>#oada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Applicants</span></strong></a> for #tada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a> with <a href="/fam/icap/selections/?posid=#posidq#"><strong><span class="text-muted">Position ID</span> #posidq#</strong></a></cfoutput>
<cfelse>
<cfoutput>#oada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Applicants</span></strong></a> for #tada.recordcount# <a href="/fam/icap/selections/"><strong><span class="text-muted">Positions</span></strong></a></cfoutput>
</cfif>
    <span class="form-inline pull-right">
    <span style='margin-right:10px;'>
    </span>
    </span>
</cfif>
</h3>
</div>

<div class="panel-body">
<cfoutput query="FAMDB_user">
        <cfif #icap_role# EQ 'M'>You are <strong>National Administrator</strong>, so the table below is not filtered.
        <cfelseif #icap_role# EQ 'C'>You are <strong>GACC Coordinator</strong> for <strong>#icap_area#</strong> Area, so the table below is filtered to show only <strong>#icap_area#</strong> Area positions and applications.
        <cfelseif #icap_role# EQ 'I'>You are <strong>Incident Commander</strong> for <strong>#icteam_name#</strong> Team, so the table below is filtered to show only <strong>#icap_area#</strong> Area positions and applications.
        <cfelseif #icap_role# EQ 'A'>The table below is filtered to show only your applications.
        <cfelseif #icap_role# EQ ''><strong>Blank user access -- request access to do better.</strong><br></cfif>
</cfoutput>
</div>


<table class="table table-bordered table-condensed table-striped">
<thead>
<cfoutput>
<cfif len(aheads)>
<cfloop list="#aheads#" index='head'>
<cfif head NEQ '_'>
<th><small>#head#</small></th>
</cfif>
</cfloop>
<cfelse>
<cfloop list="#collist#" index='head'>
<th><small>#head#</small></th>
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
<tr class="" role="tab" id="">

<cfset n = 1>
<cfloop index="ca" list="#collist#">
    <cfif len(aheads)>
        <cfset hd = #listgetat(aheads,n)#>
        <cfif hd NEQ '_'>
            <cfset rf = #listgetat(arefs,n)#>
            <td<cfif isNumeric(oada[ca][currentRow])> style='text-align:right;'</cfif>>
                <small>
                <cfif ca EQ 'applicant_agency'>
                   <cfif applicant_fq_email_type EQ "">#applicant_agency#<cfelse>#applicant_fq_email_type#</cfif>
                <cfelseif ca EQ 'APPLICANT_GAAC_TYPEI'>
                   <cfif applicant_agency EQ "">#APPLICANT_GAAC_TYPEI#<cfelse>#applicant_agency#</cfif>
                <cfelseif ca EQ 'position_status'>
                    <a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'>Open</strong><cfelseif position_status EQ 'Closed'><strong class='text-warning'>Closed</strong></cfif></a>
                <cfelseif rf NEQ '_'>
                    <cfset rfx = rf>
                    <cfset rbx = #listgetat(arebs,n)#>
                    <a href='/fam/#rbx##oada[rfx][currentRow]#'><cfif isDate(oada[ca][currentRow])><cfif hd CONTAINS 'fuel moisture'>#oada[ca][currentRow]#<cfelse>#dateformat(oada[ca][currentRow], 'yyyy-mm-dd')#</cfif><cfelseif ca EQ 'changed'>#tostring(oada[ca][currentrow])#<cfelse>#oada[ca][currentRow]#</cfif></a>
                <cfelse>
                    <cfif isDate(oada[ca][currentRow])><cfif hd CONTAINS 'fuel moisture'>#oada[ca][currentRow]#<cfelse>#dateformat(oada[ca][currentRow], 'yyyy-mm-dd')#</cfif><cfelseif ca EQ 'changed'>#tostring(oada[ca][currentrow])#<cfelse>#oada[ca][currentRow]#</cfif>
                </cfif>
                </small>
            </td>
        </cfif>
     <cfelse>
        <td<cfif isNumeric(oada[ca][currentRow])> style='text-align:right;'</cfif>>
            <small><cfif isDate(oada[ca][currentRow])><cfif hd CONTAINS 'fuel moisture'>#oada[ca][currentRow]#<cfelse>#dateformat(oada[ca][currentRow], 'yyyy-mm-dd')#</cfif><cfelseif ca EQ 'changed'>#tostring(oada[ca][currentrow])#<cfelse>#oada[ca][currentRow]#</cfif></small></td>
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


</div>

<cfinclude template="/fam/gutter.cfm">

</body>
</html>