<cfinclude template="/fam/icap/use.cfm">
<cfset roles = "M,C,I">
<cfif ListFindNoCase(roles,'#FAMDB_user.icap_role#') GT 0 and #cgi.query_string# CONTAINS 'add_special'>
<cfset a = cgi.query_string.Split("&")>
<cfset pos = REReplaceNoCase(a[1], "pos=", "") />
<cfset webcaaf = REReplaceNoCase(a[2], "add_special=", "") />
<cfset con = REReplaceNoCase(a[3], "con=", "") />
<cfquery name="gid" datasource="ICAP_Prod">
select * from icap_applicants where applicant_eauth_id = '#webcaaf#'
</cfquery>
<cfquery name="pid" datasource="ICAP_Prod">
select p.*, t.icteam_name from icap_positions p left join icap_teams t on p.icteam_id = t.icteam_id where position_id = '#pos#'
</cfquery>
<cfset position_warrant = '' />
<cfset position_po = '' />
<cfset application_consideration = '#con#' />
<cfset application_interest = '' />
<cfset application_qualifications = '' />
<cfset application_recommendation = 'Y' />
<cfset application_curr_year = '' />
<cfquery name="check" datasource="ICAP_Prod">
select * from icap_applications where applicant_id = <cfqueryparam value="#gid.applicant_id#" cfsqltype="cf_sql_integer" maxlength="5"> and position_id = <cfqueryparam value="#pid.position_id#" cfsqltype="cf_sql_integer" maxlength="5">
</cfquery>
<cfif #check.recordcount# EQ 0 or #check.recordcount# NEQ 0>
<cfquery name="insert" datasource="ICAP_Prod">
insert into icap_applications (applicant_id, position_id, position_warrant, position_po, application_consideration, application_interest, application_qualifications, application_recommendation, application_curr_year, application_valid, application_type, updated, updated_by
) values (<cfqueryparam value="#gid.applicant_id#" cfsqltype="cf_sql_integer" maxlength="5">, <cfqueryparam value="#pid.position_id#" cfsqltype="cf_sql_integer" maxlength="5">, <cfqueryparam value="#position_warrant#" cfsqltype="cf_sql_varchar" maxlength="5">, <cfqueryparam value="#position_po#" cfsqltype="cf_sql_varchar" maxlength="5">, <cfqueryparam value="#application_consideration#" cfsqltype="cf_sql_varchar" maxlength="60">, <cfqueryparam value="#application_interest#" cfsqltype="cf_sql_longvarchar">, <cfqueryparam value="#application_qualifications#" cfsqltype="cf_sql_longvarchar">, <cfqueryparam value="#application_recommendation#" cfsqltype="cf_sql_longvarchar">, <cfqueryparam value="#application_curr_year#" cfsqltype="cf_sql_longvarchar">,'Y','A','#today#','#FAMDB_USER.username#')
</cfquery>
<cfquery name="insert_position_app" datasource="ICAP_Prod">
insert into icap_positions_applicants (position_id,icteam_id,applicant_id,applicant_type,applicant_valid,updated,updated_by)
values(<cfqueryparam value="#pid.position_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#pid.icteam_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#gid.applicant_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#application_consideration#" cfsqltype="cf_sql_varchar" maxlength="60">,'N','#today#','#FAMDB_USER.username#')
</cfquery>
<cfset msg_status = "success">
<cfset msg_text = "Application added.">
<cfelse>
<cfset msg_status = "warning">
<cfset msg_text = "Applicant already applied.">
</cfif>
<cflocation url='/fam/icap/selections/?team=#pid.icteam_name#&position=#pid.position_code#'>
</cfif>
<cfif structKeyExists(form, 'application_delete')>
<cfquery name="set_one" datasource="ICAP_Prod">
insert into icap_selections (position_id,application_id,status,status_date,created,created_by) values (<cfqueryparam value="#form.position_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#form.application_id#" cfsqltype="cf_sql_integer" maxlength="7">,<cfqueryparam value="WITHDRAWN" cfsqltype="cf_sql_varchar" maxlength="50">,'#today#','#today#','#session.user_webcaaf#')
</cfquery>
<cfelseif structKeyExists(form, 'application_restore')>
<cfquery name="set_one" datasource="ICAP_Prod">
insert into icap_selections (position_id,application_id,status,status_date,created,created_by) values (<cfqueryparam value="#form.position_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#form.application_id#" cfsqltype="cf_sql_integer" maxlength="7">,<cfqueryparam value="" cfsqltype="cf_sql_varchar" maxlength="50">,'#today#','#today#','#session.user_webcaaf#')
</cfquery>
<cfset msg_text = "Application restored for <a class=""alert-link"" href=""/fam/users/?#form.user_webcaaf#"">#form.user_firstname# #form.user_lastname#</a> (<a class=""alert-link"" href=""/fam/users/?#form.user_webcaaf#"">#form.user_email#</a>).">
<cfset msg_maxwid = '880px'>
<cfset msg_status = "success">
<cfelseif structKeyExists(form, 'application_consideration')>
<cfquery name="aid" datasource="ICAP_Prod">
select * from icap_applicants where applicant_eauth_id = '#FAMDB_user.username#'
</cfquery>
<cfif #aid.recordcount# EQ 0>
<cfset msg_status = "warning">
<cfset msg_maxwid = '880px'>
<cfset msg_text = "<a class='alert-link' href='/fam/icap/applicant/'>Add applicant information at Step 1</a> before <a class='alert-link' href='/fam/icap/positions/'>applying to positions at Step 2</a>.">
<cfinclude template="/fam/lo.cfm">
<cfinclude template="/fam/gutter.cfm">
<cfabort>
</cfif>
<cfif #form.application_id# NEQ ''>
<cfquery name="update_application" datasource="ICAP_Prod" maxrows="1">
update icap_applications set application_consideration  = <cfqueryparam value="#form.application_consideration#" cfsqltype="cf_sql_varchar" maxlength="60">,application_interest = <cfqueryparam value="#form.application_interest#" cfsqltype="cf_sql_longvarchar">,application_qualifications = <cfqueryparam value="#form.application_qualifications#" cfsqltype="cf_sql_longvarchar">,application_recommendation = <cfqueryparam value="#form.application_recommendation#" cfsqltype="cf_sql_longvarchar">,application_valid = 'Y',<cfif #form.position_warrant# EQ "Y">position_warrant = 'Y',<cfelse>position_warrant = 'N',</cfif><cfif #form.position_po# EQ "Y">position_po = 'Y',<cfelse>position_po = 'N',</cfif>application_type = 'U',updated = '#today#',updated_by = '#session.user_webcaaf#' where application_id = <cfqueryparam value="#form.application_id#" cfsqltype="cf_sql_integer" maxlength="5">
</cfquery>
<cfquery name="update_ca_applicant" datasource="ICAP_Prod" maxrows="1">
update icap_applicants set applicant_retired  = <cfqueryparam value="#form.applicant_retired#" cfsqltype="cf_sql_varchar" maxlength="60">,applicant_fq_email_type  = <cfqueryparam value="#form.applicant_fq_email_type#" cfsqltype="cf_sql_varchar" maxlength="60">,<cfif structKeyExists(form, 'applicant_agency')>applicant_agency  = <cfqueryparam value="#form.applicant_agency#" cfsqltype="cf_sql_varchar" maxlength="100">,</cfif>updated = '#today#',updated_by = '#session.user_webcaaf#'where applicant_id = <cfqueryparam value="#form.applicant_id#" cfsqltype="cf_sql_integer" maxlength="5">
</cfquery>
<cfquery name="set_one" datasource="ICAP_Prod">
insert into icap_selections (position_id,application_id,status,status_date,created,created_by) values (<cfqueryparam value="#form.position_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#form.application_id#" cfsqltype="cf_sql_integer" maxlength="7">,<cfqueryparam value="" cfsqltype="cf_sql_varchar" maxlength="50">,'#today#','#today#','#session.user_webcaaf#')
</cfquery>
<cfelseif #form.application_id# EQ ''>
<cfquery name="insert" datasource="ICAP_Prod">
insert into icap_applications (applicant_id,position_id,position_warrant,position_po,application_consideration,application_interest,application_qualifications,application_recommendation,application_curr_year,application_valid,application_type,updated,updated_by) values (<cfqueryparam value="#form.applicant_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#form.position_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#form.position_warrant#" cfsqltype="cf_sql_varchar" maxlength="5">,<cfqueryparam value="#form.position_po#" cfsqltype="cf_sql_varchar" maxlength="5">,<cfqueryparam value="#form.application_consideration#" cfsqltype="cf_sql_varchar" maxlength="60">,<cfqueryparam value="#form.application_interest#" cfsqltype="cf_sql_longvarchar">,<cfqueryparam value="#form.application_qualifications#" cfsqltype="cf_sql_longvarchar">,<cfqueryparam value="#form.application_recommendation#" cfsqltype="cf_sql_longvarchar">,<cfqueryparam value="#form.application_curr_year#" cfsqltype="cf_sql_longvarchar">,'Y','A','#today#','#session.user_webcaaf#')
</cfquery>
<cfquery name="update_ca_applicant" datasource="ICAP_Prod" maxrows="1">
update icap_applicants set applicant_retired  = <cfqueryparam value="#form.applicant_retired#" cfsqltype="cf_sql_varchar" maxlength="60">,applicant_fq_email_type  = <cfqueryparam value="#form.applicant_fq_email_type#" cfsqltype="cf_sql_varchar" maxlength="60">,<cfif structKeyExists(form, 'applicant_agency')>applicant_agency  = <cfqueryparam value="#form.applicant_agency#" cfsqltype="cf_sql_varchar" maxlength="100">,</cfif>updated = '#today#',updated_by = '#session.user_webcaaf#' where applicant_id = <cfqueryparam value="#form.applicant_id#" cfsqltype="cf_sql_integer" maxlength="80">
</cfquery>
</cfif>
<cfif #form.application_id# NEQ '' or #form.application_id# EQ ''>
<cfquery name="insert_position_app" datasource="ICAP_Prod">
insert into icap_positions_applicants (position_id,icteam_id,applicant_id,applicant_type,applicant_valid,updated,updated_by) values (<cfqueryparam value="#form.position_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#form.icteam_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#form.applicant_id#" cfsqltype="cf_sql_integer" maxlength="5">,<cfqueryparam value="#form.application_consideration#" cfsqltype="cf_sql_varchar" maxlength="60">,'N','#today#','#session.user_webcaaf#')
</cfquery>
</cfif>
</cfif>
<cfif structKeyExists(form, 'application_consideration')>
<cfquery name="get_last_id" datasource="ICAP_Prod" maxrows="1">
select application_id from icap_applications where applicant_id = '#form.applicant_id#' and application_valid = 'Y' order by application_id desc
</cfquery>
<cfquery name="get_applicant" datasource="ICAP_Prod">
select * from icap_applicants where applicant_id = '#form.applicant_id#'
</cfquery>
<cfquery name="get_team" datasource="ICAP_Prod">
select icteam_name from icap_teams where icteam_id = '#form.icteam_id#'
</cfquery>
<cfquery name="check_gaac" datasource="ICAP_Prod" maxrows="1">
select applicant_gaac_type from icap_applicants where applicant_id = <cfqueryparam value="#form.applicant_id#" cfsqltype="cf_sql_integer" maxlength="5">
</cfquery>
    <cfif #form.application_id# NEQ ''>
        <cfif #get_applicant.applicant_email_address# NEQ "">
            <cfmail from="icap@usda.gov" to="#get_applicant.applicant_email_address#" subject="ICAP application edited - #session.user_email#" type="html">
            *** DO NOT REPLY ***<br/>
            <br/>
            This email is generated by the Incident Command Application Program, developed by the USDA Forest Service to support recruitment and selection of Incident Management Team positions.<br/>
            <br/>
            Applicant: #get_applicant.applicant_nameI# #get_applicant.applicant_nameII# #get_applicant.applicant_nameIII#<br/>
            Supervisor: #get_applicant.applicant_ao_name#<br/>
            Training Coordinator: #get_applicant.applicant_fq_email#<br/>
            Agency Admin: #get_applicant.applicant_aa_email# (#get_applicant.applicant_fq_email_type#)<br/>
            Team: #get_team.icteam_name#<br/>
            Position: #form.position#<br/>
            Type: #form.application_consideration#<br/>
            <br/>
            <b>Submitted successfully.</b> You will be contacted by the Incident Commander with any change of status to your application. 
            </cfmail>
        </cfif>
        <cfif #get_applicant.applicant_ao_email# NEQ "" and #form.icteam_area# NEQ "California">
            <cfmail from="icap@usda.gov" to="#get_applicant.applicant_ao_email#" subject="ICAP application edited - #session.user_email# AO-SUPERVISOR" type="html">
            *** DO NOT REPLY ***  (Attention USFS: This email may be incorrectly classified as spam. Click the banner at the top before taking any action with this email.)<br/>
            <br/>
            This email is generated by the Incident Command Application Program, developed by the USDA Forest Service to support recruitment and selection of Incident Management Team positions.<br/>
            <br/>
            Applicant: #get_applicant.applicant_nameI# #get_applicant.applicant_nameII# #get_applicant.applicant_nameIII#<br/>
            Supervisor: #get_applicant.applicant_ao_name#<br/>
            Training Coordinator: #get_applicant.applicant_fq_email#<br/>
            Agency Admin: #get_applicant.applicant_aa_email# (#get_applicant.applicant_fq_email_type#)<br/>
            Team: #get_team.icteam_name#<br/>
            Position: #form.position#<br/>
            Type: #form.application_consideration#<br/>
            <br/>
            If the applicant is qualified for this position click 'I Agree' link below.  Otherwise select 'Not agree'.
            <br/><br/>
            This will be recorded in the ICAP database.  Please note that some email system routinely inhibit these links.  You may need to enable these links in your email system for them to be active.
            <br/><br/>
            <font style="font:12px arial; color:333333;">
            <a href="http://fireportal.usda.gov/icap/ao_email.cfm?id=#get_applicant.applicant_id#&ao_email=#get_applicant.applicant_ao_email#&action=approve&dsn=ICAP_Prod&team=#get_team.icteam_name#&position=#form.position#&consid=#form.application_consideration#&eml=#get_applicant.applicant_email_address#"><strong>Agree</strong></a> |
            <a href="http://fireportal.usda.gov/icap/ao_email.cfm?id=#get_applicant.applicant_id#&ao_email=#get_applicant.applicant_ao_email#&action=disapprove&dsn=ICAP_Prod&team=#get_team.icteam_name#&position=#form.position#&consid=#form.application_consideration#&eml=#get_applicant.applicant_email_address#"><strong>Not agree</strong></a>
            </font>
            </cfmail>
            <cfif #form.icteam_area# NEQ #check_gaac.applicant_gaac_type#>
                <cfif #check_gaac.applicant_gaac_type# EQ 'Eastern'>
                <cfset to_emails="wieacc@fs.fed.us">
                <cfelse>
                <cfset to_emails="">
                </cfif>
                <cfmail from="icap@usda.gov" to="#to_emails#" subject="ICAP application from out-of-area user - #session.user_email#" type="html">
                *** DO NOT REPLY ***<br/>
                <br/>
                This email is generated by the Incident Command Application Program, developed by the USDA Forest Service to support recruitment and selection of Incident Management Team positions.<br/>
                <br/>
                Applicant: #get_applicant.applicant_nameI# #get_applicant.applicant_nameII# #get_applicant.applicant_nameIII#<br/>
                Supervisor: #get_applicant.applicant_ao_name#<br/>
                Training Coordinator: #get_applicant.applicant_fq_email#<br/>
                Agency Admin: #get_applicant.applicant_aa_email# (#get_applicant.applicant_fq_email_type#)<br/>
                Team: #get_team.icteam_name#<br/>
                Position: #form.position#<br/>
                Type: #form.application_consideration#<br/>
                </cfmail>
            </cfif>
        </cfif>
        <cfif #form.icteam_area# NEQ "California">
        <cfif #get_applicant.applicant_fq_email# NEQ "">
            <cfmail from="icap@usda.gov" to="#get_applicant.applicant_fq_email#" subject="ICAP application edited - #session.user_email# FQ-TRAININGCOORD" type="html">
            *** DO NOT REPLY ***  (Attention USFS: This email may be incorrectly classified as spam. Click the banner at the top before taking any action with this email.)<br/>
            <br/>
            This email is generated by the Incident Command Application Program, developed by the USDA Forest Service to support recruitment and selection of Incident Management Team positions.<br/>
            <br/>
            Applicant: #get_applicant.applicant_nameI# #get_applicant.applicant_nameII# #get_applicant.applicant_nameIII#<br/>
            Supervisor: #get_applicant.applicant_ao_name#<br/>
            Training Coordinator: #get_applicant.applicant_fq_email#<br/>
            Agency Admin: #get_applicant.applicant_aa_email# (#get_applicant.applicant_fq_email_type#)<br/>
            Team: #get_team.icteam_name#<br/>
            Position: #form.position#<br/>
            Type: #form.application_consideration#<br/>
            <br/>
            It is assumed that you certify that the individual fully meets the training, experience and physical fitness requirements as outlined in NWCG Wildland and Prescribed Fire Qualification System Guide (310-1) for this position.<br/>
            If the individual has applied for a trainee position, It is assumed that you certify that the individual is qualified as a trainee and has been issued a task book for this position.<br/>
            Qualification discrepancies in the applicant's IQS or IQCS training records may prevent selected applicants from being rostered and dispatched.<br/>
            If you do not approve of this action instruct the applicant above to return to ICAP and remove his or her application.
            If the applicant is qualified for this position click 'I Agree' link below.  Otherwise select the 'Not agree'.  This will be recorded in the ICAP database.  Please note that some email system routinely inhibit these links.  You may need to enable these links in your email system for them to be active.<br/>
            <br/>
            <font style="font:12px arial; color:333333;">
            <a href="http://fireportal.usda.gov/icap/ao_email.cfm?id=#get_applicant.applicant_id#&ao_email=#get_applicant.applicant_fq_email#&action=approve&dsn=ICAP_Prod&team=#get_team.icteam_name#&position=#form.position#&consid=#form.application_consideration#&eml=#get_applicant.applicant_email_address#"><strong>Agree</strong></a> |
            <a href="http://fireportal.usda.gov/icap/ao_email.cfm?id=#get_applicant.applicant_id#&ao_email=#get_applicant.applicant_fq_email#&action=disapprove&dsn=ICAP_Prod&team=#get_team.icteam_name#&position=#form.position#&consid=#form.application_consideration#&eml=#get_applicant.applicant_email_address#"><strong>Not agree</strong></a>
            </font>
            <br/>
            </cfmail>
        </cfif>
        </cfif>
        <cfif #get_applicant.applicant_aa_email# NEQ "" and #form.icteam_area# NEQ "California">
            <cfmail from="icap@usda.gov" to="#get_applicant.applicant_aa_email#" subject="ICAP application edited - #session.user_email# AA-AGENCYADMIN" type="html">
            *** DO NOT REPLY ***<br/>
            <br/>
            This email is generated by the Incident Command Application Program, developed by the USDA Forest Service to support recruitment and selection of Incident Management Team positions.<br/>
            <br/>
            Applicant: #get_applicant.applicant_nameI# #get_applicant.applicant_nameII# #get_applicant.applicant_nameIII#<br/>
            Supervisor: #get_applicant.applicant_ao_name#<br/>
            Training Coordinator: #get_applicant.applicant_fq_email#<br/>
            Agency Admin: #get_applicant.applicant_aa_email# (#get_applicant.applicant_fq_email_type#)<br/>
            Team: #get_team.icteam_name#<br/>
            Position: #form.position#<br/>
            Type: #form.application_consideration#<br/>
            <br/>
            For Agency employees: It is assumed that you concur with the applicant's qualifications and availability to serve for a period of one year if selected to serve with a IMT.<br/>
            For retirees and WA Fire Service:  It is assumed that you concur with the applicant's qualifications and my agency will have a dispatch agreement in place with the applicant.<br/>
            If you do not approve of this action instruct the applicant above to return to ICAP and remove his or her application.
            </cfmail>
        </cfif>
        <cfset msg_text = "Application edited for <a class=""alert-link"" href=""/fam/users/?#session.user_webcaaf#"">#session.user_firstname# #session.user_lastname#</a> (<a class=""alert-link"" href=""/fam/users/?#session.user_webcaaf#"">#session.user_email#</a>).">
    <cfelse>
        <cfif #get_applicant.applicant_email_address# NEQ "" >
            <cfmail from="icap@usda.gov" to="#get_applicant.applicant_email_address#" subject="ICAP application added - #session.user_email#" type="html">
            *** DO NOT REPLY ***<br/>
            <br/>
            This email is generated by the Incident Command Application Program, developed by the USDA Forest Service to support recruitment and selection of Incident Management Team positions.<br/>
            <br/>
            Applicant: #get_applicant.applicant_nameI# #get_applicant.applicant_nameII# #get_applicant.applicant_nameIII#<br/>
            Supervisor: #get_applicant.applicant_ao_name#<br/>
            Training Coordinator: #get_applicant.applicant_fq_email#<br/>
            Agency Admin: #get_applicant.applicant_aa_email# (#get_applicant.applicant_fq_email_type#)<br/>
            Team: #get_team.icteam_name#<br/>
            Position: #form.position#<br/>
            Type: #form.application_consideration#<br/>
            <br/>
            <b>Submitted successfully.</b> You will be contacted by the Incident Commander with any change of status to your application. 
            </cfmail>
        </cfif>                    
        <cfif #get_applicant.applicant_ao_email# NEQ "" and #form.icteam_area# NEQ "California">
            <cfmail from="icap@usda.gov" to="#get_applicant.applicant_ao_email#" subject="ICAP application added - #session.user_email# AO-SUPERVISOR" type="html">
            *** DO NOT REPLY ***  (Attention USFS: This email may be incorrectly classified as spam. Click the banner at the top before taking any action with this email.)<br/>
            <br/>
            This email is generated by the Incident Command Application Program, developed by the USDA Forest Service to support recruitment and selection of Incident Management Team positions.<br/>
            <br/>
            Applicant: #get_applicant.applicant_nameI# #get_applicant.applicant_nameII# #get_applicant.applicant_nameIII#<br/>
            Supervisor: #get_applicant.applicant_ao_name#<br/>
            Training Coordinator: #get_applicant.applicant_fq_email#<br/>
            Agency Admin: #get_applicant.applicant_aa_email# (#get_applicant.applicant_fq_email_type#)<br/>
            Team: #get_team.icteam_name#<br/>
            Position: #form.position#<br/>
            Type: #form.application_consideration#<br/>
            <br/>
            If the applicant is qualified for this position click 'I Agree' link below.  Otherwise select the 'Not agree'.<br/>
            <br/>
            This will be recorded in the ICAP database.  Please note that some email system routinely inhibit these links.  You may need to enable these links in your email system for them to be active.<br/>
            <br/>
            <font style="font:12px arial; color:333333;">
            <a href="http://fireportal.usda.gov/icap/ao_email.cfm?id=#get_applicant.applicant_id#&ao_email=#get_applicant.applicant_ao_email#&action=approve&dsn=ICAP_Prod&team=#get_team.icteam_name#&position=#form.position#&consid=#form.application_consideration#&eml=#get_applicant.applicant_email_address#"><strong>Agree</strong></a> |
            <a href="http://fireportal.usda.gov/icap/ao_email.cfm?id=#get_applicant.applicant_id#&ao_email=#get_applicant.applicant_ao_email#&action=disapprove&dsn=ICAP_Prod&team=#get_team.icteam_name#&position=#form.position#&consid=#form.application_consideration#&eml=#get_applicant.applicant_email_address#"><strong>Not agree</strong></a>
            </font>
            </cfmail>
            <cfif #form.icteam_area# NEQ #check_gaac.applicant_gaac_type#>
                <cfif #check_gaac.applicant_gaac_type# EQ 'Eastern'>
                <cfset to_emails="wieacc@fs.fed.us">
                <cfelse>
                <cfset to_emails="">
                </cfif>
                <cfmail from="icap@usda.gov" to="#to_emails#" subject="ICAP application from out-of-area user - #session.user_email#" type="html">
                *** DO NOT REPLY ***<br/>
                <br/>
                This email is generated by the Incident Command Application Program, developed by the USDA Forest Service to support recruitment and selection of Incident Management Team positions.<br/>
                <br/>
                Applicant: #get_applicant.applicant_nameI# #get_applicant.applicant_nameII# #get_applicant.applicant_nameIII#<br/>
                Supervisor: #get_applicant.applicant_ao_name#<br/>
                Training Coordinator: #get_applicant.applicant_fq_email#<br/>
                Agency Admin: #get_applicant.applicant_aa_email# (#get_applicant.applicant_fq_email_type#)<br/>
                Team: #get_team.icteam_name#<br/>
                Position: #form.position#<br/>
                Type: #form.application_consideration#
                </cfmail>
            </cfif>
        </cfif>
        <cfif #get_applicant.applicant_fq_email# NEQ "" and #form.icteam_area# NEQ "California">
            <cfmail from="icap@usda.gov" to="#get_applicant.applicant_fq_email#" subject="ICAP application added - #session.user_email# FQ-TRAININGCOORD" type="html">
            *** DO NOT REPLY ***  (Attention USFS: This email may be incorrectly classified as spam. Click the banner at the top before taking any action with this email.)<br/>
            <br/>
            This email is generated by the Incident Command Application Program, developed by the USDA Forest Service to support recruitment and selection of Incident Management Team positions.<br/>
            <br/>
            Applicant: #get_applicant.applicant_nameI# #get_applicant.applicant_nameII# #get_applicant.applicant_nameIII#<br/>
            Supervisor: #get_applicant.applicant_ao_name#<br/>
            Training Coordinator: #get_applicant.applicant_fq_email#<br/>
            Agency Admin: #get_applicant.applicant_aa_email# (#get_applicant.applicant_fq_email_type#)<br/>
            Team: #get_team.icteam_name#<br/>
            Position: #form.position#<br/>
            Type: #form.application_consideration#<br/>
            <br/>
            It is assumed that you certify that the individual fully meets the training, experience and physical fitness requirements as outlined in NWCG Wildland and Prescribed Fire Qualification System Guide (310-1) for this position.<br/>
            If the individual has applied for a trainee position, It is assumed that you certify that the individual is qualified as a trainee and has been issued a task book for this position.<br/>
            Qualification discrepancies in the applicant's IQS or IQCS training records may prevent selected applicants from being rostered and dispatched.<br/>
            If you do not approve of this action instruct the applicant above to return to ICAP and remove his or her application.
            If the applicant is qualified for this position click 'I Agree' link below.  Otherwise select the 'Not agree'.  This will be recorded in the ICAP database.  Please note that some email system routinely inhibit these links.  You may need to enable these links in your email system for them to be active.<br/>
            <br/>
            <font style="font:12px arial; color:333333;">
            <a href="http://fireportal.usda.gov/icap/ao_email.cfm?id=#get_applicant.applicant_id#&ao_email=#get_applicant.applicant_fq_email#&action=approve&dsn=ICAP_Prod&team=#get_team.icteam_name#&position=#form.position#&consid=#form.application_consideration#&eml=#get_applicant.applicant_email_address#"><strong>Agree</strong></a> |
            <a href="http://fireportal.usda.gov/icap/ao_email.cfm?id=#get_applicant.applicant_id#&ao_email=#get_applicant.applicant_fq_email#&action=disapprove&dsn=ICAP_Prod&team=#get_team.icteam_name#&position=#form.position#&consid=#form.application_consideration#&eml=#get_applicant.applicant_email_address#"><strong>Not agree</strong></a>
            </font>
            <br/>
            </cfmail>
        </cfif>
        <cfif #get_applicant.applicant_aa_email# NEQ "" and #form.icteam_area# NEQ "California">
            <cfmail from="icap@usda.gov" to="#get_applicant.applicant_aa_email#" subject="ICAP application added - #session.user_email# AA-AGENCYADMIN" type="html">
            *** DO NOT REPLY ***<br/>
            <br/>
            This email is generated by the Incident Command Application Program, developed by the USDA Forest Service to support recruitment and selection of Incident Management Team positions.<br/>
            <br/>
            Applicant: #get_applicant.applicant_nameI# #get_applicant.applicant_nameII# #get_applicant.applicant_nameIII#<br/>
            Supervisor: #get_applicant.applicant_ao_name#<br/>
            Training Coordinator: #get_applicant.applicant_fq_email#<br/>
            Agency Admin: #get_applicant.applicant_aa_email# (#get_applicant.applicant_fq_email_type#)<br/>
            Team: #get_team.icteam_name#<br/>
            Position: #form.position#<br/>
            Type: #form.application_consideration#<br/>
            <br/>
            For Agency employees: It is assumed that you concur with the applicant's qualifications and availability to serve for a period of one year if selected to serve with a IMT.<br/>
            For retirees and WA Fire Service:  It is assumed that you concur with the applicant's qualifications and my agency will have a dispatch agreement in place with the applicant.<br/>
            If you do not approve of this action instruct the applicant above to return to ICAP and remove his or her application.
            </cfmail>
        </cfif>
        <cfset msg_text = "Application added for <a class=""alert-link"" href=""/fam/users/?#session.user_webcaaf#"">#session.user_firstname# #session.user_lastname#</a> (<a class=""alert-link"" href=""/fam/users/?#session.user_webcaaf#"">#session.user_email#</a>).">
    </cfif>
    <cfset msg_maxwid = '880px'>
    <cfset msg_status = "success">
