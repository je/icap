<cfparam name="URL.fq_gaac_aa" default="" type="string">
<cfparam name="URL.fq_st_aa" default="" type="string">
<cfparam name="URL.fq_st_aa" default="" type="string">
<cfparam name="URL.fq_st_aa_ex" default="" type="string">
<cfif URL.fq_gaac_aa EQ "Great Basin">
	<cfif URL.fq_em_aa EQ "BLM">
		<cfif URL.fq_st_aa EQ "AZ">
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text" value="Mike Spilde">
		<cfelseif URL.fq_st_aa EQ "ID">
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text" value="Eric Fransted">
		<cfelseif URL.fq_st_aa EQ "NV">
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text" value="Paul Petersen">
		<cfelseif URL.fq_st_aa EQ "UT">
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text" value="Chris Delaney">
		<cfelse>
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text">
		</cfif>
	<cfelseif URL.fq_em_aa EQ "FS">
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text" value="Beth Lund">
	<cfelseif URL.fq_em_aa EQ "F&WS">
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text" value="Tracy Swenson">
	<cfelseif URL.fq_em_aa EQ "NPS">
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text" value="Chip Collins">
	<cfelseif URL.fq_em_aa EQ "BIA">
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text" value="Kirby Arrive">
	<cfelseif URL.fq_em_aa EQ "State">
		<cfif URL.fq_st_aa EQ "ID">
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text" value="Julia Sullens">
		<cfelseif URL.fq_st_aa EQ "NV">
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text" value="Mike Klug">
		<cfelseif URL.fq_st_aa EQ "UT">
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text" value="Shane Freeman">
		<cfelse>
			<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text">
		</cfif>
	<cfelseif URL.fq_em_aa EQ "Rural Fire District">
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text" value="Eric Fransen">
	<cfelse>
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text">
	</cfif>
<!-- 2014-11-07: Added by Arden Harrell to introduce rule for Dispatch: Rocky Mountain -->
<cfelseif URL.fq_gaac_aa EQ "Rocky Mountain">

	<cfif URL.fq_em_aa EQ "FS">
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text" value="Troy Hagan">
	<cfelse>
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text">
	</cfif>
<cfelse>
	<cfif URL.fq_st_aa_ex NEQ "">
		<cfoutput><input class="form-control input-sm" maxlength="40" name="applicant_aa_name" value="#URL.fq_st_aa_ex#" type="text"></cfoutput>
	<cfelse>
		<input class="form-control input-sm" maxlength="40" name="applicant_aa_name" type="text">
	</cfif>
</cfif>