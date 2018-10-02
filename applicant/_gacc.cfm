<cfparam name="URL.app_area" default="" type="string">
<cfparam name="URL.app_areaI" default="" type="string">
<cfif  #URL.app_area# EQ "California">
	Not required for California applicants.
    <input class="hidden" type="hidden" name="applicant_gaac_typeI" value="">
<cfelseif #URL.app_areaI# NEQ "" OR #URL.app_area# NEQ "">
	<select name="applicant_gaac_typeI" class="form-control input-sm">
	<cfif #URL.app_areaI# EQ ''><option value disabled selected></option></cfif>
	<cfif #URL.app_areaI# NEQ "">
			<cfquery name="init" datasource="ICAP_Prod">
			SELECT gaac
			FROM icap_gaac
			WHERE gaac_code = '#URL.app_areaI#'
			ORDER BY gaac
			</cfquery>
		<cfoutput><option value="#init.gaac#" selected>#init.gaac#</option></cfoutput>
	</cfif>
	<cfif #URL.app_area# NEQ "">
		<cfif  #URL.app_area# EQ "PNW">
			<cfquery name="get_gacc" datasource="ICAP_Prod">
			SELECT *
			FROM icap_gaac
			WHERE (area = 'Oregon' OR area ='Washington')
			ORDER BY gaac
			</cfquery>
		<cfelse>
			<cfquery name="get_gacc" datasource="ICAP_Prod">
			SELECT *
			FROM icap_gaac
			WHERE area = '#URL.app_area#'
			ORDER BY gaac
			</cfquery>
		</cfif>
		<cfoutput query="get_gacc">
		<option value="#gaac#">#gaac#</option>
		</cfoutput>
	</cfif>
	<option value="Other">Other</option>
	</select>
</cfif>