</cfif>
<cfinclude template="/fam/lo.cfm">
<cfquery name="ac" datasource="ICAP_Prod">
select applicant_id,applicant_eauth_id,applicant_gaac_type,applicant_retired,applicant_fq_email_type,applicant_agency from icap_applicants where applicant_eauth_id = '#session.user_webcaaf#'
</cfquery>
<cfif isdefined('q')>
<cfset session.q = #q#>
<cfelse>
<cfset session.q = ''>
</cfif>
<cfif isdefined('arealect')>
<cfset session.arealect = #arealect#>
<cfif #session.icap_role# EQ 'C'>
<cfset fa = '#arealect#'>
<cfset ft = ''>
<cfset fu = ''>
</cfif>
<cfif #session.icap_role# EQ 'I'>
<cfset fa = '#arealect#'>
<cfset ft = ''>
<cfset fu = ''>
</cfif>
<cfif #session.icap_role# EQ 'A'>
<cfset fa = '#arealect#'>
<cfset ft = ''>
<cfset fu = ''>
</cfif>
<cfelse>
<cfset session.arealect = '#ac.applicant_gaac_type#'>
<cfset fa = '#ac.applicant_gaac_type#'>
<cfset ft = ''>
<cfset fu = ''>
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
<cfif '#FAMDB_user.icap_role#' EQ 'A'>
<cfset userq = '#FAMDB_user.username#'>
<cfelse>
<cfset userq = REReplaceNoCase(cgi.query_string, "user=", "") />
<cfset userq = REReplace(userq,"%20"," ","all")>
</cfif>
<cfelseif #cgi.query_string# CONTAINS 'posid='>
<cfset posidq = REReplaceNoCase(cgi.query_string, "posid=", "") />
<cfset posidq = REReplace(posidq,"%20"," ","all")>
</cfif>
</cfif>
<cfif #cgi.query_string# NEQ '' and  #areaq# EQ '' and #teamq# NEQ '' and #positionq# NEQ '' and #userq# EQ '' and #posidq# EQ '' >
<cfquery name="pada" datasource="ICAP_Prod">
select t.icteam_id,t.icteam_area,t.icteam_name,p.position_id,p.position_code,p.position_title,s.position_status from icap_positions p left join icap_teams t on p.icteam_id = t.icteam_id left outer join icap_positions_status s on p.position_id = s.position_id where t.icteam_name = '#teamq#' and p.position_code = '#positionq#' and s.position_status <> 'Deleted'
</cfquery>
<cfquery name="get_last_aid" datasource="ICAP_Prod" maxrows="1">
select application_id from icap_applications where position_id = '#pada.position_id#' and applicant_id = '#ac.applicant_id#' and application_valid = 'Y' order by application_id desc
</cfquery>
<cfquery name="get_last_paid" datasource="ICAP_Prod" maxrows="1">
select position_applicant_id from icap_positions_applicants where position_id = '#pada.position_id#' and applicant_id = '#ac.applicant_id#' order by position_applicant_id desc
</cfquery>
<cfquery name="ada" datasource="ICAP_Prod" maxrows="1">
select t.icteam_name, p.position_code, s.position_status, a.applicant_eauth_id, a.applicant_retired, a.applicant_fq_email_type, a.applicant_agency, aa.application_id, aa.applicant_id, aa.position_id, aa.position_warrant, aa.position_po, aa.application_consideration, aa.application_interest, aa.application_qualifications, aa.application_recommendation, aa.application_curr_year, aa.application_valid, aa.application_type, aa.updated as aaupdated, aa.updated_by as aaupdated_by, uu.email as uuemail, lu.email_address as luemail, q.position_applicant_id, q.position_id, q.icteam_id, q.applicant_id, q.applicant_type, q.applicant_valid, q.updated as qupdated, q.updated_by as qupdated_by, ss.status, ss.status_date from icap_positions p left join icap_teams t on p.icteam_id = t.icteam_id left outer join icap_positions_status s on p.position_id = s.position_id left outer join icap_positions_applicants q on p.position_id = q.position_id left outer join icap_applicants a on q.applicant_id = a.applicant_id left outer join Region_6.dbo.login au on a.applicant_eauth_id = au.webcaaf_id left outer join icap_applications aa on p.position_id = aa.position_id and a.applicant_id = aa.applicant_id left outer join FAMDB.dbo.users uu on aa.updated_by = uu.username left outer join Region_6.dbo.login lu on aa.updated_by = lu.webcaaf_id outer apply (select top 1 * from icap_selections ss where ss.position_id = p.position_id and ss.application_id = aa.application_id order by ss.status_date desc) as ss left outer join Region_6.dbo.login uss on ss.created_by = uss.webcaaf_id where t.icteam_name = '#teamq#' and p.position_code = '#positionq#' and a.applicant_eauth_id = '#session.user_webcaaf#' and aa.application_id = '#get_last_aid.application_id#' and q.position_applicant_id = '#get_last_paid.position_applicant_id#'
</cfquery>
<cfoutput query="pada">
<cfif pada.position_status EQ 'Open' and pada.icteam_area EQ 'California'>
<cfset msg_text = "This position is <strong>open</strong>. Apply or update your application below.<br>Remember to <strong>upload your qualification documents</strong> to your applicant record in Step 1 before applying to California teams. At a minimum, include a resume and your master training record.">
<cfset msg_status = "success">
<cfelseif pada.position_status EQ 'Open'>
<cfset msg_text = "This position is <strong>open</strong>. Apply or update your application below.">
<cfset msg_status = "success">
<cfelseif pada.position_status EQ 'Closed'>
<cfset msg_text = "This position is <strong>closed</strong>.">
<cfset msg_status = "warning">
</cfif>
</cfoutput>
<cfif #isdefined('msg_text')#>
<cfoutput>
<div class="alert alert-dismissible<cfif #isdefined('msg_status')#> alert-#msg_status#</cfif>" style='margin-top:0px;padding-top:5px;padding-bottom:5px;max-width:880px;' role="alert">
<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
#msg_text#
</div>
</cfoutput>
</cfif>
<cfif pada.position_status EQ 'Open'>
<cfif #pada.icteam_area# EQ 'California'>
<cfset r5fds ="OUT OF REGION,FFT - 233rd FF Team Army Nat. Guard,ADL - Adelanto FD,ADI - Adin FPD,PLN - Air Force Plant 42/Pyramid Srv. Inc,ANG - Air National Guard FD,NV-AAU - Airport Authority Of Washoe County,ACF - Alameda County FD,ALA - Alameda FD,ALB - Albany FD,ALR - Albion-little River VFD,ALH - Alhambra FD,ALG - Alleghany VFD,ALP - Alpine CFD,ACP - Alpine FPD,ASC - Alpine Meadows FPD,AFP - Alta FPD,ALT - Altaville-melones FPD,ALV - Alturas City FD,AIR - Alturas Indian Rancheria Fire Serv.,ALF - Alturas Rural FPD,AMC - Amador FPD,ACY - American Canyon FPD,KMC - American Chemical,ANA - Anaheim FD,AFD - Anderson FPD,AVY - Anderson Valley CSD FD,ANN - Annapolis VFD,ANT - Antelope Valley FD,APP - Apple Valley FPD,APT - Aptos/La Selva (beach) FPD,ARB - Arbuckle-College City FPD,ARC - Arcadia FD,ARF - Arcata FPD,ATC - Aromas Tri-County FPD,ABL - Arrowbear Lake FD,ART - Artois FPD,ASP - Aspendell Fire CO,ATA - Atascadero City FD,ATS - Atascadero State Hospital FD,ATW - Atwater FD,AUB - Auberry VFD,ABR - Auburn VFD,AVA - Avalon FD,CPA - Avenal State Prison FD,ACR - Aviation CFR FD,AVI - Avila Beach FPD,BPC - B P Carson FD,BKF - Bakersfield FD,BLD - Bald Mtn VFD,BLF - Baldwin Lake VFD,BAN - Banning FD,BBB - Barona FPD,BAR - Barstow FPD,BAY - Bayliss FPD,BEA - Beale AFB FD,BRV - Bear Valley FD,BIV - Bear Valley- Indian Valley FD,BMT - Beaumont FD,BEC - Beckwourth Fire District,BEL - Belmont FD,BSC - Belmont-San Carlos FD,BEN - Ben Lomond FPD,BNC - Benicia FD,BVF - Bennett Valley FPD,BER - Berkeley FD,BHL - Beverly Hills FD,BFA - Big Bear Fire Authority,BCR - Big Creek VFD,BGP - Big Pine FPD,BSB - Big Sur Volunteer Fire Brigade,BGV - Big Valley FPD,BIG - Biggs FD,BSH - Bishop VFD,BLR - Bitter Creek NWR,BBD - BLM - Bakersfield District,CSO - BLM - CA State Office, F&AM,CDD - BLM - Desert District,NOD - BLM - Northern California District,OVD - BLM - Owens Valley District,BLM - BLM California - (see CSO),BFC - Bloomfield VFD,BLU - Blue Lake VFD,BLY - Blythe FD,BDB - Bodega Bay FPD,BOD - Bodega VFD,BOH - Bohemian Grove FD,BOL - Bolinas FPD,Bon - Bonita Sunnyside FPD,BGO - Borrego Springs FD,BOU - Boulder Creek FPD,BLV - Boulevard Fire & Rescue Dept.,BRN - Branciforte FPD,BRW - Brawley FD,BRE - Brea FD,BGF - Briceland VFD,BCL - Briceland VFD,BRI - Bridgeport FPD,BRS - Brisbane FD,BCS - Brooktrails CSD FD,BRK - Burbank FD,BRB - Burbank Paradise FPD,BUF - Burney FPD,GLC - Butte City FD,BTC - Butte County FD,BTE - Butte Valley FPD,CNH - C & H Sugar Company FD,CSD - C Road CSD,CCI - Ca Correctional Inst. Tehachapi,CRC - CA Rehabilitation Center FD,CAS - CA State Prison FD - Lancaster,CFC - Cachagua FPD,CBI - Cahuilla Band of Indians FD,CCN - Calaveras Consolidated Fire Auth.,CLX - Calexico FD,CMC - Calif. Mens Colony FD,CAC - California City FD,CCC - California Conservation Corps,CCO - California Correctional Center,CDC - California Dept. of Corrections,DOT - California Dept. of Transportation,CIW - California Inst. For Women - Corona,CNA - California National Guard (Army),CPV - California Pines FD,CSP - California State Parks,CMS - Calimesa FD,CPT - Calipatria FD,CLP - Calipatria Prison FD,CAL - Calistoga FD,CMB - Cambria FD,CAM - Cameron Park FD,CMK - Camp Meeker VFD,PRK - Camp Park CSTC FD,MCP - Camp Pendleton FD,BOB - Camp Roberts Emergency Services,CPO - Campo Fire & Rescue (csa-112),CBK - Campo Reservation FD,CTN - Camptonville VFD,CAN - Canby FPD,CYN - Canyon Lake FD,CPY - Capay FPD,PAY - Capay Valley FPD,NV-CAR - Carlin VFD,CAR - Carlotta CSD,CBD - Carlsbad FD,CBS - Carmel by the Sea FD,CHF - Carmel Highlands FPD,CVF - Carmel Valley FPD,CRP - Carpinteria-Summerland FPD,NV-CCF - Carson City FD,CPD - Castella FPD,CDR - Cathedral City FD,CAY - Cayucos FPD,CAZ - Cazadero FD,PVP - CDC, Pleasant Valley State Prison,CTF - CDCR Correctional Training Facility,TPC - CDCR, Kern Valley State Prison,AEU - CDF - Amador/El Dorado Unit,BTU - CDF - Butte Unit,CNR - CDF - California Northern Region -,CSR - CDF - California Southern Region -,CFA - CDF - Fire Academy,FKU - CDF - Fresno/Kings Unit,HUU - CDF - Humboldt/Del Norte Unit,LMU - CDF - Lassen/Modoc Unit,MMU - CDF - Madera/Mariposa/Merced Unit,MEU - CDF - Mendocino Unit,NEU - CDF - Nevada/Yuba/Placer Unit,RRU - CDF - Riverside Ranger Unit,CDF - CDF - Sacramento HQ,BEU - CDF - San Benito Monterey Unit,BDU - CDF - San Bernardino Unit,MVU - CDF - San Diego Unit,SLU - CDF - San Luis Obispo Unit,CZU - CDF - San Mateo/Santa Cruz Unit,SCU - CDF - Santa Clara Unit,SHU - CDF - Shasta/Trinity Unit,SKU - CDF - Siskiyou Unit,LNU - CDF - Sonoma Lake Napa Unit,TGU - CDF - Tehema/Glenn Unit,TUU - CDF - Tulare Unit,TCU - CDF - Tuolumne/Calaveras Unit,CDV - Cedarville FPD,CEP - Centinela State Prison FD,CCF - Central Calaveras FPD,CWF - Central California Womens Facility,CEN - Central County FD,CTL - Central FPD,NV-CLC - Central Lyon County Fire Protection,CES - Ceres DPS Fire Division,CSC - CFA of Sonoma County,CVV - Chalfant Valley FD,CHE - Chester FPD,OIL - Chevron FD,CVN - Chevron Refinery FD,CHI - Chico FD,CIM - California Inst. for Men- Chino,CHO - Chino Valley Ind. FD,CHW - Chowchilla VFD,CCK - Chuckawalla Valley State Prison FD,CHV - Chula Vista FD,AGL - City of Angels FD,IMR - City of Imperial FD,YUC - City Of Yucaipa FD,NV-CLR - Clark County FD,CBF - Clarksburg FPD,CLC - Clear Creek CSD,CLE - Clements Rural FPD,CLD - Cloverdale FPD,CLV - Clovis FD,MFC - CMF FD,COA - Coachella FPD,CVR - Coachella NWR,CLG - Coalinga FD,CFR - Coastside FPD,CCV - Coffee Creek VFC,CFX - Colfax FD,CGV - Collegeville FPD,CLM - Colma FPD,COL - Colton FD,CCD - Columbia College FD,CLB - Columbia FPD,CLS - Colusa FD,MCT - Combat Center FD (USMC),CMT - Comptche CSD VFD,CMP - Compton FD,CPR - Conoco - Phillips Rodoe Refinery,CCH - Contra Costa County Environmental H,Con - Contra Costa County FPD,CCW - Contra Costa Water District,COC - Copco Lake FPD,COP - Copperoplis FPD,CPK - Corcoran State Prison FD,CFD - Cordelia FPD,CNG - Corning VFD,COR - Corona FD,CRD - Coronado FD,CMD - Corte Madera FD,COS - Costa Mesa Fire Department,CSM - Cosumnes CSD,COT - Cottonwood FPD,CLF - Courtland FPD,CVL - Covelo FPD,CRS - Crescent City VFD,CRT - Cresent FPD,CRF - Crest Forest FPD,CRK - Crockett-Carquinez FPD,CUL - Culver City FD,CYP - Cypress FPD,DAG - Daggett CSD,DAL - Daly City FD,DAV - Davis Creek FPD,DVS - Davis FD,DLV - De Luz VFD,DSF - Deer Springs FD,DLA - Def. Logistics Agency / Def. Dist.,DMR - Del Mar FD,DLT - Delta Fire P. D. (Rio Vista),DEN - Denair FPD,DSH - Desert Hot Springs FD,TDV - Deuel Vocational Institution,DSP - Diamond Springs - El Dorado FPD,DIN - Dinuba FD,DIX - Dixon FD,DOF - Dobbins-Oregon House FPD,Don - Donner Summit FD,DCF - Donovan Correctional Facility,DOR - Dorris Fire Department,DOS - Dos Palos VFD,DOU - Douglas City VFD,DOW - Dow Chemical Co. FD,DNY - Downey FD,DWN - Downieville FPD,DRV - Downriver VFC,DOY - Doyle FPD,DCB - Dry Creek Rancheria FD,DCR - Dry Creek VFPD,DNN - Dunnigan FPD,DUN - Dunsmuir FD,DUT - Dutch Flat VFD,EAG - Eagleville FPD,EBY - East Bay Regional Parks FD,CCE - East Contra Costa F P D,ECO - East County FD,EDF - East Davis FPD,EDI - East Diablo FPD,NV-EFK - East Fork FPD,NCL - East Nicolaus FD,EBB - Ebbetts Pass FPD,FPB - Edwards AFB Fire Protection Div.,ELC - El Cajon FD,ECN - El Centro FD,ECR - El Cerrito FD,ECF - El Dorado Co. FPD,EDH - El Dorado Hills FD,EMD - El Medio FPD,ELS - El Segundo FD,SDC - Eldridge FD,EFF - Elfin Forest/Harmony Grove FD,ELK - Elk Creek FPD,EKV - Elk VFD, Elk CSD,EHF - Elkhorn VFD,NV-ELK - Elko FD,NV-ELY - Ely FD,ENC - Encinitas FD,ESL - Escalon Consolidated FPD,ESC - Escondido FD,ESP - Esparto FPD,ETN - Etna FD,EXE - Exeter FD,FRF - Fairfield FD,FAL - Fall River Mills FPD,FLL - Fallen Leaf FD,NV-FAL - Fallon FD,FMV - Farmersville FD,FAR - Farmington Rural FPD,LCI - Federal Correctional Complex, FD,FFD - Federal FD,TNT - Federal FD,FFV - Federal FD Ventura County,FEL - Felton FPD,FEN - Ferndale FPD,NV-FRN - Fernley FD,FBR - Fieldbrook FD,FLM - Fillmore VFD,FRB - Firebaugh FD,FIV - Five Cities Fire Authority,FOL - Folsom Fire Department,FPF - Folsom Prison Fire & Rescue,FTL - Foothill FPD,FHF - Foresthill FPD,FRV - Forestville FPD,FTB - Fort Bidwell FD,BRG - Fort Bragg Fire Protection,FDK - Fort Dick FPD,FHL - Fort Hunter-Liggett FD,IRW - Fort Irwin FD,FTJ - Fort Jones FD,FTR - Fort Ross VFC,FRT - Fortuna FPD,FOS - Foster City Fire Department,FVY - Fountain Valley FD,FOW - Fowler FD,FRE - Fremont FD,FRC - French Camp Mckinley FPD,FDA - Fresno Airport FD,FRN - Fresno City FD,FCO - Fresno County FPD,FLV - Fruitland VFC,FUL - Fullerton FD,DVF - Furnace Creek VFD,NV-XYZ - Future Nevada FD,BRR - FWS - Bitter Creek NWR,TNR - FWS - San Diego Complex of Refuges,LUR - FWS - San Luis NWR Complex,HPR - FWS-Hopper Mountain NWR,GAR - Garberville FPD,GGV - Garden Grove FD,GRV - Garden Valley FPD,GAS - Gasquet FPD,GAZ - Gazelle FPD,GEO - Georgetown FPD,GER - Gerber FD,GEY - Geyserville FPD,GIL - Gilroy FD,GLE - Glen Ellen FPD,GLN - Glendale FD,GCF - Glenn-Codora FPD,GFD - Gold Ridge FPD,GNZ - Gonzales VFD,GRA - Graeagle FPD,GRT - Grand Terrace FD,GRS - Grass Valley FD,GTN - Graton FPD,GRN - Greenfield FPD,GHC - Greenhorn Creek CSD/VFD,GVF - Greenville FPD,GWR - Greenwood Ridge Rd,GND - Grenada FPD,GRD - Gridley FD,GCS - Groveland CSD FD,GUA - Guadalupe FD,GUS - Gustine VFD,HCS - Hallwood CSD 10,HBF - Hamilton Branch FPD,HAM - Hamilton City FD,HMM - Hammond Ranch Fire Company,HAN - Hanford FD,HAP - Happy Camp FPD,HVF - Happy Valley FPD,HBV - Hawkins Bar VFD,HYF - Hayfork FPD,HAY - Hayward FD,HEA - Healdsburg FD,HCF - Hearst Castle FD,HTL - Heartland Communications Center,HMT - Hemet FD,NV-HEN - Henderson FD,HER - Herald FPD,HMB - Hermosa Beach FD,HES - Hesperia FD,HGF - Higgins Area FPD,HIG - Highland FD,HOL - Hollister FD,HTF - Holt FD,HLT - Holtville FD,HIA - Hoopa Valley Tribe FD - BIA,HOO - Hoopa VFD,HOP - Hopland VFD,HOR - Hornbrook, FPD,HGS - Hughson FPD,HUM - Humboldt Bay Fire Authority,HFR - Hume Lake VFRC,HTB - Huntington Beach FD,HLV - Huntington Lake Volunteer FD,HYM - Hyampom FD,IDL - Idyllwild Fire Protection District,IMB - Imperial Beach FD,IMP - Imperial CFD,IDP - Independence FPD,INW - Indian Wells FD,IND - Indio FD,IMF - Intermountain Fire & Rescue,INV - Inverness P.U.D. (ifd),Ion - Ione FD,IBV - Irish Beach VFD,ISL - Isleton FD,JCK - Jackson Valley FPD,JKS - Jackson VFD,JST - Jamestown FPD,JNV - Janesville FPD,JNR - Jenner VFD,JPL - Jet Propulsion Laboratory FD,JVF - Julian Cuyamaca FPD,JCF - Junction City FPD,JUN - June Lake FPD,KAN - Kanawha FPD,KEE - Keeler Fire Company,KLS - Kelseyville FPD,KNT - Kentfield FPD,KWD - Kenwood FPD,KRN - Kern County Fire Department,KEY - Keyes FPD,KIN - King City FD,KCF - Kings CFD,KNG - Kingsburg FD,KRK - Kirkwood VFD,KJC - KJC Operating Co. Emerg. Response,KLA - Klamath Fpd,KLR - Klamath River Fire Company,KFD - Kneeland FPD,KNI - Knights Landing VFD,KNV - Knights Valley VFD,LHH - La Habra Heights FD,LMS - La Mesa FD,LPR - La Porte FPD,LAQ - La Quinta FD,LVN - La Verne FD,LAB - Laguna Beach FD,LKC - Lake City FPD,LSH - Lake County FPD,LSN - Lake Elsinore,LFV - Lake Forest VFD,LST - Lake Shastina Consolidated FD,LAV - Lake Valley FPD,LKP - Lakeport Fire Protection District,LKS - Lakeside FPD,LKV - Lakeville VFD,LRK - Larkspur FD,NV-LVS - Las Vegas Fire & Rescue,LMD - Lathrop - Manteca FPD,LAT - Laton FPD,LTB - Latrobe FPD,LLL - Lawrence Livermore Nat. Lab. FD,LEE - Lee Vining VFD,LEG - Leggett Valley FPD,LGV - Lemon Grove FD,LEM - Lemoore VFD,LEW - Lewiston FD,LIB - Liberty Rural FPD,LIK - Likely FPD,LNC - Lincoln FD,LNA - Linda FPD,LPE - Linden-peters Rural FPD,LNS - Lindsay FD,LTL - Little Lake FPD,LVV - Little Valley CSD,LAP - Livermore/ Pleasanton FD,LVG - Livingston FD,LHM - Lockheed Miss & Space FD,LFP - Lockwood FPD,LOD - Lodi FD,LOL - Loleta FPD,LOM - Loma Linda FD,LRB - Loma Rica-Browns Valley CSD,LMP - Lompoc FD,LPN - Lone Pine VFD,LOB - Long Beach FD,LVL - Long Valley FD,LVF - Long Valley FPD,LNG - Long Valley VFD,LOO - Lookout FPD,LMF - Loomis FPD,LOS - Los Alamitos JFTB,LAC - Los Angeles County FD,LFD - Los Angeles FD,LBN - Los Banos VFD,NV-LOV - Lovelock FD,LSW - Lower Sweetwater FPD,LOY - Loyalton VFD,LCC - Lytle Creek Station 20,MAD - Madeline FPD,MDC - Madera County FD,MDA - Madera FD,MDS - Madison FPD,MAM - Mammoth Lakes FPD,MHB - Manhattan Beach FD,MAN - Manteca FD,MZP - Manzanar National Historic Site,CMV - Maple Creek VFC,MAB - March Air Reserve Base FD,MRN - Marin County FD,MWD - Marin Municipal Water Dist.,MAR - Marina FD,MSM - Marine Corps Air Station Miramar FD,MCB - Marine Corps Logistics Base FD,MRW - Marinwood FD,MPA - Mariposa County FD,MRI - Mariposa MPUD,MRK - Markleeville VFD,MRC - Martinez Refining Co. - FD,MAY - Marysville FD,MAX - Maxwell FPD,MYC - Mayacamas VFD,MTN - Mayten Fire District,MCA - McArthur VFD,MCU - Mccloud FD,MVF - Meadow Valley FPD,MEK - Meeks Bay FPD,MFW - Mendocino CFW - County OES,MND - Mendocino FPD,MEN - Mendota FD,MFE - Menifee FD - Cal Fire,MNL - Menlo Park FPD,MRD - Merced County FD,MER - Merced FD,MDN - Meridian FD,MGR - Mesa Grande FD,MCC - Mid - Coast Fire Brigade,MOS - Mid-Pennisula Open Space District,MLF - Milford FPD,MLV - Mill Valley FD,MIL - Millbrae FD,MVL - Millville FPD,MLP - Milpitas FD,NV-MIN - Mineral FD,MIR - Miranda CSD,WUK - Mi-Wuk / Sugar Pine FPD,RFA - Modesto Regional Fire Authority,MOF - Moffett FD,MOK - Mokelumne Hill FPD,MKE - Mokelumne Rural FD,Mon - Mono City FPD,MRV - Monrovia Fire Department,MTF - Montague FPD,MTC - Montclair FD,MRO - Monte Rio FPD,MTB - Montebello FD,MTO - Montecito FPD,MCF - Monterey County Regional Fire Dist.,MNT - Monterey Fire Department,MPK - Monterey Park FD,PMA - Monterey Penninsula Airport Dist.,ZUM - Montezuma FPD,MTZ - Montezuma FPD (Rio Vista),RAN - Montezuma Valley VFD,MTG - Montgomery Creek VFC,MOR - Moraga-Orinda FPD,MOE - Moreno Valley FD,MRF - Morongo Indian Reservation FD,MGO - Morongo Valley CSD,MRB - Morro Bay FD,MQT - Mosquito FPD,MSH - Mount Shasta FPD,MFR - Mountain Fire & Rescue,WMG - Mountain Gate FD,MCM - Mountain Training Warfare Center -,MVY - Mountain Valley VFD,MOU - Mountain VFD,MTV - Mountain View FD,MVW - Mountain View FPD,MRA - Mountains Recreation & Conservation,MLG - Mt Laguna VFD,BDY - Mt. Baldy FD,MTS - Mt. Shasta FD,MSV - Mt. Shasta Vista VFC,MUI - Muir Beach VFD,MUP - Mule Creek State Prison,MRP - Murphys FPD,MUR - Murrieta FPD,MYR - Myers Flat FPD,NPA - Napa County FD,NAP - Napa FD,NSH - Napa State Hospital FD,NLE - NAS Lemoore FD,NAT - National City FD,NAF - Naval Air Facility FD,NV-NAS - Naval Air Station Fallon,NSW - Naval Surface Warfare Center FD,NVW - Naval Weapons Station FD,NWC - NAWS China Lake FD,NED - Needles FD,NV-NEL - Nellis Air Force Base FD,NEV - Nevada City FD,NCC - Nevada County Consolidated FD,NCO - Nevada County FD,NV-NDF - Nevada Division Of Forestry,NV-NTS - Nevada Test Site,NRK - Newark FD,NBY - Newberry Springs FD,NEW - Newcastle FPD,NSP - Newhall FPD,NWM - Newman VFD,NPB - Newport Beach FD,NCS - Nicasio VFD,NIL - Niland FD,NOR - Norco FD,NCN - North Central FPD,SWR - North Central Valley Fire Mgmt Zone,NCM - North County Dispatch JPA,NCD - North County FPD,NCF - North County FPD (San Diego County),NKP - North Kern State Prison FD,NV-NLT - North Lake Tahoe FPD,NV-NLV - North Las Vegas FD,NV-NLC - North Lyon County FPD,NSJ - North San Juan FPD,NSC - North Sonoma Coast FPD,NTF - North Tahoe FPD,NTI - North Tree Fire International,NWF - Northern California Womens Facility,NCY - Northern California Youth Authority,NAG - Northrop Grumman FD,NSD - Northshore FPD,NRS - Northstar FD,NWL - Northwest Lassen FD,NOV - Novato FPD,GNP - NPS - Golden Gate NRA,LNP - NPS - Lassen Volcanic National Park,MNP - NPS - Mojave National Preserve,PIP - NPS - Pinnacles National Monument,SMP - NPS - Santa Monica Mtns. NRA,KNP - Nps - Sequoia-kings Canyon NP,WNP - NPS - Whiskeytown NRA,YNP - NPS - Yosemite National Park,ODF - Oakdale FD,ODL - Oakdale Rural FPD,OKL - Oakland FD,OCD - Occidental Fire - Community Service,OCS - Oceanside FD,OWF - Ocotillo Wells VFD,OES - Office of Emergency Services,OLC - Olancha-cartago,OLI - Olivehurst PUD,OAP - Ontario Airport FD,OTO - Ontario FD,OPH - Ophir Hill FPD,ORC - Orange County Fire Authority,OCF - Orange Cove FPD,ORG - Orange FD,OCT - Orcutt FPD,ORD - Ord Bend FPD,ORK - Orick CSD,ORL - Orland FPD,OLN - Orleans VFD,ORO - Oroville FD,OXD - Oxnard FD,PGF - Pacific Grove FD,PFC - Pacifica FD,NV-PAH - Pahrump Valley Fire Rescue Service,PDF - Painted Cave VFD,PAJ - Pajaro Valley FD,PAL - Pala FD,PDS - Palm Desert FD,PSP - Palm Springs FD,PAF - Palo Alto FD,PMV - Palomar Mountain VFD,PRA - Paradise FD,PRD - Paradise FPD,PAR - Parlier FD,PAS - Pasadena FD,PRF - Paso Robles FD (D. E. S.),PAT - Patterson FD,PYR - Pauma Reservation FD,PCP - Peardale Chicago Park FPD,PEB - Pebble Beach CSD FD,PFD - Pechanga FD,PBP - Pelican Bay State Prison Fire Depar,PNS - Peninsula FPD,PNV - Penn Valley FPD,RYN - Penryn Fire District,PER - Perris FD,PTL - Petaluma FD,PET - Petrolia FPD,PHL - Phillipsville FPD,PIE - Piedmont FD,PRC - Piercy FPD,PYG - Pigg Butt Fire Department,PIK - Pike City VFD,PRG - Pine Ridge VFD,PVY - Pine Valley FPD,POE - Pinole FD,PIO - Pioneer FPD,PSM - Pismo Beach FD,ROC - Placer Consolidated FPD,PCF - Placer County FD,PHF - Placer Hills FPD,PLW - Platina - Wildwood VFC,PLG - Pleasant Grove FD,PVF - Pleasant Valley Fire Control,PRS - Pliocene Ridge CSD,PEF - Plumas-Eureka FD,PLY - Plymouth FD,PVL - Porterville FD,POR - Portola FD,PMT - Post Mountain VFD,POT - Potter Valley CSD,POW - Poway FD,PRT - Prattville- Almanor FPD,PSF - Presidio FD,POM - Presido Of Monterey FD,PRN - Princeton FPD,QUI - Quincy FPD,RBC - Ramona Band of Cahuilla FD,RAM - Ramona Fire Department,RAD - Rancho Adobe FPD,RCF - Rancho Cucamonga FPD,RMG - Rancho Mirage FD,RSF - Rancho Santa Fe FPD,RBU - Red Bluff FD,RCV - Redcrest VFC,RDN - Redding FD,RED - Redlands FD,RDB - Redondo Beach FD,RDW - Redway FPD,RWO - Redwood City FD,PTA - Redwood Coast VFD,RWP - Redwood National Park,RVF - Redwood Valley/Calpella FPD,REE - Reedley FD,NV-RNO - Reno Fire Department,RES - Rescue FPD,PVT - Reserved PRIVATE RESOURCES,RIA - Rialto FD,RMD - Richmond FD,RCR - Rincon Reservation Fire Department,RIO - Rio Dell FPD,RLN - Rio Lindo Acad Fire Brigade,RVS - Rio Vista FD,RIP - Ripon FPD,RID - River Delta FPD,RVD - Riverdale PUD FD,RVC - Riverside County FD,RIV - Riverside FD,ROK - Rocklin FD,RDO - Rodeo-Hercules FPD,ROH - Rohnert Park DPS FD,RSV - Roseville FD,ROS - Ross DPS,RVY - Ross Valley FD,RAR - Rough & Ready FPD,RVA - Round Valley Tribe,RSP - Running Springs FD,AZ-RMY - Rural/Metro FD,RRF - Russian River FPD,RYR - Ryer Island FPD,MAF - Sac. County Airport System FD,SRC - Sac. Regional Fire/EMS Comm Center,SCR - Sacramento FD,SAC - Sacramento Metropolitan Fire Dist.,SRV - Sacramento River FPD,SLA - Salida FPD,SLS - Salinas Fire Department,SCV - Salmon Creek VFC,CCL - Salmon River VFR,SAL - Salton CSD,SSB - Salton Sea Beach VFD,SLV - Salyer VFD,SAM - Samoa Peninsula FPD,and - San Andreas FPD,SAF - San Antonio VFD,SAV - San Ardo VFC,SBN - San Benito County Fire Department,BDC - San Bernardino County FD,BDO - San Bernardino FD,SBR - San Bruno FD,SCS - San Carlos FD,SDP - San Diego County Dept of Plan.,SDF - San Diego County Fire Authority,SND - San Diego Fire - Rescue Department,SDR - San Diego Rural FD,SFR - San Francisco FD,SGB - San Gabriel FD,SJT - San Jacinto FD,SJS - San Jose FD,SJB - San Juan Bautista FD,SLC - San Luis Obispo County FD,SLO - San Luis Obispo FD,SMI - San Manuel FD,SMC - San Marcos FD,SMM - San Marcos Pass VFD,SNM - San Marino FD,CFS - San Mateo County Fire,PSC - San Mateo County Public Safety Comm,MEO - San Mateo FD,SMG - San Miguel Consolidated FPD,SMF - San Miguel FD,SNO - San Onofre FD, Southern California,SPI - San Pasqual Reservation FD,SPF - San Pasquel FD,QUN - San Quentin State Prison,SNR - San Rafael FD,SRM - San Ramon Valley FPD,SAN - Sanger FD,STA - Santa Ana Fire Department,STB - Santa Barbara City Fire Department,SBC - Santa Barbara County FD,XXX - Santa Barbara County Sheriff,CNT - Santa Clara County FD,SNC - Santa Clara FD,NET - Santa Cruz Cons. Emerg. Comm. Ctr.,CRZ - Santa Cruz County FD,SCZ - Santa Cruz FD,SFS - Santa Fe Springs FD,SMV - Santa Margarita VFD,SMR - Santa Maria FD,SMA - Santa Monica FD,SPA - Santa Paula FD,SRS - Santa Rosa FD,CHU - Santa Ynez Chumash Indians FD,RFB - Santa Ysabel Reservation FD,SNT - Santee FD,SAR - Saratoga FPD,SIT - Sausalito FD,SCH - Schell-Vista FPD,SCT - Scotia VFC,SVF - Scott Valley FPD,SCO - Scotts Valley FPD,TSR - Sea Ranch Fd,SEA - Seaside FD,SEB - Sebastopol FD,SEI - Seiad Valley FD,SLM - Selma FD,SHC - Shasta College FD,SHS - Shasta County FD,SHA - Shasta Fire District,SLF - Shasta Lake FPD,SHL - Shaver Lake FD,SHE - Shelter Cove CSD,SVV - Shelter Valley VFD,SAD - Sierra Army Depot  FES,SRA - Sierra City FPD,SCP - Sierra Conservation Center,SER - Sierra County FPD,NV-SFD - Sierra FPD,SMD - Sierra Madre FD,SIE - Sierra Valley FPD,SIS - Siskyou County FD,SKY - Skywalker Ranch Fire Brigade,SFP - Smartville FPD,SMT - Smith River FPD,SOL - Solana Beach FD,SCD - Solano County Sherrif Dept.,SLD - Soledad VFD,SOR - Sonny Bono Salton Sea NWR,SSR - Sonoma County DFS (csa 40),Son - Sonoma Valley Fire Rescue Authority,SOF - Sonora FD,SBY - South Bay FD,SCF - South Coast FPD,MDT - South Lake County FPD,SLT - South Lake Tahoe FD,SMY - South Monterey County FPD,SPS - South Pasadena FD,SPL - South Placer FPD,SSF - South San Francisco FD,SCC - South Santa Clara County Fire Distr,SOT - South Trinity VFD,SYR - South Yreka FPD,TSH - Southern Inyo FPD,SOM - Southern Marin FPD,NV-SPK - Sparks FD,EGL - Spaulding CSD FD,SWV - Speedway VF&R,SPK - Spreckels VFD,SPV - Spring Valley VFD,SQU - Squaw Valley FD,STH - St. Helena FD,STL - Standish Litchfield FPD,SUF - Stanford University Fire Marshall,SSL - Stanislaus Consolidated FPD,SFW - Stanislaus County Fire Warden,SNB - Stinson Beach FPD,STO - Stockton FD,SBG - Stones Bengard CSD,NV-SCF - Storey County FD,STW - Strawberry VFD,SUC - Suisun City FD,SUI - Suisun FPD,SNY - Sunnyvale DPS FD,SST - Sunshine Summit VFD,SSN - Susan River FPD,SUS - Susanville FD,SBF - Sutter Basin FPD,STC - Sutter County FD,SUT - Sutter Creek FD,SYC - Sycuan FD,TFT - Taft FD,NV-TDO - Tahoe-Douglas FPD,TAY - Taylorsville, FPD,THC - Tehachapi FD,TCR - Tehama County FD,TEL - Telegraph Ridge VFC,TMC - Temecula FD,TEM - Templeton FPD,TEN - Tennant FD,THO - Thornton FPD,TIB - Tiburon FPD,TIM - Timber Cove FPD,TOM - Tomales VFC,TOR - Torrance FD,TOS - Tosco Corporation FD,TRY - Tracy FD,TRV - Travis Air Force Base,TRN - Trinidad VFD,TCC - Trinity Center CSD,TRK - Truckee FPD,TLC - Tulare County FD,TLR - Tulare FD,TIA - Tule River Indian Reserv. Tribal FD,TUL - Tulelake Multi Co. FD,TLU - Tuolumne County FD,TUO - Tuolumne FPD,TMI - Tuolumne Rancheria FD,TUR - Turlock FD,TRL - Turlock Rural FPD,TWA - Twain Harte FPD,TWP - Twentynine Palms FD,TWO - Two Rock VFD,CGT - U.S. Coast Guard FD,UCB - UC Campus Fire Marshal,UCL - UC Campus Fire Marshal,UCR - UC Campus Fire Marshal,USB - UC Campus Fire Marshal,UCD - UC Davis FD,UCI - UC Irvine, Campus Fire Marshal,UCZ - UC Santa Cruz FPS,UKH - Ukiah FD,UKV - Ukiah Valley Fire District,UNU - Union City FD,UTC - United Technology Corporation,PSS - UNnocal/Molycorp,UPL - Upland FD,ANF - USFS - Angeles National Forest,CNF - USFS - Cleveland National Forest,ENF - USFS - El Dorado National Forest,NV-TOF - USFS - Humboldt-Toiyabe NF,INF - USFS - Inyo National Forest,KNF - USFS - Klamath National Forest,TMU - USFS - Lake Tahoe Basin Mgmt Unit,LNF - USFS - Lassen National Forest,LPF - USFS - Los Padres National Forest,MNF - USFS - Mendocino NF,MDF - USFS - Modoc National Forest,USF - USFS - Pacific SW Reg.l Office (FS5,PNF - USFS - Plumas National Forest,BDF - USFS - San Bernardino NF,SQF - USFS - Sequoia National Forest,SHF - USFS - Shasta-Trinity National Fore,SNF - USFS - Sierra NF,SRF - USFS - Six Rivers NF,OSC - USFS - Southern CA GACC,TNF - USFS - Tahoe National Forest,STF - USFS Stanislaus NF,ONC - USFS, Northern CA GACC,VAC - Vacaville Fire Department,VVF - Vacaville FPD,VLO - Valero Refinery Company FD,VLJ - Vallejo FD,VCF - Valley Center FPD,VFV - Valley Ford VFD,VOM - Valley of the Moon FPD,VAN - Van Duzen VFD,AFV - Vandenberg AFB FD,VEN - Ventura City Fire Department,VNC - Ventura County FD,VER - Vernon FD,VCV - Victorville FD,VJS - Viejas FD,VSA - Visalia FD,VTA - Vista FD & FPD,NV-XXX - Walker River VFD,WAL - Walnut Grove FD,BKS - Warner Brothers FD,WSR - Warner Springs Ranch FD,WSC - Wasco State Prison - CDC,WAF - Washington VFD,WMR - Waterloo-Morada FPD,WTS - Watsonville FD,WEA - Weaverville Fire District,WED - Weed FD,WEO - Weott VFD,WAC - West Almanor CSD,WCV - West Covina FD,WPL - West Plainfield FPD,WPT - West Point FPD,EYO - West Sacramento FD,WSF - West Stanislaus County FPD,WVF - Westhaven VFD,WML - Westmorland FD,WPF - Westport FD,WPV - Westport VFD,WWO - Westwood FD,VFC - Whale Gulch VFC,WFA - Wheatland Fire Authority,SWF - Wheeler Crest FPD,WHR - White Hawk Ranch VFC,WMT - White Mountain FPD,WHT - Whitehorn VFD,WDR - Wildomar FD- Cal Fire,WIL - Williams Fire Protection Authority,WCR - Willow Creek FPD,WOF - Willow Oak FPD,WWR - Willow Ranch FPD,WLO - Willows Rural FPD,WLM - Wilmar FD,WLL - Wilows FD,WLT - Wilton FPD,WNT - Winterhaven FPD,WFD - Winters FD,WOO - Woodbridge FPD,WDF - Woodfords VFD,WLF - Woodlake FD,WLA - Woodland Avenue FPD,WDL - Woodland FD,WOD - Woodside Fire Protection District,NV-YER - Yerington- Mason Valley FPD,YER - Yermo CSD,YDF - Yocha Dehe Fire Dept.,YOL - Yolo FD,YPC - Yosemite Concession Svs. Corp. FD,YRE - Yreka VFD,YUB - Yuba City FD,AZ-YMA - Yuma FD,AZ-YCS - Yuma Marine Corps Air Station FD,YIA - Yurok Indian Agency,ZAM - Zamora FPD,ZAY - Zayante FPD,ZEN - Zenia-Kettenpom VFD">
</cfif>
<cfajaximport tags="cfform,cfdiv">
<cfform name="app_fm" action="/fam/icap/positions/?team=#teamq#&position=#positionq#" method="post" enctype="multipart/form-data">
<div class="panel panel-success" style="max-width:880px;">
<div class="panel-heading">
<h3 class="panel-title">
<cfif #teamq# NEQ '' and #positionq# NEQ '' and #ada.recordcount# EQ 1>
<cfoutput><strong>Editing Application</strong> for <a href="/fam/icap/positions/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Position</span></strong> on <a href="/fam/icap/positions/?team=#teamq#"><strong>#teamq#</strong></a></cfoutput>
<cfelseif #teamq# NEQ '' and #positionq# NEQ '' and #ada.recordcount# EQ 0>
<cfoutput><strong>New Application</strong> for <a href="/fam/icap/positions/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Position</span></strong> on <a href="/fam/icap/positions/?team=#teamq#"><strong>#teamq#</strong></a></cfoutput>
<cfelse>
<cfdump var='#teamq#'>
<cfdump var='#positionq#'>
<cfdump var='#ada#'>
</cfif>
<span class="pull-right">
<div class="input-group input-group-sm">
<button class="btn btn-primary btn-xs" style="height:21px;padding-top:1px;" type="submit" name="app_fm"><i class='glyphicon glyphicon-ok'></i> save</button>
</div>
</span>
</h3>
</div>
<div class="panel-body form-horizontal">
<cfoutput query="FAMDB_user">
<input class="hidden" type="hidden" name="user_webcaaf" value="#username#">
<input class="hidden" type="hidden" name="user_firstname" value="#firstname#">
<input class="hidden" type="hidden" name="user_lastname" value="#lastname#">
<input class="hidden" type="hidden" name="user_email" value="#email#">
</cfoutput>
<input class="hidden" type="hidden" name="position_id" value="<cfoutput>#pada.position_id#</cfoutput>">
<input class="hidden" type="hidden" name="position" value="<cfoutput>#pada.position_title#</cfoutput>">
<input class="hidden" type="hidden" name="icteam_id" value="<cfoutput>#pada.icteam_id#</cfoutput>">
<input class="hidden" type="hidden" name="icteam_area" value="<cfoutput>#pada.icteam_area#</cfoutput>">
<input class="hidden" type="hidden" name="application_interest" value="">
<input class="hidden" type="hidden" name="application_curr_year" value="">
<cfif #teamq# NEQ '' and #positionq# NEQ '' and #ada.recordcount# EQ 1>
<cfoutput query='ada'>
<input class="hidden" type="hidden" name="application_id" value="#application_id#">
<input class="hidden" type="hidden" name="applicant_id" value="#applicant_id#">
<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
    <div class='col-xs-12 col-sm-6 col-md-6 col-lg-6 c' style="max-width:280px;">
        <div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c pull-right' style="max-width:420px;">
        <div class="form-group form-group-sm">
         <label class="control-label">Consideration:</label>
         <span class='pull-right'>
            <cfselect name="application_consideration" class="form-control input-sm" >
                    <cfif #pada.icteam_area# EQ 'California'>
                        <cfset cons="Primary,Trainee,">
                        <cfif ListFindNoCase(cons,'#ada.application_consideration#') EQ 0><option value disabled selected></option></cfif>
                    <cfelseif #pada.icteam_area# EQ 'PNW'>
                        <cfset cons="Primary,Alternate,Shared,Trainee,">
                        <cfif ListFindNoCase(cons,'#ada.application_consideration#') EQ 0><option value disabled selected></option></cfif>
                    <cfelseif #pada.icteam_area# EQ 'Southern'>
                        <cfset cons="Primary,Alternate,Apprentice,Trainee,">
                        <cfif ListFindNoCase(cons,'#ada.application_consideration#') EQ 0><option value disabled selected></option></cfif>
                    <cfelse>
                        <cfset cons="Primary,Alternate,Shared,Trainee,">
                        <cfif ListFindNoCase(cons,'#ada.application_consideration#') EQ 0><option value disabled selected></option></cfif>
                    </cfif>
                    <cfloop list="#cons#" index='a'>
                    <cfoutput>
                        <option value="#a#" <cfif #ada.application_consideration# EQ a> selected</cfif>>#a#</option>
                    </cfoutput>
                    </cfloop>
            </cfselect>
         </span>
        </div>
        <cfif #pada.icteam_area# EQ 'California'>
        <div class="form-group form-group-sm">
         <label class="control-label">Supervisor Approval:</label>
         <span class='pull-right'>
            <cfselect name="application_recommendation" class="form-control input-sm" >
                <cfif #pada.icteam_area# EQ 'California'>
                    <cfset cons="Yes,">
                    <cfif ListFindNoCase(cons,'#ada.application_recommendation#') EQ 0><option value disabled selected></option></cfif>
                <cfelse>
                    <cfset cons="Yes,No,">
                    <cfif ListFindNoCase(cons,'#ada.application_recommendation#') EQ 0><option value disabled selected></option></cfif>
                </cfif>
                <cfloop list="#cons#" index='a'>
                <cfoutput>
                    <option value="#a#" <cfif #ada.application_recommendation# EQ a> selected</cfif>>#a#</option>
                </cfoutput>
                </cfloop>
            </cfselect>
         </span>
        </div>
        <cfelse>
            <input class="hidden" type="hidden" name="application_recommendation" value="">
        </cfif>
        <cfif #pada.position_code# EQ "BUYM" or #pada.position_code# EQ "BUYL">
        <div class="form-group form-group-sm">
         <label class="control-label">Warrant:</label>
         <span class='pull-right'>
            <select name="position_warrant" class="form-control input-sm" >
                <cfif #ada.position_warrant# EQ ''><option value disabled selected></option></cfif>
                <cfloop list="Y,N," index="a">
                <cfoutput>
                    <option value="#a#" <cfif #ada.position_warrant# EQ a> selected</cfif>>#a#</option>
                </cfoutput>
                </cfloop>
            </select>
         </span>
         </div>
        <div class="form-group form-group-sm">
         <label class="control-label">Purchase authority:</label>
         <span class='pull-right'>
            <select name="position_po" class="form-control input-sm" >
                <cfif #ada.position_po# EQ ''><option value disabled selected></option></cfif>
                <cfloop list="Y,N," index="a">
                <cfoutput>
                    <option value="#a#" <cfif #ada.position_po# EQ a> selected</cfif>>#a#</option>
                </cfoutput>
                </cfloop>
            </select>
         </span>
        </div>
        <cfelse>
            <input class="hidden" type="hidden" name="position_warrant" value="">
            <input class="hidden" type="hidden" name="position_po" value="">
        </cfif>
    </div>
    </div>
    <div class='col-xs-12 col-sm-6 col-md-6 col-lg-6 c' style="max-width:480px;">
        <div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c' style="max-width:420px;">
            <div class="form-group form-group-sm">
             <label class="control-label">Applicant Category:</label>
             <span class='pull-right'>
                <cfselect name="applicant_retired" class="form-control input-sm" >
                    <cfif #pada.icteam_area# EQ 'California'>
                        <cfset cats="Federal Full-Time,Federal AD,Local Govt Full-Time 2080hr,Local Govt Part-Time < 2080hr,">
                        <cfif ListFindNoCase(cats,'#ada.applicant_retired#') EQ 0><option value disabled selected></option></cfif>
                    <cfelse>
                        <cfset cats="Federal Employee,State Employee,Local Government,AD,Supplemental,Emergency Fire Fighter (EFF),">
                        <cfif ListFindNoCase(cats,'#ada.applicant_retired#') EQ 0><option value disabled selected></option></cfif>
                    </cfif>
                    <cfloop list="#cats#" index='a'>
                    <cfoutput>
                        <option value="#a#" <cfif #ada.applicant_retired# EQ a> selected</cfif>>#a#</option>
                    </cfoutput>
                    </cfloop>
                </cfselect>
             </span>
            </div>
            <div class="form-group form-group-sm">
                <label class="control-label">Employment or Host Agency:</label>
                <span class='pull-right'>
                <cfselect class="form-control input-sm" name="applicant_fq_email_type" >
                    <cfif #pada.icteam_area# EQ 'California'>
                        <cfset cats="BIA,BLM,FS,F&WS,NPS,State,Local Government,">
                        <cfif ListFindNoCase(cats,'#ada.applicant_fq_email_type#') EQ 0><option value disabled selected></option></cfif>
                    <cfelse>
                        <cfset cats="BIA,BLM,FS,F&WS,NPS,State,Local Government,Rural Fire District,Other,">
                        <cfif ListFindNoCase(cats,'#ada.applicant_fq_email_type#') EQ 0><option value disabled selected></option></cfif>
                    </cfif>
                    <cfloop list="#cats#" index='a'>
                    <cfoutput>
                        <option value="#a#" <cfif #ada.applicant_fq_email_type# EQ a> selected</cfif>>#a#</option>
                    </cfoutput>
                    </cfloop>
                </cfselect>
                </span>
            </div>
        <cfif #pada.icteam_area# EQ 'California'>
            <div class="form-group form-group-sm">
                <label class="control-label">District, Forest, or Department:</label>
                <span class='pull-right'>
                <cfselect class="form-control input-sm" name="applicant_agency" >
                    <cfif ListFindNoCase(r5fds,'#trim(applicant_agency)#') EQ 0><option value disabled selected></option></cfif>
                    <cfloop list="#r5fds#" index='a'>
                    <cfoutput>
                        <option value="#a#" <cfif #trim(applicant_agency)# EQ a> selected</cfif>>#a#</option>
                    </cfoutput>
                    </cfloop>
                </cfselect>
                </span>
            </div>
        <cfelse>
            <div class="form-group form-group-sm">
                <label class="control-label">Employment or Host Agency if 'Other':</label>
                <span class='pull-right'>
                <cfinput  class="form-control input-sm" maxlength="100" name="applicant_agency" type="text" value="#ada.applicant_agency#" placeholder="Unit or Fire Department">
                </span>
            </div>
        </cfif>
        </div>
    </div>
