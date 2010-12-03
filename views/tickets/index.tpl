{$view->element("modulesmenu")}

{assign_associative var="params" method="index"}
{$view->element("menuleft", $params)}

{assign_associative var="params" method="index"}
{$view->element("menucommands", $params)}

{$view->element("toolbar")}

<div class="mainfull">
	
	<div class="tab"><h2>{t}filters{/t}</h2></div>
	<div id="ticketfilter">		
		{t}display only{/t}:
		
		<fieldset style="display:inline; padding:5px 10px 5px 5px">
		{assign var="prevsta" value="draft"}
		{foreach item=sta key='key' from=$conf->ticketStatus}
		{if $sta!=$prevsta}</fieldset><fieldset style="display:inline; border-left:1px solid gray; 
		padding:5px 10px 5px 10px">{/if}
			<input type="checkbox" value="{$key}" checked="checked" name="data[status]" /> 
			{t}{$key}{/t}&nbsp;
			{assign var="prevsta" value=$sta}	
		{/foreach}
		</fieldset>
		<hr />
		{t}reporter{/t}: &nbsp;
		<select name="data[reporter]">
			<option value="">all</option>
			<option value="">armando carcassone</option>
		</select>
		
		&nbsp;{t}severity{/t}: &nbsp;
		<select name="data[severity]" id="ticketSev">
			<option value="">all</option>
		{foreach item=sev from=$conf->ticketSeverity}
			<option value="{$sev}">{$sev}</option>
		{/foreach}
		</select>

	</div>

	{$view->element("list_objects")}

</div>