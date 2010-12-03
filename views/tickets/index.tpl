{$view->element("modulesmenu")}

{assign_associative var="params" method="index"}
{$view->element("menuleft", $params)}

{assign_associative var="params" method="index"}
{$view->element("menucommands", $params)}

{$view->element("toolbar")}

<script type="text/javascript">
{literal}
$(document).ready(function(){
	$('input[type=checkbox].filterTicket').click(function(){
		$("#formObject").submit() ;
	});
	$('select.filterTicket').change(function(){
		$("#formObject").submit() ;
	});
	$('#filterTicketStatus').click(function(){
		$("#formObject").submit() ;
	});
});
{/literal}
</script>
<div class="mainfull">
	<form method="post" action="" id="formObject">

	<div class="tab"><h2>{t}filters{/t}</h2></div>
	<div id="ticketfilter">		
		
		{t}display only{/t}:
		
		<fieldset style="display:inline; padding:5px 10px 5px 5px">
		
		{assign var="prevsta" value="draft"}
		{foreach item=sta key='key' from=$conf->ticketStatus}
		{if $sta!=$prevsta}</fieldset><fieldset style="display:inline; border-left:1px solid gray; 
		padding:5px 10px 5px 10px">{/if}
			<input type="checkbox" value="{$key}" name="data[status][{$key}]" class="filterTicket" id="status_{$key}" {if empty($filter.f_status) || !empty($filter.f_status.$key)}checked="checked"{/if}/> 
			{t}{$key}{/t}&nbsp;
			{assign var="prevsta" value=$sta}	
		{/foreach}
		</fieldset>
		<br/>

		{assign var="show_off" value=$filter.show_status_off|default:'false'}
		<input type="checkbox" name="data[show_status_off]" id="filterTicketStatus" {if ($show_off == 'true')}checked="checked"{/if}/>{t}Show 'off'{/t}

		<hr />
		{t}reporter{/t}: &nbsp;
		<select name="data[reporter]" class="filterTicket">
			<option value="">all</option>
			{foreach item=reporter key='key' from=$reporters}
			<option value="{$key}" {if (!empty($filter.f_reporter) && ($filter.f_reporter == $key))}selected="selected"{/if}>{$reporter}}</option>
			{/foreach}
		</select>
		
		&nbsp;{t}severity{/t}: &nbsp;
		<select name="data[severity]" id="ticketSev" class="filterTicket">
			<option value="">all</option>
		{foreach item=sev from=$conf->ticketSeverity}
			<option value="{$sev}" {if (!empty($filter.f_severity) && ($filter.f_severity == $sev))}selected="selected"{/if}>{$sev}</option>
		{/foreach}
		</select>

	</div>

	{$view->element("list_objects")}

	</form>
</div>