<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
    <div class='col-xs-12 col-sm-6 col-md-6 col-lg-6 c'>
        <div class="form-group form-group-sm">
            <label class="control-label">Qualifications:</label>
            <span class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
            <cftextarea class="form-control input-sm" name="application_qualifications" rows="15" cols="22" style="height:72px;"><cfoutput>#application_qualifications#</cfoutput></cftextarea>
            </span>
        </div>
    </div>
</div>
</div>
</div>

<div class="panel-footer small">
<cfoutput><cfif #ada.aaupdated_by# NEQ ''>Your application for this position was last updated on #dateformat(ada.aaupdated, 'yyyy-mm-dd')# by <cfif #ada.uuemail# NEQ ''><a href="/fam/icap/users/?#ada.aaupdated_by#">#ada.uuemail#</a><cfelse>#ada.luemail#</cfif>.</cfif>
    <cfif #ada.status# EQ ''>You may withdraw your application below.
     <cfelseif #ada.status# EQ 'WITHDRAWN'> Your application was withdrawn on #dateformat(ada.status_date, 'yyyy-mm-dd')#. Restore your application below.
    </cfif>
</cfoutput>
</div>
</cfoutput>
<cfelseif #teamq# NEQ '' and #positionq# NEQ '' and #ada.recordcount# EQ 0>
    <input class="hidden" type="hidden" name="application_id" value="">
    <input class="hidden" type="hidden" name="applicant_id" value="<cfoutput>#ac.applicant_id#</cfoutput>">
