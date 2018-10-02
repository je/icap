<cfinclude template="/fam/icap/use.cfm">
<cfinclude template="/fam/lo.cfm">
<div class="" style="padding-right:20px;">
<div class="panel panel-info" style="max-width:none;">
    <div class="panel-heading">
    <h3 class="panel-title">
    <strong><span class="text-muted">Reports</span></strong>
    </h3>
    </div>
    <div class="panel-body">
        <div class='col-xs-12 col-sm-12 col-md-12 cl-lg-12' style='max-width:380px'>
        all non-IC applicants <span class='pull-right'><a href="/fam/icap/reports/applicants/">html</a> <a href="/fam/icap/reports/applicants/xls/">xls</a></span>
        <br>
        unselected non-IC applicants <span class='pull-right'><a href="/fam/icap/reports/applicants-not-selected/">html</a> <a href="/fam/icap/reports/applicants-not-selected/xls/">xls</a></span>
        <br>
        selected non-IC applicants <span class='pull-right'><a href="/fam/icap/reports/applicants-selected/">html</a> <a href="/fam/icap/reports/applicants-selected/xls/">xls</a></span>
        <br>
        <br>
        all IC, ICT1, and ICT2 applicants <span class='pull-right'><a href="/fam/icap/reports/applicants-ics/">html</a> <a href="/fam/icap/reports/applicants-ics/xls/">xls</a></span>
        <br>
        selected IC, ICT1, and ICT2 applicants <span class='pull-right'><a href="/fam/icap/reports/applicants-ics-selected/">html</a> <a href="/fam/icap/reports/applicants-ics-selected/xls/">xls</a></span>
        <br>
        <br>
        all BUYL and BUYM applicants <span class='pull-right'><a href="/fam/icap/reports/applicants-buy/">html</a> <a href="/fam/icap/reports/applicants-buy/xls/">xls</a></span>
        <br>
        selected BUYL and BUYM applicants <span class='pull-right'><a href="/fam/icap/reports/applicants-buy-selected/">html</a> <a href="/fam/icap/reports/applicants-buy-selected/xls/">xls</a></span>
        <br>
        <br>
        all out-of-area applicants <span class='pull-right'><a href="/fam/icap/reports/applicants-out-of-area/">html</a> <a href="/fam/icap/reports/applicants-out-of-area/xls/">xls</a></span>
        <br>
        </div>
    </div>
    <div class="panel-footer small">
    <cfoutput query="FAMDB_user">
        <cfif #icap_role# EQ 'M'>You are <strong>National Administrator</strong>, so these reports are not filtered.
        <cfelseif #icap_role# EQ 'C'>You are <strong>GACC Coordinator</strong> for <strong>#icap_area#</strong> Area, so these reports are filtered to show only <strong>#icap_area#</strong> Area positions and applications.
        <cfelseif #icap_role# EQ 'I'>You are <strong>Incident Commander</strong> for <strong>#icteam_name#</strong> Team, so these reports are filtered to show only <strong>#icap_area#</strong> Area positions and applications.
        <cfelseif #icap_role# EQ 'A'>These reports are filtered to show only your applications.
        <cfelseif #icap_role# EQ ''><strong>Blank user access -- request access to do better.</strong><br></cfif>
    </cfoutput>
    </div>
</div>
</div>
<cfinclude template="/fam/gutter.cfm">
</body>
</html>