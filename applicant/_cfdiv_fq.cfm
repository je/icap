<cfparam name="URL.fq_em" type="string" default="">
<cfparam name="URL.fq_area" type="string" default="">
<cfparam name="URL.fq_em_ex" type="string" default="">
<cfset fq_em_ex="#URL.fq_em_ex#">
<cfif #URL.fq_area# EQ "California">
	<cfif #URL.fq_em# EQ "NPS">
		<cfset afqeml="jason_loomis@nps.gov">
	<cfelseif #URL.fq_em# EQ "Local Government">
		<cfset afqeml="vail.s@sbcglobal.net">
	<cfelseif #URL.fq_em# EQ "BIA">
		<cfset afqeml="yvonne.jones@bia.gov">
	<cfelseif #URL.fq_em# EQ "F&WS">
		<cfset afqeml="jessica_wade@fws.gov">
	<cfelseif #URL.fq_em# EQ "BLM">
		<cfset afqeml="jgannon@blm.gov">
	<cfelseif #URL.fq_em# EQ "FS">
		<cfset afqeml="">
	<cfelseif #URL.fq_em# EQ "State">
		<cfset afqeml="dean.veik@fire.ca.gov">
	<cfelse>
		<cfset afqeml="">
	</cfif>
<cfelse>
	<cfif #URL.fq_em# EQ "FS" OR #URL.fq_em# EQ "BLM" OR #URL.fq_em# EQ "BIA" OR #URL.fq_em# EQ "F&WS">
		<cfif #URL.fq_area# EQ "Washington">
			<cfset afqeml="">
		<cfelseif #URL.fq_area# EQ "Oregon">
			<cfset afqeml="">
		<cfelse>
			<cfset afqeml="">
		</cfif>
	<cfelse>
		<cfif #URL.fq_area# EQ "Washington">
			<cfset afqeml="joel.rogauskas@dnr.wa.gov,Jennifer.bammert@dnr.wa.gov">
		<cfelse>
			<cfset afqeml="">
		</cfif>
	</cfif>
</cfif>
<cfif #fq_em_ex# NEQ "">
	<cfoutput><input class="form-control input-sm" maxlength="40" name="applicant_fq_email" type="text" value="#fq_em_ex#"></cfoutput><br/>
<cfelseif #afqeml# NEQ "">
	<cfoutput><input class="form-control input-sm" maxlength="40" name="applicant_fq_email" type="text" value="#afqeml#"></cfoutput><br/>
<cfelse>
	<cfif #afqeml# EQ "">
		<cfoutput><input class="form-control input-sm" maxlength="40" name="applicant_fq_email" type="text" value="#URL.fq_em_ex#"></cfoutput><br/>
	<cfelse>
		<input class="form-control input-sm" maxlength="40" name="applicant_fq_email" type="text"><br/>
	</cfif>
</cfif>