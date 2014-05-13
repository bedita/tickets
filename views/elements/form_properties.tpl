<div class="tab"><h2>{t}Properties{/t}</h2></div>

<fieldset id="properties">			

	<table class="bordered">		
		<tr>
			<th>{t}status{/t}</th>
			<td colspan="4">
				<select name="data[ticket_status]" id="ticketStatus">
				{assign var="prevsta" value="draft"}
				{foreach item=sta key='key' from=$conf->ticketStatus}
					{if $sta!=$prevsta}<option onclick="this.blur()" disabled="">| {$sta|replace:"on":"open"|replace:"off":"closed"} states |</option>{/if}					
					<option {if $key==$object.ticket_status|default:''}selected="selected"{/if} value="{$key}">{$key}</option>		
				{assign var="prevsta" value=$sta}	
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
					<option {if $sev==$object.severity|default:'normal'}selected="selected"{/if} value="{$sev}">{$sev}</option>
				{/foreach}
				</select>
			</td>
		</tr>
		{bedev}
		<tr>
			<th>
				{t}remaining hours to complete{/t}:&nbsp;
			</th>
			<td colspan="4">
				<input type="text" name="data[remaining_hours]" value="" class="serif" style="
				    width: 44px; height:44px;
				    border-radius: 44px;
				    background-color: yellow;
				    color: #000;
				    font-family:'Georgia',serif;
				    font-size:1.9em;
				    text-align:center;
				">
			</td>
		</tr>
		{/bedev}
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
		{if !empty($object.closed_date)}
		<tr>
			<th>{t}closed date{/t}:</th>
			<td>{$object.closed_date|date_format:$conf->dateTimePattern}</td>
		</tr>
		{/if}
		<tr>
			<th>{t}percentage complete{/t}:</th>
			<td>
			<input type="range" name="data[percent_completed]" min="0" max="100" step="1" value="{$object.percent_completed|default:0}">
			</td>
 		</tr>
		<tr>
			<th>{t}duration{/t}:</th>
			<td>
				<input type="text" name="data[duration]" value="{if !empty($object.duration)}{$object.duration/60}{/if}" />
			</td>
		</tr>
	</table>
	
</fieldset>