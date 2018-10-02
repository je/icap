<cfinclude template="/fam/icap/use.cfm">
<cfif structKeyExists(form, 'applicant_nameI')>
<cfset ser = ''>
<cfset serp = ''>
<cfoutput>
<cfloop list="#form.fieldnames#" index="i">
<cfset serp = "{#i#:#form[i]#}"
><cfset ser = ser & serp & '<br>'>
</cfloop>
</cfoutput>
</cfif>
<cfif structKeyExists(form, 'applicant_nameI')>
<cfquery name="icap_applicant_update" datasource="ICAP_Prod">
update dbo.icap_applicants set applicant_nameI = '#form.applicant_nameI#', applicant_nameII = '#form.applicant_nameII#', applicant_nameIII = '#form.applicant_nameIII#', applicant_city = '#form.applicant_city#', applicant_jet_port = '#form.applicant_jet_port#', applicant_zip_code = '#form.applicant_zip_code#', applicant_email_address = '#form.applicant_email_address#', applicant_work_phone = '#form.applicant_work_phone#', applicant_home_phone = '#form.applicant_home_phone#', applicant_cell_phone = '#form.applicant_cell_phone#', applicant_pager_number = '#form.applicant_pager_number#', applicant_dispatch_phone = '#form.applicant_dispatch_phone#', applicant_fax_phone = '#form.applicant_fax_phone#', applicant_qualifications = '#form.applicant_qualifications#', applicant_retired = '#form.applicant_retired#', applicant_IQCS = '#form.applicant_IQCS#', applicant_gaac_type = '#form.applicant_gaac_type#', applicant_area = '#form.applicant_area#', applicant_gaac_typeI = '#form.applicant_gaac_typeI#', applicant_agreement_holder_agency = '#form.applicant_agreement_holder_agency#', applicant_fq_email_type = '#form.applicant_fq_email_type#', applicant_agency = '#form.applicant_agency#', applicant_agency_address = '#form.applicant_agency_address#', applicant_ao_name = '#form.applicant_ao_name#', applicant_ao_email = '#form.applicant_ao_email#', applicant_aa_name = '#form.applicant_aa_name#', applicant_aa_email = '#form.applicant_aa_email#', applicant_fq_email = '#form.applicant_fq_email#', applicant_remarks = '#form.applicant_remarks#' where applicant_eauth_id = '#form.applicant_eauth_id#'
</cfquery>
<cfquery name="vfi" datasource="ICAP_Prod" >
select *
from icap_attachments f
left outer join icap_applicants a on f.applicant_id = a.applicant_id
where a.applicant_eauth_id = '#form.applicant_eauth_id#'
AND f.deleted_at is null
order by f.attachment_added desc
</cfquery>
<cfif #vfi.recordcount# NEQ 0>
<cfloop query='vfi'>
<cfif structkeyexists(form,"delete_file_#attachment_id#")>
<cfif #form["delete_file_" & attachment_id]# EQ "on">
<cfquery name="del" datasource="ICAP_Prod" maxrows="1">
update dbo.icap_attachments set deleted_at = '#today#' where attachment_id = '#attachment_id#'
</cfquery>
</cfif>
</cfif>
</cfloop>
</cfif>
<cfif #form.file1# NEQ "">
<cffile action="upload" filefield="file1" destination="D:\Inetpub\wwwroot\ICAP\" nameconflict="makeunique">
<cfset upload_file=#file.ServerFile#>
<cfquery name="upload_file1" datasource="ICAP_Prod">
insert into icap_attachments (applicant_id, attachment_name, attachment_original_name, attachment_original_size, attachment_added, attachment_added_by) values ('#form.applicant_id#', '#upload_file#', '#file.clientFile#', '#file.fileSize#', '#today#', '#form.applicant_eauth_id#')
</cfquery>
</cfif>
</cfif>
<cfif structKeyExists(form, 'applicant_nameI')>
<cfset msg_text = "Applicant record for <a class=""alert-link"" href=""/fam/users/?#form.applicant_eauth_id#"">#form.applicant_nameI# #form.applicant_nameII#</a> (<a class=""alert-link"" href=""/fam/users/?#form.applicant_eauth_id#"">#form.applicant_email_address#</a>) <a class=""alert-link"" href=""/fam/users/?#session.user_webcaaf#"">#session.user_firstname# #session.user_lastname#</a> (<a class=""alert-link"" href=""/fam/users/?#session.user_webcaaf#"">#session.user_email#</a>).">
<cfset msg_status = "success">
</cfif>
<style>
.alert {max-width:880px !important;}
</style>
<cfinclude template="/fam/lo.cfm">
<cfif isdefined('q')>
<cfset session.q = #q#>
<cfelse>
<cfset session.q = ''>
</cfif>
<cfset roles = "M,C">
<cfajaximport tags="cfform,cfdiv">
<cfform name="app_fm" action="/fam/icap/applicant/" method="post" enctype="multipart/form-data">
<div class="panel panel-info" style="max-width:880px;">
<div class="panel-heading">
<h3 class="panel-title">
<cfif ListFindNoCase(roles,'#FAMDB_user.icap_role#') GT 0 and #cgi.query_string# NEQ ''>
<cfif #cgi.query_string# CONTAINS 'appid='>
<cfset appid = replace(cgi.query_string,'appid=','') />
<cfquery name="ada" datasource="ICAP_Prod">
select ia.*, ig.gaac_code from icap_applicants ia left outer join icap_gaac ig on ia.APPLICANT_GAAC_TYPEI = ig.gaac where ia.applicant_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#appid#">
</cfquery>
<strong>Editing Applicant Record by AppID</strong>
<span class="pull-right">
<div class="input-group input-group-sm">
<button class="btn btn-primary btn-xs" style="height:21px;padding-top:1px;" type="submit" name="app_fm"><i class='glyphicon glyphicon-ok'></i> save</button>
</div>
</span>
<cfelse>
<cfquery name="ada" datasource="ICAP_Prod">
select ia.*, ig.gaac_code from icap_applicants ia left outer join icap_gaac ig on ia.APPLICANT_GAAC_TYPEI = ig.gaac where ia.applicant_eauth_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.query_string#">
</cfquery>
<strong>Editing Applicant Record</strong>
<span class="pull-right">
<div class="input-group input-group-sm">
<button class="btn btn-primary btn-xs" style="height:21px;padding-top:1px;" type="submit" name="app_fm"><i class='glyphicon glyphicon-ok'></i> save</button>
</div>
</span>
</cfif>
<cfelseif #session.q# NEQ ''>
<cfelse>
<cfquery name="ada" datasource="ICAP_Prod">
select ia.*, ig.gaac_code from icap_applicants ia left outer join icap_gaac ig on ia.APPLICANT_GAAC_TYPEI = ig.gaac where ia.applicant_eauth_id = '#session.user_webcaaf#'
</cfquery>
<cfif #ada.recordcount# EQ '0'>
<cfquery name="insert_applicant" datasource="ICAP_Prod" maxrows="1">
insert into icap_applicants (applicant_eauth_id,applicant_name) values ('#FAMDB_user.username#','#FAMDB_user.firstname# #FAMDB_user.lastname#')
</cfquery>
<cfquery name="ada" datasource="ICAP_Prod">
select * from icap_applicants ia where ia.applicant_eauth_id = '#FAMDB_user.username#'
</cfquery>
</cfif>
<strong>Editing Applicant Record</strong>
<span class="pull-right">
<div class="input-group input-group-sm">
<button class="btn btn-primary btn-xs" style="height:21px;padding-top:1px;" type="submit" name="app_fm"><i class='glyphicon glyphicon-ok'></i> save</button>
</div>
</span>
</cfif>
</h3>
</div>
<div class="panel-body form-horizontal">
<cfoutput query="FAMDB_user">
<input class="hidden" type="hidden" name="applicant_eauth_id" value="#ada.applicant_eauth_id#">
<input class="hidden" type="hidden" name="user_webcaaf" value="#username#">
<input class="hidden" type="hidden" name="user_firstname" value="#firstname#">
<input class="hidden" type="hidden" name="user_lastname" value="#lastname#">
<input class="hidden" type="hidden" name="user_email" value="#email#">
</cfoutput>
<cfoutput query='ada'>
<input class="hidden" type="hidden" name="applicant_id" value="#applicant_id#">
<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
<div class='col-xs-12 col-sm-5 col-md-4 col-lg-4 c' style="max-width:280px;">
<div class="form-group form-group-sm">
<label class="control-label">First:</label>
<span class='pull-right'><cfinput type="text" class="form-control input-sm" id="applicant_nameI" value="#applicant_nameI#" name="applicant_nameI"></span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Middle:</label>
<span class='pull-right'><cfinput type="text" class="form-control input-sm" id="applicant_nameII" value="#applicant_nameII#" name="applicant_nameII" ></span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Last:</label>
<span class='pull-right'><cfinput type="text" class="form-control input-sm" id="applicant_nameIII" value="#applicant_nameIII#" name="applicant_nameIII"></span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">City:</label>
<span class='pull-right'>
<cfinput class="form-control input-sm" maxlength="40" name="applicant_city" type="text" value="#applicant_city#">
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">State:</label>
<span class='pull-right'>
<cfselect class="form-control input-sm" name="applicant_jet_port">
<cfif #applicant_jet_port# EQ ''><option value disabled selected></option></cfif>
<cfloop list="AL,AK,AZ,AR,CA,CO,CT,DE,DC,FL,GA,HI,ID,IL,IN,IA,KS,KY,LA,ME,MD,MA,MI,MN,MS,MO,MT,NE,NV,NH,NJ,NM,NY,NC,ND,OH,OK,OR,PA,RI,SC,SD,TN,TX,UT,VT,VA,WA,WV,WI,WY" index="a">
<cfoutput>
<option value="#a#" <cfif #applicant_jet_port# EQ a> selected</cfif>>#a#</option>
</cfoutput>
</cfloop>
</cfselect>
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Zip:</label>
<span class='pull-right'>
<cfinput class="form-control input-sm" maxlength="10" name="applicant_zip_code" type="text" value="#applicant_zip_code#">
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Email:</label>
<span class='pull-right'>
<cfinput class="form-control input-sm" maxlength="50" name="applicant_email_address" type="text" value="#applicant_email_address#">
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Work phone:</label>
<span class='pull-right'>
<cfinput class="form-control input-sm" maxlength="30" name="applicant_work_phone" type="text" value="#applicant_work_phone#">
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Home phone:</label>
<span class='pull-right'>
<cfinput class="form-control input-sm" name="applicant_home_phone" type="text" value="#applicant_home_phone#">
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Cell phone:</label>
<span class='pull-right'>
<cfinput class="form-control input-sm" maxlength="30" name="applicant_cell_phone" type="text" value="#applicant_cell_phone#">
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Pager:</label>
<span class='pull-right'>
<cfinput class="form-control input-sm" maxlength="30" name="applicant_pager_number" type="text" value="#applicant_pager_number#">
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Dispatch phone:</label>
<span class='pull-right'>
 <cfinput class="form-control input-sm" maxlength="30" name="applicant_dispatch_phone" type="text" value="#applicant_dispatch_phone#">
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Fax:</label>
<span class='pull-right'>
<cfinput class="form-control input-sm" maxlength="30" name="applicant_fax_phone" type="text" value="#applicant_fax_phone#">
</span>
</div>
<div class="form-group form-group-sm">
<cfquery name="check_files" datasource="ICAP_Prod">
select attachment_id,attachment_name,attachment_added,attachment_original_size,deleted_at from icap_attachments where applicant_id = #applicant_id# and deleted_at is null order by attachment_added desc
</cfquery>
<table class='table table-condensed table-bordered small'>
<thead>
<tr style='background:Gainsboro;'>
<th colspan='3'>File Uploads</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan=3>
<input name="file1" type="file" size="5" message="Please select a file.">
</td>
</tr>
<tr>
<th>file</th>
<th>date</th>
<th>delete</th>
</tr>
<cfif #check_files.recordcount# NEQ 0>
<cfloop query="check_files">
<tr>
<td><a href="http://162.79.30.150/ICAP/#attachment_name#" target="_blank">#attachment_name#</a></td>
<td><span class='pull-right'>#attachment_added#</span></td>
<td><input class='pull-right' type='checkbox' name='<cfoutput>delete_file_#attachment_id#</cfoutput>'></td>
</tr>
</cfloop>
<cfelse>
<tr>
NO FILES ATTACHED
</tr>
</cfif>
<tr>
<span class='text-danger strong small'>Upload your qualifying documents here. At a minimum, include a resume and your master training record.</span>
</tr>
</tbody>
</table>
</div>
</div>
<div class='col-xs-12 col-sm-7 col-md-8 col-lg-8 c pull-right' style="max-width:420px;margin-left:10px;">
<div class="form-group form-group-sm">
<label class="control-label">Applicant Category:</label>
<span class='pull-right'>
<cfselect name="applicant_retired" class="form-control input-sm" >
<cfif #applicant_retired# EQ ''><option value disabled selected></option></cfif>
<cfloop list="Federal Employee,State Employee,Local Government,AD,Supplemental,Emergency Fire Fighter (EFF)," index="a">
<cfoutput>
<option value="#a#" <cfif #ada.applicant_retired# EQ a> selected</cfif>>#a#</option>
</cfoutput>
</cfloop>
</cfselect>
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">IQCS:</label>
<span class='pull-right'><cfinput type="text" class="form-control input-sm" id="applicant_IQCS" name="applicant_IQCS" value="#applicant_IQCS#"></span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Area:</label>
<cfquery name="get_areas" datasource="ICAP_Prod">
select * from icap_areas order by area asc
</cfquery>
<span class='pull-right'><cfselect class="form-control input-sm" name="applicant_gaac_type">
<cfif #applicant_gaac_type# EQ ''><option value disabled selected></option></cfif>
<cfloop query="get_areas">
<cfoutput><option value="#area#" <cfif #ada.applicant_gaac_type# EQ "#area#">selected</cfif>>#area#</option></cfoutput>
</cfloop>
</cfselect></span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">State:</label>
<span class='pull-right'>
<cfselect class="form-control input-sm" name="applicant_area">
<cfif #applicant_area# EQ ''><option value disabled selected></option></cfif>
<cfloop list="AL,AK,AZ,AR,CA,CO,CT,DE,DC,FL,GA,HI,ID,IL,IN,IA,KS,KY,LA,ME,MD,MA,MI,MN,MS,MO,MT,NE,NV,NH,NJ,NM,NY,NC,ND,OH,OK,OR,PA,RI,SC,SD,TN,TX,UT,VT,VA,WA,WV,WI,WY" index="a">
<cfoutput>
<option value="#a#" <cfif #applicant_area# EQ a> selected</cfif>>#a#</option>
</cfoutput>
</cfloop>
</cfselect>
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Dispatch Office:</label>
<cfif #ada.gaac_code# NEQ "">
<cfdiv class='pull-right' bind="url:_gacc.cfm?app_area={app_fm:applicant_gaac_type}&app_areaI=#ada.gaac_code#" bindonload="true"/><br/>
<cfelse>
<cfdiv class='pull-right' bind="url:_gacc.cfm?app_area={app_fm:applicant_gaac_type}" bindonload="true"/><br/>
</cfif>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Dispatch Office if 'Other':</label>
<span class='pull-right'>
<cfinput maxlength="100" class="form-control input-sm" name="applicant_agreement_holder_agency" type="text" value="#applicant_agreement_holder_agency#">
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Employment or Host Agency:</label>
<span class='pull-right'>
<cfselect class="form-control input-sm" name="applicant_fq_email_type" >
<cfif #applicant_fq_email_type# EQ ''><option value disabled selected></option></cfif>
<cfloop list="BIA,BLM,F&WS,FS,NPS,State,Local Government,Rural Fire District,Other" index="a">
<cfoutput>
<option value="#a#" <cfif #applicant_fq_email_type# EQ a> selected</cfif>>#a#</option>
</cfoutput>
</cfloop>
</cfselect>
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Employment or Host Agency if 'Other':</label>
<span class='pull-right'>
<cfinput  class="form-control input-sm" maxlength="100" name="applicant_agency" type="text" value="#applicant_agency#">
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Employment or Host Agency Address:</label>
<span class='pull-right'>
<cfinput  class="form-control input-sm" maxlength="100" name="applicant_agency_address" type="text" value="#applicant_agency_address#">
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Supervisor name:</label>
<span class='pull-right'>
<cfinput class="form-control input-sm" maxlength="40" name="applicant_ao_name" type="text" value="#applicant_ao_name#">
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Supervisor email:</label>
<span class='pull-right'>
<cfinput class="form-control input-sm" maxlength="40" name="applicant_ao_email" type="text" value="#applicant_ao_email#">
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Agency administrator/operations group representative:</label>
<span class='pull-right'>
<cfinput class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text" value="#applicant_aa_name#">
</span>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Agency administrator email:</label>
<cfdiv class='pull-right' bind="url:_cfdiv_aa_eml.cfm?fq_gaac_ae={app_fm:applicant_gaac_type}&fq_em_ae={app_fm:applicant_fq_email_type}&fq_st_ae={app_fm:applicant_area}&fq_st_ae_ex=#applicant_aa_email#" bindonload="true"/>
</div>
<div class="form-group form-group-sm">
<label class="control-label">Training coordinator email:</label>
<cfdiv class='pull-right' bind="url:_cfdiv_fq.cfm?fq_em={app_fm:applicant_fq_email_type}&fq_area={app_fm:applicant_gaac_type}&fq_em_ex=#applicant_fq_email#" bindonload="true"/>
</div>
</div>
</div>
<div class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
<div class='col-xs-12 col-sm-6 col-md-6 col-lg-6 c'>
<div class="form-group form-group-sm">
<label class="control-label">Qualifications:</label>
<span class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
<cftextarea class="form-control input-sm" name="applicant_qualifications" rows="15" cols="22" style="height:72px;"><cfoutput>#applicant_qualifications#</cfoutput></cftextarea>
</span>
</div>
</div>
<div class='col-xs-12 col-sm-6 col-md-6 col-lg-6 c'>
<div class="form-group form-group-sm">
<label class="control-label">Remarks:</label>
<span class='col-xs-12 col-sm-12 col-md-12 col-lg-12 c'>
<cftextarea class="form-control input-sm" name="applicant_remarks" rows="15" cols="22" style="height:72px;"><cfoutput>#applicant_remarks#</cfoutput></cftextarea>
</span>
</div>
</div>
</div>
</cfoutput>
</div>
</cfform>
</div>
</div>
</div>
<cfinclude template="/fam/gutter.cfm">
<script src="/fam/jquery-validation-1.14.0/dist/jquery.validate.js"></script>
<script src="/fam/jquery-validation-1.14.0/dist/additional-methods.min.js"></script>
<script src="/fam/jquery-validation-1.14.0/lib/jquery.maskedinput.js"></script>
<script>
jQuery.validator.addMethod("notEqual", function(value, element, param) {
  return this.optional(element) || value != param;
}, "Please specify a different value.");
$().ready(function() {
$("#applicant_zip_code").mask("99999?-9999");
$("#app_fm").validate({
    errorClass: "has-error",
    highlight: function(element) {
        $(element).parent().parent().addClass("has-error").removeClass("has-success");
    },
    unhighlight: function(element) {
        $(element).parent().parent().addClass("has-success").removeClass("has-error");
    },
    rules: {
        applicant_nameI: "required",
        applicant_nameIII: "required",
        applicant_city: "required",
        applicant_jet_port: "required",
        applicant_zip_code: "required",
        applicant_email_address: {
            required: true,
            email: true
        },
        applicant_work_phone: {
          required: true,
          phoneUS: true
        },
        applicant_home_phone: {
          required: true,
          phoneUS: true
        },
        applicant_cell_phone: {
          required: true,
          phoneUS: true
        },
        applicant_dispatch_phone: {
          required: true,
          phoneUS: true
        },
        applicant_fax_phone: {
          required: true,
          phoneUS: true
        },
        applicant_qualifications: {
            required: true
        },
        applicant_retired: {
            required: true
        },
        applicant_IQCS: "required",
        applicant_gaac_type: "required",
        applicant_area: "required",
        applicant_gaac_typeI: "required",
        applicant_agreement_holder_agency: {
            required: {
                depends: function () {
                    if ($("[name=applicant_gaac_typeI]").val() == "Other"){
                        return true;
                        }else{
                        return false;
                        }
                }
            }
        },
        applicant_fq_email_type: "required",
        applicant_agency: {
            required: {
                depends: function () {
                    if ($("[name=applicant_fq_email_type]").val() == "Other"){
                        return true;
                        }else{
                        return false;
                        }
                }
            }
        },
        applicant_agency_address: {
            required: true
        },
        applicant_ao_name: "required",
        applicant_ao_email: {
            required: true,
            email: true
        },
        applicant_aa_name: {
            required: false,
        },
        applicant_aa_email: {
            required: false,
            email: true
        },
        applicant_fq_email: {
            required: true,
            email: true,
            notEqual: "r6_pnwcg_training@fs.fed.us"
        },
        agree: "required"
    },
    messages: {
        applicant_nameI: "Enter your firstname",
        applicant_nameIII: "Enter your lastname",
        applicant_city: "Enter your city of residence",
        applicant_jet_port: "Select your state of residence",
        applicant_zip_code: "Enter your zip code",
        applicant_email_address: "Enter a valid email address",
        applicant_work_phone: "Enter a valid work phone number",
        applicant_home_phone: "Enter a valid home phone number",
        applicant_cell_phone: "Enter a valid cell phone number",
        applicant_dispatch_phone: "Enter a valid dispatch phone number",
        applicant_fax_phone: "Enter a valid fax number",
        applicant_qualifications: "Enter your fire qualifications",
        applicant_retired: "Select a category",
        applicant_IQCS: "Enter your IQCS number or N/A",
        applicant_gaac_typeI: "Select your dispatch office",
        applicant_agreement_holder_agency: "Enter your dispatch office",
        applicant_agency: "Enter your agency",
        applicant_agency_address: "Enter a your agency mailing address",
        applicant_ao_name: "Enter your supervisor's name",
        applicant_ao_email: "Enter a valid email address",
        applicant_aa_name: "Enter your agency rep's name",
        applicant_aa_email: "Enter a valid email address",
        applicant_fq_email: "Enter a valid email address"
    }
});
});
</script>
</body>
</html>