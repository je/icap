<cfparam name="URL.fq_gaac_ae" default="" type="string">
<cfparam name="URL.fq_em_ae" default="" type="string">
<cfparam name="URL.fq_st_ae" default="" type="string">
<cfparam name="URL.fq_st_ae_ex" default="" type="string">
<cfif URL.fq_gaac_ae EQ "Great Basin">
	<cfif URL.fq_em_ae EQ "BLM">
		<cfif URL.fq_st_ae EQ "AZ">
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text" value="mspilde@blm.gov">
		<cfelseif URL.fq_st_ae EQ "ID">
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text" value="efranste@blm.gov">
		<cfelseif URL.fq_st_ae EQ "NV">
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text" value="ppeterse@blm.gov">
		<cfelseif URL.fq_st_ae EQ "UT">
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text" value="cdelaney@blm.gov">
		<cfelse>
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text">
		</cfif>
	<cfelseif URL.fq_em_ae EQ "FS">
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text" value="elund@fs.fed.us">
	<cfelseif URL.fq_em_ae EQ "F&WS">
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text" value="tracy_swenson@fws.gov">
	<cfelseif URL.fq_em_ae EQ "NPS">
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text" value="chip_collins@nps.gov">
	<cfelseif URL.fq_em_ae EQ "BIA">
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text" value="Kirby.Arrive@bia.gov">
	<cfelseif URL.fq_em_ae EQ "State">
		<cfif URL.fq_st_ae EQ "ID">
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text" value="jsullens@idl.idaho.gov">
		<cfelseif URL.fq_st_ae EQ "NV">
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text" value="mklug@forestry.nv.gov">
		<cfelseif URL.fq_st_ae EQ "UT">
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text" value="shanefreeman@utah.gov">
		<cfelse>
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text">
		</cfif>
	<cfelseif URL.fq_em_ae EQ "Rural Fire District">
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text" value="efranste@blm.gov ">
	<cfelse>
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text">
	</cfif>
<!-- 2014-11-07: Added by Arden Harrell to introduce rule for Dispatch: Rocky Mountain -->
<cfelseif URL.fq_gaac_ae EQ "Rocky Mountain">
	<cfif URL.fq_em_ae EQ "FS">
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text" value="thagan@fs.fed.us">
	<cfelse>
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text">
	</cfif>
<cfelse>
	<cfif URL.fq_st_ae_ex NEQ "">
		<cfoutput><input class="form-control input-sm" maxlength="40" name="applicant_aa_email" value="#URL.fq_st_ae_ex#" type="text"></cfoutput>
	<cfelse>
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_email" type="text">
	</cfif>
</cfif>