<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
<div class='col-xs-12 col-sm-6 col-md-6 col-lg-6 c' style="max-width:280px;">
<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c pull-right' style="max-width:420px;">
    <div class="form-group form-group-sm">
     <label class="control-label">Consideration:</label>
     <span class='pull-right'>
        <cfselect name="application_consideration" class="form-control input-sm" >
            <cfif #pada.icteam_area# EQ 'California'>
                <cfset cons="Primary,Trainee,">
            <cfelseif #pada.icteam_area# EQ 'PNW'>
                <cfset cons="Primary,Alternate,Shared,Trainee,">
            <cfelseif #pada.icteam_area# EQ 'Southern'>
                <cfset cons="Primary,Alternate,Apprentice,Trainee,">
            <cfelse>
                <cfset cons="Primary,Alternate,Shared,Trainee,">
            </cfif>
            <option value disabled selected></option>
            <cfloop list="#cons#" index='a'>
            <cfoutput>
                <option value="#a#">#a#</option>
            </cfoutput>
            </cfloop>
        </cfselect>
     </span>
    </div>

    <cfif #pada.icteam_area# EQ 'California'>
    <div class="form-group form-group-sm">
     <label class="control-label">Supervisor Approval:</label>
     <span class='pull-right'>
        <cfselect name="application_recommendation" class="form-control input-sm" >
            <cfif #pada.icteam_area# EQ 'California'>
                <cfset cons="Yes,">
            <cfelse>
                <cfset cons="Yes,No,">
            </cfif>
            <option value disabled selected></option>
            <cfloop list="#cons#" index='a'>
            <cfoutput>
                <option value="#a#">#a#</option>
            </cfoutput>
            </cfloop>
        </cfselect>
     </span>
    </div>
    <cfelse>
        <input class="hidden" type="hidden" name="application_recommendation" value="">
    </cfif>
    <cfif #pada.position_code# EQ "BUYM" or #pada.position_code# EQ "BUYL">
    <div class="form-group form-group-sm">
     <label class="control-label">Warrant:</label>
     <span class='pull-right'>
        <cfselect name="position_warrant" class="form-control input-sm" >
            <option value disabled selected></option>
            <cfloop list="Y,N," index="a">
            <cfoutput>
                <option value="#a#">#a#</option>
            </cfoutput>
            </cfloop>
        </cfselect>
     </span>
     </div>
     <div class="form-group form-group-sm">
     <label class="control-label">Purchase authority:</label>
     <span class='pull-right'>
        <cfselect name="position_po" class="form-control input-sm" >
            <option value disabled selected></option>
            <cfloop list="Y,N," index="a">
            <cfoutput>
                <option value="#a#">#a#</option>
            </cfoutput>
            </cfloop>
        </cfselect>
     </span>
    </div>
    <cfelse>
        <input class="hidden" type="hidden" name="position_warrant" value="">
        <input class="hidden" type="hidden" name="position_po" value="">
    </cfif>
