<cfif #isdefined('msg_text')#>
<cfoutput>
<div class="alert alert-dismissible<cfif #isdefined('msg_status')#> alert-#msg_status#<cfelse> alert-info</cfif>" style='padding-top:5px;padding-bottom:5px;' role="alert">
  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  <strong><cfif #isdefined('msg_status')#><i class='glyphicon glyphicon-alert'></i> #REReplace(msg_status,"\b(\S)(\S*)\b","\u\1\L\2","all")#<cfelse><i class='glyphicon glyphicon-alert'></i> Alert</cfif>:</strong> #msg_text#
</div>
</cfoutput>
</cfif>