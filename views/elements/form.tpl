{*
** tickets form template
*}

<script type="text/javascript">
{literal}
function assignTicketToUsers(ids,users) {
	$('#usersAssign').val(ids);
	$('#usersAssignDiv').html(users);
	$('#usersAssignDiv').show();
}

var ts = {{/literal}{foreach item='val' key='key' from=$conf->ticketStatus}"{$key}":"{$val}",{/foreach}"":""{literal}}{/literal}
{literal}
$(document).ready(function(){
	$('#ticketStatus').change(function () {
		$('#status').val(ts[this.value]);
	});
});


{/literal}


</script>

<form action="{$html->url('/tickets/save')}" method="post" name="updateForm" id="updateForm" class="cmxform">

<input type="hidden" name="data[id]" value="{$object.id|default:''}"/>

{if ($conf->mce|default:true)}
	
	{$javascript->link("tiny_mce/tiny_mce", false)}
	{$javascript->link("tiny_mce/tiny_mce_default_init", false)}

{elseif ($conf->wymeditor|default:true)}

	{$javascript->link("wymeditor/jquery.wymeditor.pack", false)}
	{$javascript->link("wymeditor/wymeditor_default_init", false)}

{/if}


{* title and description *}

{assign var="newtitle" value=$html->params.named.title|default:''}

<div class="tab"><h2>{t}Title{/t}</h2></div>

<fieldset id="title">

	<label>{t}title{/t}:</label>
	<br />
	<input type="text" name="data[title]" style="width:100%" value="{$object.title|escape:'html'|escape:'quotes'|default:$newtitle}" id="titleBEObject" />
	<br />
	<label>{t}description{/t}:</label>
	<br />
	<textarea id="subtitle" class="mce" style="height:280px" name="data[description]">{$object.description|default:''|escape:'html'}</textarea>

</fieldset>

{$view->element("form_categories")}

{$view->element("form_custom_properties")}

<div class="tab"><h2>{t}Properties{/t}</h2></div>

<fieldset id="properties">			
				
	<table class="bordered">
		
		<tr>
			<th>{t}status{/t}</th>
			<td colspan="4">
				<select name="data[ticket_status]" id="ticketStatus">
				{foreach item=sta key='key' from=$conf->ticketStatus}
					<option {if $key==$object.ticket_status}selected="selected"{/if} value="{$key}">{$key}</option>
				{/foreach}
				</select>
				<input type="hidden" name="data[status]" id="status" />
			</td>
		</tr>
		<tr>
			<th>{t}severity{/t}:</th>
			<td colspan="4">
				<select name="data[severity]" id="ticketSev">
				{foreach item=sev from=$conf->ticketSeverity}
					<option {if $sev==$object.severity}selected="selected"{/if} value="{$sev}">{$sev}</option>
				{/foreach}
				</select>
			</td>
		</tr>

		<tr>
			<th>
				{t}expected resolution date{/t}:&nbsp;
			</th>
			<td colspan="4">
				<input size="10" type="text" style="vertical-align:middle"
				class="dateinput" name="data[exp_resolution_date]" id="expDate"
				value="{if !empty($object.exp_resolution_date)}{$object.exp_resolution_date|date_format:$conf->datePattern}{/if}" />
				&nbsp;
			</td>
		</tr>

		<tr>
			<th>{t}closed date{/t}:</th>
			<td>{if !empty($object.closed_date)}{$object.closed_date|date_format:$conf->dateTimePattern}{/if}</td>
		</tr>
		
		<tr>
			<th>{t}percentage complete{/t}:</th>
			<td>
			<input type="text" name="data[percent_completed]" value="{$object.percent_completed}" />
			</td>
 		</tr>
		<tr>
			<th>{t}durata{/t}:</th>
			<td>
				<input type="text" name="data[duration]" value="{if !empty($object.duration)}{$object.duration/60}{/if}" />
			</td>
		</tr>
	</table>
	
</fieldset>

{assign_associative var="params" containerId='attachContainer' collection="true" relation='attach' title='Attachments'}
{$view->element("form_file_list", $params)}

{assign_associative var="params" object_type_id=$objectTypeId}
{$view->element("form_assoc_objects", $params)}

<div class="tab"><h2>{t}Users and time{/t}</h2></div>

<fieldset id="properties">			
				
	<table class="bordered">
		<tr>
			<td>
			
				<input type="button" class="modalbutton" name="edit" value=" {t}assigned to: {/t}  "
					rel="{$html->url('/tickets/showUsers')}{if !empty($object)}/{$object.id}{/if}"
					title="USERS : select user(s) to assign ticket" />

			</td>
			<td colspan="4">
				<span id="usersAssignDiv">
					{if !empty($object.User)}
					{foreach from=$object.User item='u' name='user'}{$u.userid}{if !$smarty.foreach.user.last},{/if}{/foreach}
					{/if}
				</span>
				<input type="hidden" id="usersAssign" name="data[users]" value="{if !empty($object.User)}{foreach from=$object.User item='u' name='user'}{$u.id}{if !$smarty.foreach.user.last},{/if}{/foreach}{/if}"/>
			</td>

		</tr>
	
		<tr>
			<th>{t}created on{/t}:</th>
			<td>{$object.created|date_format:$conf->dateTimePattern}</td>
			<th>{t}by{/t}:</th>
			<td>{$object.UserCreated.realname|default:''} [ {$object.UserCreated.userid|default:''} ]</td>
		</tr>	 
		<tr>
			<th style="white-space:nowrap">{t}last modified on{/t}:</th>
			<td>{$object.modified|date_format:$conf->dateTimePattern}</td>
			<th style="white-space:nowrap">{t}by{/t}:</th>
			<td>{$object.UserModified.realname|default:''} [ {$object.UserModified.userid|default:''} ]</td>
		</tr>
		
	</table>
	
</fieldset>

</form>

{$view->element("ticket_thread")}