</div>
</div>
<div class='col-xs-12 col-sm-6 col-md-6 col-lg-6 c' style="max-width:480px;">
    <div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c' style="max-width:420px;">
        <div class="form-group form-group-sm">
         <label class="control-label">Applicant Category:</label>
         <span class='pull-right'>
            <cfselect name="applicant_retired" class="form-control input-sm" >
                <cfif #pada.icteam_area# EQ 'California'>
                    <cfset cats="Federal Full-Time,Federal AD,Local Govt Full-Time 2080hr,Local Govt Part-Time < 2080hr,">
                    <cfif ListFindNoCase(cats,'#ac.applicant_retired#') EQ 0><option value disabled selected></option></cfif>
                <cfelse>
                    <cfset cats="Federal Employee,State Employee,Local Government,AD,Supplemental,Emergency Fire Fighter (EFF),">
                    <cfif ListFindNoCase(cats,'#ac.applicant_retired#') EQ 0><option value disabled selected></option></cfif>
                </cfif>
                <cfloop list="#cats#" index='a'>
                <cfoutput>
                    <option value="#a#" <cfif #ac.applicant_retired# EQ a> selected</cfif>>#a#</option>
                </cfoutput>
                </cfloop>
            </cfselect>
         </span>
        </div>
        <div class="form-group form-group-sm">
            <label class="control-label">Employment or Host Agency:</label>
            <span class='pull-right'>
            <cfselect class="form-control input-sm" name="applicant_fq_email_type" >
                <cfif #pada.icteam_area# EQ 'California'>
                    <cfset cats="BIA,BLM,FS,F&WS,NPS,State,Local Government,">
                    <cfif ListFindNoCase(cats,'#ac.applicant_fq_email_type#') EQ 0><option value disabled selected></option></cfif>
                <cfelse>
                    <cfset cats="BIA,BLM,FS,F&WS,NPS,State,Local Government,Rural Fire District,Other,">
                    <cfif ListFindNoCase(cats,'#ac.applicant_fq_email_type#') EQ 0><option value disabled selected></option></cfif>
                </cfif>
                <cfloop list="#cats#" index='a'>
                <cfoutput>
                    <option value="#a#" <cfif #ac.applicant_fq_email_type# EQ a> selected</cfif>>#a#</option>
                </cfoutput>
                </cfloop>
            </cfselect>
            </span>
        </div>
        <cfif #pada.icteam_area# EQ 'California'>
            <div class="form-group form-group-sm">
                <label class="control-label">District, Forest, or Department:</label>
                <span class='pull-right'>
                <cfselect class="form-control input-sm" name="applicant_agency" >
                    <cfif ListFindNoCase(r5fds,'#trim(ac.applicant_agency)#') EQ 0><option value disabled selected></option></cfif>
                    <cfloop list="#r5fds#" index='a'>
                    <cfoutput>
                        <option value="#a#" <cfif #trim(ac.applicant_agency)# EQ a> selected</cfif>>#a#</option>
                    </cfoutput>
                    </cfloop>
                </cfselect>
                </span>
            </div>
        <cfelse>
            <div class="form-group form-group-sm">
                <label class="control-label">Employment or Host Agency if 'Other':</label>
                <span class='pull-right'>
                <cfinput  class="form-control input-sm" maxlength="100" name="applicant_agency" type="text" value="#ac.applicant_agency#" placeholder="Unit or Fire Department">
                </span>
            </div>
        </cfif>
    </div>
