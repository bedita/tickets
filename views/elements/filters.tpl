<div class="tab"><h2>{t}filters{/t}</h2></div>
	<div id="ticketfilter">		
		
		<fieldset style="display:inline; padding:5px 10px 5px 5px">
		
		{assign var="prevsta" value="draft"}
		{foreach item=sta key='key' from=$conf->ticketStatus}
		{if $sta!=$prevsta}</fieldset><fieldset style="display:inline; border-left:1px solid gray; 
		padding:5px 10px 5px 10px">{/if}
			<input type="checkbox" value="{$key}" name="data[status][{$key}]" class="filterTicket" rel="{$sta}" id="status_{$key}" {if !empty($filter.f_status.$key) || $sta != "off"}checked="checked"{/if}/> 
			{t}{$key}{/t}&nbsp;
			{assign var="prevsta" value=$sta}	
		{/foreach}
		</fieldset>
		<br/>

		

		<hr />
		{t}reporter{/t}: &nbsp;
		<select name="data[reporter]" class="filterTicket">
			<option value="">all</option>
			{foreach item=reporter key='key' from=$reporters}
			<option value="{$key}" {if (!empty($filter.f_reporter) && ($filter.f_reporter == $key))}selected="selected"{/if}>{$reporter}</option>
			{/foreach}
		</select>
		
		&nbsp;{t}assigned to{/t}: &nbsp;
		<select name="data[assigned_to]" class="filterTicket">
			<option value="">all</option>
			{foreach item=user key='key' from=$assignedUsers}
			<option value="{$user.User.id}" {if !empty($filter.f_assigned_to) && $filter.f_assigned_to == $user.User.id}selected="selected"{/if}>{$user.User.realname|default:$user.User.userid}</option>
			{/foreach}
		</select>
		
		&nbsp;{t}severity{/t}: &nbsp;
		<select name="data[severity]" id="ticketSev" class="filterTicket">
			<option value="">all</option>
		{foreach item=sev from=$conf->ticketSeverity}
			<option value="{$sev}" {if (!empty($filter.f_severity) && ($filter.f_severity == $sev))}selected="selected"{/if}>{$sev}</option>
		{/foreach}
		</select>
		&nbsp;&nbsp;
		{assign var="hide_off" value=$filter.hide_status_off|default:'false'}
		<input type="checkbox" name="data[hide_status_off]" id="filterHideClosed" 
		{if ($hide_off == 'true')}checked="checked"{/if}/>{t} hide closed tickets{/t}
		&nbsp;&nbsp;
		<input type="submit" value="ok" />
	</div>
