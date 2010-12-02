{$view->element("modulesmenu")}

{assign_associative var="params" method="index"}
{$view->element("menuleft", $params)}

{assign_associative var="params" method="index"}
{$view->element("menucommands", $params)}

{$view->element("toolbar")}

<div class="mainfull">
	
	<div class="tab"><h2>{t}filters{/t}</h2></div>
	<div>
		
		{foreach item=sta key='key' from=$conf->ticketStatus}
			<input type="checkbox" value="{$key}" name="data[status]" /> {t}{$key}{/t} &nbsp;
		{/foreach}

		&nbsp;|
		&nbsp;{t}reporter{/t}: &nbsp;
		<select name="data[reporter]">
		<option value="">armando carcassone</option>
		</select>
		
		&nbsp;{t}severity{/t}: &nbsp;
		<select name="data[severity]" id="ticketSev">
		{foreach item=sev from=$conf->ticketSeverity}
			<option value="{$sev}">{$sev}</option>
		{/foreach}
		</select>
	</div>

	{$view->element("list_objects")}

</div>