</div>
<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
<div class='col-xs-12 col-sm-6 col-md-6 col-lg-6 c'>
    <div class="form-group form-group-sm">
        <label class="control-label">Qualifications:</label>
        <span class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
        <cftextarea class="form-control input-sm" name="application_qualifications" rows="15" cols="22" style="height:72px;"></cftextarea>
        </span>
    </div>
</div>
</div>
</div>
</div>
<div class="panel-footer small">
You have not applied for this position. Enter your information above and hit 'save application' to apply.
</div>
</cfif>

</cfform>
<div>
    <cfif #ada.recordcount# NEQ 0 >
     <cfif #ada.status# EQ 'WITHDRAWN'>
        <span class="form-inline pull-right">
            <form name="application_restore" class="form-horizontal" method="POST" enctype="multipart/form-data" action="/fam/icap/positions/">
            <input class="hidden" type="hidden" name="application_id" value="<cfoutput>#ada.application_id#</cfoutput>">
            <input class="hidden" type="hidden" name="applicant_id" value="<cfoutput>#ada.applicant_id#</cfoutput>">
            <input class="hidden" type="hidden" name="position_id" value="<cfoutput>#pada.position_id#</cfoutput>">
            <input class="hidden" type="hidden" name="position" value="<cfoutput>#pada.position_title#</cfoutput>">
            <input class="hidden" type="hidden" name="icteam_id" value="<cfoutput>#pada.icteam_id#</cfoutput>">
            <input class="hidden" type="hidden" name="icteam_area" value="<cfoutput>#pada.icteam_area#</cfoutput>">
            <input class="hidden" type="hidden" name="application_interest" value="">
            <input class="hidden" type="hidden" name="application_curr_year" value="">
            <cfoutput query="FAMDB_user">
            <input class="hidden" type="hidden" name="user_webcaaf" value="#username#">
            <input class="hidden" type="hidden" name="user_firstname" value="#firstname#">
            <input class="hidden" type="hidden" name="user_lastname" value="#lastname#">
            <input class="hidden" type="hidden" name="user_email" value="#email#">
            </cfoutput>
            <input type="hidden" class="form-control" name="application_restore" size="" maxlength="" placeholder="" value="Y" >
            <button name="Submit" class="btn btn-success btn-xs" type="submit" id="Submit" value="Restore" formnovalidate="formnovalidate" onclick="return confirm('Are you sure you want to restore this application?');"><i class='glyphicon glyphicon-trash' style='font-size:80%'></i> restore application
            </button>
            </form>
        </span>
    <cfelseif #ada.status# EQ ''>
        <span class="form-inline pull-right">
            <form name="application_delete" class="form-horizontal" method="POST" enctype="multipart/form-data" action="/fam/icap/positions/">
            <input class="hidden" type="hidden" name="application_id" value="<cfoutput>#ada.application_id#</cfoutput>">
            <input class="hidden" type="hidden" name="applicant_id" value="<cfoutput>#ada.applicant_id#</cfoutput>">
            <input class="hidden" type="hidden" name="position_id" value="<cfoutput>#pada.position_id#</cfoutput>">
            <input class="hidden" type="hidden" name="position" value="<cfoutput>#pada.position_title#</cfoutput>">
            <input class="hidden" type="hidden" name="icteam_id" value="<cfoutput>#pada.icteam_id#</cfoutput>">
            <input class="hidden" type="hidden" name="icteam_area" value="<cfoutput>#pada.icteam_area#</cfoutput>">
            <input class="hidden" type="hidden" name="application_interest" value="">
            <input class="hidden" type="hidden" name="application_curr_year" value="">
            <cfoutput query="FAMDB_user">
            <input class="hidden" type="hidden" name="user_webcaaf" value="#username#">
            <input class="hidden" type="hidden" name="user_firstname" value="#firstname#">
            <input class="hidden" type="hidden" name="user_lastname" value="#lastname#">
            <input class="hidden" type="hidden" name="user_email" value="#email#">
            </cfoutput>
            <input type="hidden" class="form-control" name="application_delete" size="" maxlength="" placeholder="" value="Y" >
            <button name="Submit" class="btn btn-danger btn-xs" type="submit" id="Submit" value="Delete" formnovalidate="formnovalidate" onclick="return confirm('Are you sure you want to withdraw this application?');"><i class='glyphicon glyphicon-trash' style='font-size:80%'></i> withdraw application
            </button>
            </form>
        </span>
     <cfelse>
        <span class="form-inline pull-right">
        #ada.status#
        </span>
    </cfif>
    </cfif>
</div>
<cfelseif pada.position_status EQ 'Closed'>
<div class="panel panel-warning" style="max-width:880px;">
<div class="panel-heading">
<h3 class="panel-title">
<cfif #teamq# NEQ '' and #positionq# NEQ '' and #ada.recordcount# EQ 1>
<cfoutput>Your Application for <a href="/fam/icap/positions/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Position</span></strong> on <a href="/fam/icap/positions/?team=#teamq#"><strong>#teamq#</strong></a></cfoutput>
<cfelseif #teamq# NEQ '' and #positionq# NEQ '' and #ada.recordcount# EQ 0>
<cfoutput>No Application for <a href="/fam/icap/positions/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Position</span></strong> on <a href="/fam/icap/positions/?team=#teamq#"><strong>#teamq#</strong></a></cfoutput>
<cfelse>
<cfdump var='#teamq#'>
<cfdump var='#positionq#'>
<cfdump var='#ada#'>
</cfif>
</h3>
</div>
<div class="panel-body form-horizontal">
<cfoutput query="FAMDB_user">
    <input class="hidden" type="hidden" name="user_webcaaf" value="#username#">
    <input class="hidden" type="hidden" name="user_firstname" value="#firstname#">
    <input class="hidden" type="hidden" name="user_lastname" value="#lastname#">
    <input class="hidden" type="hidden" name="user_email" value="#email#">
</cfoutput>
<cfform name="app_fm" action="." method="post" enctype="multipart/form-data">
<cfoutput query='ada'>
    <input class="hidden" type="hidden" name="applicant_id" value="#applicant_id#">
<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
    <div class="form-group form-group-sm">
     <label class="control-label">Consideration:</label>
     <span class='pull-right'>
        <cfselect name="application_consideration" class="form-control input-sm" >
            <cfif #pada.icteam_area# EQ 'California'>
                <cfset cons="Primary,Trainee,">
                <cfif ListFindNoCase(cons,'#ada.application_consideration#') EQ 0><option value disabled selected></option></cfif>
            <cfelseif #pada.icteam_area# EQ 'PNW'>
                <cfset cons="Primary,Alternate,Shared,Trainee,">
                <cfif ListFindNoCase(cons,'#ada.application_consideration#') EQ 0><option value disabled selected></option></cfif>
            <cfelseif #pada.icteam_area# EQ 'Southern'>
                <cfset cons="Primary,Alternate,Apprentice,Trainee,">
                <cfif ListFindNoCase(cons,'#ada.application_consideration#') EQ 0><option value disabled selected></option></cfif>
            <cfelse>
                <cfset cons="Primary,Alternate,Shared,Trainee,">
                <cfif ListFindNoCase(cons,'#ada.application_consideration#') EQ 0><option value disabled selected></option></cfif>
            </cfif>
            <cfloop list="#cons#" index='a'>
            <cfoutput>
                <option value="#a#" <cfif #ada.application_consideration# EQ a> selected</cfif>>#a#</option>
            </cfoutput>
            </cfloop>
        </cfselect>
     </span>
    </div>
    <cfif #pada.icteam_area# EQ 'California'>
    <div class="form-group form-group-sm">
     <label class="control-label">Supervisor Approval:</label>
     <span class='pull-right'>
        <cfselect name="application_recommendation" class="form-control input-sm" >
            <cfif #pada.icteam_area# EQ 'California'>
                <cfset cons="Yes,">
                <cfif ListFindNoCase(cons,'#ada.application_recommendation#') EQ 0><option value disabled selected></option></cfif>
            <cfelse>
                <cfset cons="Yes,No,">
                <cfif ListFindNoCase(cons,'#ada.application_recommendation#') EQ 0><option value disabled selected></option></cfif>
            </cfif>
            <cfloop list="#cons#" index='a'>
            <cfoutput>
                <option value="#a#" <cfif #ada.application_recommendation# EQ a> selected</cfif>>#a#</option>
            </cfoutput>
            </cfloop>
        </cfselect>
     </span>
    </div>
    <cfelse>
        <input class="hidden" type="hidden" name="application_recommendation" value="">
    </cfif>
</div>
<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
    <div class="form-group form-group-sm">
        <label class="control-label">Qualifications:</label>
        <span class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
        <textarea class="form-control input-sm" name="application_qualifications" rows="15" cols="22" style="height:72px;"><cfoutput>#application_qualifications#</cfoutput></textarea>
        </span>
    </div>
</div>
<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
    <div class="form-group form-group-sm">
        <label class="control-label">Application Updated:</label>
        <span class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
        <cfoutput>#ada.aaupdated#</cfoutput> by <cfoutput>#ada.aaupdated_by#</cfoutput>
        </span>
    </div>
    <div class="form-group form-group-sm">
        <label class="control-label">Applicant Data Updated:</label>
        <span class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
        <cfoutput>#ada.qupdated#</cfoutput> by <cfoutput>#ada.qupdated_by#</cfoutput>
        </span>
    </div>
</div>
</cfoutput>
</cfform>
</div>
</div>
</cfif>
</div>
<cfelse>
<cfif #userq# NEQ ''>
 <cfset cols = 'p.icteam_id,t.icteam_name,p.position_id,p.position_code,p.position_title,p.updated,p.updated_by,pu.email_address as puemail,<cfif #dateq# NEQ ''>count(DISTINCT(case when aa.updated >= CAST(#dateq# AS DATE) then aa.applicant_id end))<cfelse>count(DISTINCT aa.applicant_id)</cfif> as applicants,s.position_status,s.updated as supdated,s.updated_by as supdated_by,su.email_address as suemail,<cfif #dateq# NEQ ''>count(DISTINCT(case when aa.updated >= CAST(#dateq# AS DATE) then aa.application_id end))<cfelse>count(DISTINCT aa.application_id)</cfif> as applications,aa.updated as applied'>
 <cfset heads = '_,Team,_,Position Code,Position,_,_,_,_,_,_,_,_,_,Applied'>
 <cfset refs = 'icteam_id,_,position_id,_,_,_,updated_by,puemail,_,_,_,supdated_by,suemail,_,_'>
 <cfset rebs = 'p.icteam_id,icap/positions/?team=,p.position_id,icap/positions/?position=,icap/positions/?position=,icap/positions/?position=,p.updated,p.updated_by,users/?,count(DISTINCT q.applicant_id) as applicants,s.position_status,s.updated as supdated,s.updated_by as supdated_by,users/?,count(DISTINCT aa.application_id) as applications,_'>
<cfelse>
<cfset cols = 'p.icteam_id,t.icteam_name,p.position_id,p.position_code,p.position_title,p.updated,p.updated_by,pu.email_address as puemail,<cfif #dateq# NEQ ''>count(DISTINCT(case when aa.updated >= CAST(#dateq# AS DATE) then aa.applicant_id end))<cfelse>count(DISTINCT aa.applicant_id)</cfif> as applicants,s.position_status,s.updated as supdated,s.updated_by as supdated_by,su.email_address as suemail,<cfif #dateq# NEQ ''>count(DISTINCT(case when aa.updated >= CAST(#dateq# AS DATE) then aa.application_id end))<cfelse>count(DISTINCT aa.application_id)</cfif> as applications'>
 <cfset heads = '_,Team,_,Position Code,Position,_,_,_,_,_,_,_,_,_'>
 <cfset refs = 'icteam_id,_,position_id,_,_,_,updated_by,puemail,_,_,_,supdated_by,suemail,_'>
 <cfset rebs = 'p.icteam_id,icap/positions/?team=,p.position_id,icap/positions/?position=,icap/positions/?position=,icap/positions/?position=,p.updated,p.updated_by,users/?,count(DISTINCT q.applicant_id) as applicants,s.position_status,s.updated as supdated,s.updated_by as supdated_by,users/?,count(DISTINCT aa.application_id) as applications'>
</cfif>
<cfquery name="tada" datasource="ICAP_Prod" maxrows=9000 result='tada1'>
select p.icteam_id,t.icteam_name,p.position_id,p.position_code,p.position_title,p.updated,p.updated_by,pu.email_address as puemail,<cfif #dateq# NEQ ''>count(DISTINCT(case when aa.updated >= CAST(#dateq# AS DATE) then aa.applicant_id end))<cfelse>count(DISTINCT aa.applicant_id)</cfif> as applicants,s.position_status,s.updated as supdated,s.updated_by as supdated_by,su.email_address as suemail,<cfif #dateq# NEQ ''>count(DISTINCT(case when aa.updated >= CAST(#dateq# AS DATE) then aa.application_id end))<cfelse>count(DISTINCT aa.application_id)</cfif> as applications<cfif #userq# NEQ ''>,aa.updated as applied</cfif>
from icap_positions p left join icap_teams t on p.icteam_id = t.icteam_id left outer join Region_6.dbo.login pu on p.updated_by = pu.webcaaf_id left outer join icap_positions_status s on p.position_id = s.position_id left outer join Region_6.dbo.login su on s.updated_by = su.webcaaf_id left outer join icap_positions_applicants q on p.position_id = q.position_id left outer join icap_applicants a on q.applicant_id = a.applicant_id left outer join Region_6.dbo.login au on a.applicant_eauth_id = au.webcaaf_id
<cfif #userq# NEQ ''>
outer apply (select TOP 1 * from icap_applications aa where aa.position_id = p.position_id and aa.applicant_id = a.applicant_id order by aa.updated desc) as aa
<cfelse>
left outer join icap_applications aa on p.position_id = aa.position_id
</cfif>
<cfif  #areaq# NEQ '' and #positionq# NEQ ''>
where t.icteam_area = '#areaq#' and p.position_code = '#positionq#'
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
<cfif #session.icap_role# NEQ 'M'>
<cfif #areaq# NEQ '' or #teamq# NEQ '' or #positionq# NEQ '' or #posidq# NEQ '' or #session.q# NEQ ''>
and t.icteam_area = '#fa#'
<cfelseif #userq# NEQ ''>
<cfelse>
where t.icteam_area = '#fa#'
</cfif>
</cfif>
and t.icteam_name is not null and t.icteam_name != '' and s.position_status <> 'Deleted' group by p.position_id,p.position_code,p.position_title,p.icteam_id,t.icteam_name,p.updated,p.updated_by,pu.email_address,s.position_status,s.updated,s.updated_by,su.email_address<cfif #userq# NEQ ''>,aa.updated</cfif> order by t.icteam_name ASC, position_code ASC
</cfquery>
<cfif #posidq# NEQ '' and #tada.recordcount# EQ 0>
<cfquery name="tada" datasource="ICAP_Prod" maxrows=9000>
select p.icteam_id,t.icteam_name,p.position_id,p.position_code,p.position_title,p.updated,p.updated_by,pu.email_address as puemail,count(DISTINCT q.applicant_id) as applicants,s.position_status,s.updated as supdated,s.updated_by as supdated_by,su.email_address as suemail,count(DISTINCT aa.application_id) as applications from icap_positions p left join icap_teams t on p.icteam_id = t.icteam_id left outer join Region_6.dbo.login pu on p.updated_by = pu.webcaaf_id left outer join icap_positions_status s on p.position_id = s.position_id left outer join Region_6.dbo.login su on s.updated_by = su.webcaaf_id left outer join icap_positions_applicants q on p.position_id = q.position_id left outer join icap_applicants a on q.applicant_id = a.applicant_id left outer join Region_6.dbo.login au on a.applicant_eauth_id = au.webcaaf_id left outer join icap_applications aa on p.position_id = aa.position_id where p.position_id = '#posidq#' and s.position_status <> 'Deleted' group by p.position_id,p.position_code,p.position_title,p.icteam_id,t.icteam_name,p.updated,p.updated_by,pu.email_address,s.position_status,s.updated,s.updated_by,su.email_address order by t.icteam_name ASC, position_code ASC
</cfquery>
</cfif>
<cfif #areaq# NEQ '' or #teamq# NEQ '' or #positionq# NEQ '' or #userq# NEQ '' or #posidq# NEQ '' or #session.q# NEQ '' or #dateq# NEQ ''>
<cfset ca = 'position_applicant_id,q.icteam_id,t.icteam_name,q.position_id,p.position_code,p.position_title,s.position_status,q.applicant_id,a.applicant_eauth_id,a.applicant_namei,a.applicant_nameii,a.applicant_nameiii,a.applicant_IQCS,q.applicant_type,q.applicant_valid,q.closed,q.closed_by,ucemail,q.updated,q.updated_by,uuemail,aa.application_consideration,aa.application_accept_deny,aa.application_valid,aa.updated as aaupdated,aa.updated_by as aaupdated_by,uaa.email_address as uaaemail,a.applicant_retired,a.applicant_fq_email_type,a.applicant_agency_address,a.applicant_city,a.applicant_country,a.applicant_area,a.applicant_zip_code,a.applicant_dispatch_agency,a.applicant_agreement_holder_agency,a.applicant_email_address,a.applicant_work_phone,a.applicant_home_phone,a.applicant_cell_phone,a.applicant_pager_number,a.applicant_dispatch_phone,a.applicant_fax_phone,a.applicant_jet_port,a.applicant_weight,a.applicant_agency'>
<cfset aheads = '_,_,team name,_,position code,_,status,_,_,first,middle,last,_,applicant type,applicant valid,closed,_,closed by,applicant updated,_,applicant updated by,application consideration,application accept/deny,application valid,application updated,_,application updated by,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_'>
<cfset arefs = '_,_,_,_,_,_,_,_,_,_,_,applicant_eauth_id,_,_,_,_,closed_by,ucemail,_,updated_by,uuemail,_,_,_,_,aaupdated_by,uaaemail,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_'>
<cfset arebs = 'position_applicant_id,_,icap/positions/?team=,q.position_id,icap/positions/?position=,_,_,p.position_id,_,q.applicant_id,a.applicant_eauth_id,icap/positions/?user=,_,_,icap/applicants,q.applicant_type,q.applicant_valid,users/?,q.closed_by,users,users/?,q.updated_by,users,aa.application_consideration,aa.application_accept_deny,_,users/?,this,users/?,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_'>
<cfquery name="oada_" datasource="ICAP_Prod" maxrows=90000>
select position_applicant_id,q.icteam_id,t.icteam_name,q.position_id,p.position_code,s.position_status,q.applicant_id,a.applicant_eauth_id,a.applicant_namei,a.applicant_nameii,a.applicant_nameiii,a.applicant_IQCS,q.applicant_type,q.applicant_valid,q.closed,q.closed_by,uc.email_address as ucemail,q.updated,q.updated_by,uu.email_address as uuemail,aa.application_consideration,aa.application_accept_deny,aa.application_valid,aa.updated as aaupdated,aa.updated_by as aaupdated_by,uaa.email_address as uaaemail,a.applicant_retired,a.applicant_fq_email_type,a.applicant_agency_address,a.applicant_city,a.applicant_country,a.applicant_area,a.applicant_zip_code,a.applicant_dispatch_agency,a.applicant_agreement_holder_agency,a.applicant_email_address,a.applicant_work_phone,a.applicant_home_phone,a.applicant_cell_phone,a.applicant_pager_number,a.applicant_dispatch_phone,a.applicant_fax_phone,a.applicant_jet_port,a.applicant_weight,a.applicant_agency from icap_positions_applicants q left join icap_positions p on q.position_id = p.position_id left join icap_teams t on q.icteam_id = t.icteam_id left join icap_applicants a on q.applicant_id = a.applicant_id left outer join Region_6.dbo.login u on a.applicant_eauth_id = u.webcaaf_id  left outer join Region_6.dbo.login uc on q.closed_by = uc.webcaaf_id  left outer join Region_6.dbo.login uu on q.updated_by = uu.webcaaf_id left outer join icap_applications aa on p.position_id = aa.position_id and q.applicant_id = aa.applicant_id left outer join Region_6.dbo.login uaa on aa.updated_by = uaa.webcaaf_id left outer join icap_positions_status s on p.position_id = s.position_id
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
<cfif #areaq# NEQ '' or #teamq# NEQ '' or #positionq# NEQ '' or #userq# NEQ '' or #posidq# NEQ '' or #session.q# NEQ ''>
<cfif #session.icap_role# EQ 'C'>
</cfif>
<cfif #session.icap_role# EQ 'I'>
</cfif>
<cfif #session.icap_role# EQ 'A'>
and a.applicant_eauth_id = '#fu#'
</cfif>
<cfelse>
<cfif #session.icap_role# EQ 'C'>
</cfif>
<cfif #session.icap_role# EQ 'I'>
</cfif>
<cfif #session.icap_role# EQ 'A'>
where a.applicant_eauth_id = '#fu#'
</cfif>
</cfif>
<cfif #dateq# NEQ ''>
and aa.updated >= CAST(#dateq# AS DATE)
</cfif>
order by t.icteam_name ASC, position_code ASC, aa.updated desc
</cfquery>
</cfif>
</cfif>
<div class="" style="padding-right:20px;">
<cfif isDefined('tada')>
<cfset cols = getMetadata(tada)>
<cfset colList = "">
<cfloop from="1" to="#arrayLen(cols)#" index="x"> <cfset colList = listAppend(colList, cols[x].name)> </cfloop>
<div class="panel panel-info" style="max-width:880px;">
<div class="panel-heading">
<h3 class="panel-title">
<cfif  #areaq# NEQ '' and #positionq# NEQ ''>
<cfoutput>#tada.recordcount# <a href="/fam/icap/positions/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Positions</span></strong> in <a href="/fam/icap/positions/?area=#areaq#"><strong>#areaq#</strong></a> <strong><span class="text-muted">Area</span></strong></cfoutput>
<cfelseif  #areaq# NEQ ''>
<cfoutput>#tada.recordcount# <strong><span class="text-muted">Positions</span></strong> in <a href="/fam/icap/positions/?area=#areaq#"><strong>#areaq#</strong></a> <strong><span class="text-muted">Area</span></strong></cfoutput>
<cfelseif  #teamq# NEQ '' and #positionq# NEQ ''>
<cfoutput>#tada.recordcount# <a href="/fam/icap/positions/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Positions</span></strong> on <a href="/fam/icap/positions/?team=#teamq#"><strong>#teamq#</strong></a></cfoutput>
<cfelseif #teamq# NEQ ''>
<cfoutput>#tada.recordcount# <strong><span class="text-muted">Positions</span></strong> on <a href="/fam/icap/positions/?team=#teamq#"><strong>#teamq#</strong></a></cfoutput>
<cfelseif  #positionq# NEQ ''>
<cfoutput>#tada.recordcount# <a href="/fam/icap/positions/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Positions</span></strong></cfoutput>
<cfelseif  #userq# NEQ ''>
<cfquery name="get_user" datasource="ICAP_Prod">
select applicant_namei,applicant_nameii,applicant_nameiii
from icap_applicants
where applicant_eauth_id = '#userq#'
</cfquery>
<cfoutput>#tada.recordcount# <strong><span class="text-muted">Positions</span></strong> with <strong><span class="text-muted">Applications</span></strong> by <strong><span class="text-muted">User</span> <a href="/fam/icap/positions/?user=#userq#">#get_user.applicant_namei# #get_user.applicant_nameii# #get_user.applicant_nameiii#</strong></a></strong></cfoutput>
<cfelseif #posidq# NEQ ''>
<cfoutput>#tada.recordcount# <strong><span class="text-muted">Positions</span></strong> with <a href="/fam/icap/positions/?posid=#posidq#"><strong><span class="text-muted">Position ID</span> #posidq#</strong></a></cfoutput>
<cfelse>
<cfoutput>#tada.recordcount#</cfoutput> <strong><span class="text-muted">Positions</span></strong>
</cfif>
<span class="form-inline pull-right">
<span style='margin-right:10px;'>
</span>
<form class="form-inline pull-right" style="max-width:300px;" action="/fam/icap/positions/" method="post" enctype="multipart/form-data">
<cfquery name="get_areas" datasource="ICAP_Prod">
select *
from icap_areas
order by area ASC
</cfquery>
<div class="input-group input-group-sm">
<select class="form-control input-sm" style="height:21px;" name="arealect">
<cfloop query="get_areas">
    <cfoutput><option value="#area#" <cfif #session.arealect# EQ "#area#">selected</cfif>>#area#</option></cfoutput>
</cfloop>
</select>
<span class="input-group-btn" style="font-size: 10px !important;">
<button class="btn btn-default btn-xs" style="height:21px;padding-top:1px;" type="submit" name="submit">select</button>
</span>
</div>
</form>
</span>
</h3>
</div>
<div class="panel-body">
<cfif #userq# NEQ ''>
Positions you have applied to are listed below. 
<cfelse>
Positions listed below are initially <strong>filtered to the area</strong> selected on your <a href="/fam/icap/applicant/"><strong>applicant record</strong></a>. To apply to positions in other areas, <strong>select a different area</strong> above.
</cfif>
</div>
<table class="table table-bordered table-condensed table-hover">
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
<th><small>Position Status</small></th>
</cfoutput>
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
<td <cfif col EQ 'action_page'>style="max-width:440px;"</cfif>>
<small>
<cfif col EQ 'position_title'>
<a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'>#tada[col][currentRow]#</strong><cfelseif position_status EQ 'Closed'><strong class='text-warning'>#tada[col][currentRow]#</strong></cfif></a>
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
<td>
<a href="./?team=#icteam_name#&position=#position_code#"><cfif position_status EQ 'Open'><strong class='text-success'>Open</strong></a> <a class="pull-right btn btn-default btn-xs" href="./?team=#icteam_name#&position=#position_code#" role="button">apply now</a><cfelseif position_status EQ 'Closed'><strong class='text-warning'>Closed</strong></a></cfif>
</td>
</tr>
</cfoutput>
</tbody>
</table>
<div class="panel-footer small">
<cfif #userq# NEQ ''>
Positions you have applied to are listed above. 
<cfelse>
Positions listed above are initially <strong>filtered to the area</strong> selected on your <a href="/fam/icap/applicant/"><strong>applicant record</strong></a>. To apply to positions in other areas, <strong>select a different area</strong> above.
</cfif>
</div>
</div>
</cfif>
<cfif isDefined('vada')>
<cfset vols = getMetadata(vada)>
<cfset volList = "">
<cfloop from="1" to="#arrayLen(vols)#" index="x"> <cfset volList = listAppend(volList, vols[x].name)> </cfloop>
<div class="panel panel-info" style="max-width:880px;">
<div class="panel-heading">
<h3 class="panel-title">
<cfif isDefined('vheads')>
<a href="/fam/icap/positions/"><strong>Position</strong></a> <cfoutput>#vada.position_code# <strong>&sect</strong> #vada.icteam_name#</cfoutput>
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
    <table class='table table-condensed table-bordered table-hover'>
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
            <cfif rf NEQ '_'>
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
Positions listed above are etc etc 3
</div>
</div>
</div>
</cfif>
<cfif isDefined('oada')>
<cfset ca = getMetadata(oada)>
<cfset colList = "">
<cfloop from="1" to="#arrayLen(ca)#" index="x"> <cfset colList = listAppend(colList, ca[x].name)> </cfloop>
<div class="panel panel-info" style="max-width:880px;">
<div class="panel-heading">
<h3 class="panel-title">
<cfif isDefined('vada')>
<cfoutput>#oada.recordcount#</cfoutput> <a href="/fam/icap/positions/"><strong><span class="text-muted">Applicants</span></strong></a> for <cfoutput><strong>#vada.position_code#</strong> <strong>&sect</strong> <strong>#vada.icteam_name#</strong></cfoutput>
<span class="form-inline pull-right">
<button class="btn btn-default btn-xs" type="add" name="Add">Add applicant</button>
</span>
<cfelse>
<cfif  #areaq# NEQ '' and #positionq# NEQ ''>
<cfoutput>#oada.recordcount# <a href="/fam/icap/positions/"><strong><span class="text-muted">Applicants</span></strong></a> for #tada.recordcount# <a href="/fam/icap/positions/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Positions</span></strong> in <a href="/fam/icap/positions/?area=#areaq#"><strong>#areaq#</strong></a> <strong><span class="text-muted">Area</span></strong></cfoutput>
<cfelseif  #areaq# NEQ ''>
<cfoutput>#oada.recordcount# <a href="/fam/icap/positions/"><strong><span class="text-muted">Applicants</span></strong></a> for #tada.recordcount# <strong><span class="text-muted">Positions</span></strong> in <a href="/fam/icap/positions/?area=#areaq#"><strong>#areaq#</strong></a> <strong><span class="text-muted">Area</span></strong></cfoutput>
<cfelseif  #teamq# NEQ '' and #positionq# NEQ ''>
<cfoutput>#oada.recordcount# <a href="/fam/icap/positions/"><strong><span class="text-muted">Applicants</span></strong></a> for #tada.recordcount# <a href="/fam/icap/positions/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Positions</span></strong> on <a href="/fam/icap/positions/?team=#teamq#"><strong>#teamq#</strong></a></cfoutput>
<cfelseif #teamq# NEQ ''>
<cfoutput>#oada.recordcount# <a href="/fam/icap/positions/"><strong><span class="text-muted">Applicants</span></strong></a> for #tada.recordcount# <strong><span class="text-muted">Positions</span></strong> on <a href="/fam/icap/positions/?team=#teamq#"><strong>#teamq#</strong></a></cfoutput>
<cfelseif  #positionq# NEQ ''>
<cfoutput>#oada.recordcount# <a href="/fam/icap/positions/"><strong><span class="text-muted">Applicants</span></strong></a> for #tada.recordcount# <a href="/fam/icap/positions/?position=#positionq#"><strong>#positionq#</strong></a> <strong><span class="text-muted">Positions</span></strong></cfoutput>
<cfelseif  #userq# NEQ ''>
<cfoutput>#oada.recordcount# <strong><span class="text-muted">Applications</span></strong> for #tada.recordcount# <strong><span class="text-muted">Positions</span></strong> by <strong><span class="text-muted">User</span> <a href="/fam/icap/positions/?user=#userq#">#get_user.applicant_namei# #get_user.applicant_nameii# #get_user.applicant_nameiii#</strong></a></strong></cfoutput>
<cfelseif #posidq# NEQ ''>
<cfoutput>#oada.recordcount# <a href="/fam/icap/positions/"><strong><span class="text-muted">Applicants</span></strong></a> for #tada.recordcount# <strong><span class="text-muted">Positions</span></strong> with <a href="/fam/icap/positions/?posid=#posidq#"><strong><span class="text-muted">Position ID</span> #posidq#</strong></a></cfoutput>
<cfelse>
<cfoutput>#oada.recordcount# <a href="/fam/icap/positions/"><strong><span class="text-muted">Applicants</span></strong></a> for #tada.recordcount# <strong><span class="text-muted">Positions</span></strong></cfoutput>
</cfif>
<span class="form-inline pull-right">
<button class="btn btn-default btn-xs" type="add" name="Add">Add applicant</button>
</span>
</cfif>
</h3>
</div>
<div class="panel-body">
Position applicants listed below are etc etc 4
</div>
<table class="table table-bordered table-condensed table-striped table-hover">
<thead>
<cfoutput>
<th><span class="caret"></span>
</th>
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
<tr class="<cfif position_status EQ 'Open' and application_valid EQ 'Y'>text-success<cfelseif position_status EQ 'Open' and application_valid EQ 'N'>text-success<cfelseif position_status EQ 'Closed' and application_valid EQ 'Y'>text-warning<cfelseif position_status EQ 'Closed' and application_valid EQ 'N'>text-warning</cfif>" role="tab" id="h_#position_applicant_id#">
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
<td<cfif hd EQ "Treatment Type"> class="_#position_applicant_id#text"</cfif><cfif isNumeric(oada[ca][currentRow])> style='text-align:right;'</cfif>>
<small>
<cfif rf NEQ '_'>
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
<td<cfif hd EQ "Treatment Type"> class="_#position_applicant_id#text"</cfif><cfif isNumeric(oada[ca][currentRow])> style='text-align:right;'</cfif>>
<small><cfif isDate(oada[ca][currentRow])><cfif hd CONTAINS 'fuel moisture'>#oada[ca][currentRow]#<cfelse>#dateformat(oada[ca][currentRow], 'yyyy-mm-dd')#</cfif><cfelseif ca EQ 'changed'>#tostring(oada[ca][currentrow])#<cfelse>#oada[ca][currentRow]#</cfif></small></td>
</cfif>
<cfset n = n + 1>
</cfloop>
</tr>
<tr id="c_#position_applicant_id#" class="panel-collapse collapse" role="tabpanel" aria-labelledby="h_#position_applicant_id#">
<td class="_#position_applicant_id#bc">
</td>
<cfset n = 18>
<td colspan=#n#>
<div class='col-xs-4 col-sm-4 col-md-4 col-lg-4 c'>
<label>Position ID:</label>
<span class='pull-right'>#position_id#</span>
<br>
<label>Name:</label>
<span class='pull-right'><cfif #applicant_nameIII# NEQ "">#applicant_nameI# #applicant_nameII# #applicant_nameIII#<cfelse>#applicant_name#</cfif></span>
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
<span class='pull-right'>#applicant_email_address#</span>
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
<label>Uploaded files:</label>
<cfquery name="check_files" datasource="ICAP_Prod">
select attachment_name,attachment_added,attachment_original_size
from icap_attachments
where applicant_id = #applicant_id#
</cfquery>
<cfif #check_files.recordcount# NEQ 0>
<ul>
<cfloop query="check_files">
<li><a href="http://162.79.30.150/ICAP/#attachment_name#" target="_blank">#attachment_name#</a> <span class='pull-right'>#attachment_added#</span></li>
</cfloop>
</ul>
<cfelse>
NO FILES ATTACHED
<br>
</cfif>
<br>
<br>
</div>
</td>
</tr>
</cfoutput>
</tbody>
</table>
<div class="panel-footer small">
Postion applicants listed above etc etc 5
</div>
</div>
</cfif>
</div>
<cfinclude template="/fam/gutter.cfm">
<cfif #isdefined('pada.icteam_area')#>
<script src="/fam/jquery-validation-1.14.0/dist/jquery.validate.js"></script>
<script src="/fam/jquery-validation-1.14.0/dist/additional-methods.min.js"></script>
<script src="/fam/jquery-validation-1.14.0/lib/jquery.maskedinput.js"></script>
<script>
$().ready(function() {
    $("#app_fm").validate({
        errorClass: "has-error",
        highlight: function(element) {
            $(element).parent().parent().addClass("has-error").removeClass("has-success");
        },
        unhighlight: function(element) {
            $(element).parent().parent().addClass("has-success").removeClass("has-error");
        },
        rules: {
            application_consideration: {
                required: true
            },
            application_recommendation: {
                required: true
            },
            applicant_qualifications: {
                required: true
            },
            applicant_retired: {
                required: true
            },
            applicant_fq_email_type: "required",
            applicant_agency: { // <- NAME attribute of the input
                required: {
                    depends: function () {
                        if ($("[name=applicant_fq_email_type]").val() == "Other"){
                            return true;
                            }else{
                            return true;
                            }
                    }
                }
            },
           agree: "required"
        },
        messages: {
            application_consideration: "Select one",<cfif #pada.icteam_area# EQ 'California'>
            application_recommendation: "<cfif #pada.icteam_area# EQ 'California'>Select YES to indicate supervisor approval.<cfelse>Select one.</cfif>",</cfif>      
            applicant_qualifications: "Enter your fire qualifications",
            applicant_retired: "Select your applicant category",
            applicant_fq_email_type: "Enter your employment or host agency",
            applicant_agency: "Enter your Unit (if you are Federal) or Fire Department (if you are Local)",
            agree: "Please accept our policy"
        }
    });
});
</script>
</cfif>
</body>
</html>