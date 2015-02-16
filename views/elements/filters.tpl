<div class="tab"><h2>{t}filters{/t}</h2></div>
<div id="ticketfilter">
	<form id="formFilter" action="{$beurl->getUrl(['page', 'dim', 'dir', 'order'])}" method="post">
		<input type="hidden" name="cleanFilter" value=""/>
		<table class="filters" style="width:100%">
			{if !empty($view->SessionFilter)}
	        <tr>
	            <th><label>{t}search word{/t}:</label></th>
	            <td colspan="6">
	                <input type="text" placeholder="{t}search word{/t}" name="filter[query]" id="search" style="width:255px" value="{$view->SessionFilter->read('query')}"/>&nbsp;
	                <input type="checkbox"
	                    {if $view->SessionFilter->check('substring') || !$view->SessionFilter->check()}
	                        checked="checked"
	                    {/if} 
	                    id="modalsubstring" name="filter[substring]" /> <label>{t}substring{/t}</label>
	            </td>
	        </tr>
			<tr>
				<th><label>{t}categories{/t}:</label></th>
				<td colspan="100">
					<select name="filter[category]">
						<option value="">{t}all{/t}</option>
						{foreach $categories as $catId => $catLabel}
							{strip}
							<option value="{$catId}"{if $view->SessionFilter->read('category') == $catId}selected="selected"{/if}>
								{$catLabel}
							</option>
							{/strip}
						{/foreach}
					</select>
				</td>
			</tr>
			<tr>
				<th><label>{t}on position{/t}:</label></th>
				<td>
					<select name="filter[parent_id]" id="parent_id" class="areaSectionAssociation">
						<option value="">{t}None{/t}</option>
						{$beTree->option($tree, $view->SessionFilter->read('parent_id'))}
					</select>
					{if !empty($filters.treeDescendants)}
						&nbsp;<input type="checkbox" name="filter[descendants]"
							{if $view->SessionFilter->check('descendants')}checked="checked"{/if} /> <label>{t}descendants{/t}</label>
					{/if}
				</td>
			</tr>
			{/if}
			<tr>			
			{assign var="prevsta" value="draft"}
				<th>
					<label>{t}status:{/t}</label>
				</th>
				<td colspan="100">
					<style scoped>
						.ticket-status {
							width: 100%;
						}
						.ticket-status span{
							width: 100px;
							display: inline-block;
						}
					</style>
					<table class="ticket-status">
						<tr>
							<td style="vertical-align: top">
						{foreach item=sta key='key' from=$conf->ticketStatus}
							{if $prevsta!=$sta}
								</td>
								<td style="vertical-align: top">
							{/if}
							<span>{t}{$key}{/t}:</span>
							<input type="checkbox" value="{$key}" name="data[status][{$key}]" class="filterTicket" rel="{$sta}" id="status_{$key}" {if in_array($key, $filter['Ticket.ticket_status'])}checked="checked"{/if}/><br>
							{$prevsta=$sta}	
						{/foreach}
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<th><label>{t}hide closed tickets{/t}: </label></th>
				<td>				
					{assign var="hide_off" value=$filter.hide_status_off|default:false}
					<input type="checkbox" name="data[hide_status_off]" id="filterHideClosed" 
					{if ($hide_off)}checked="checked"{/if} style="vertical-align: bottom;"/>
				</td>
			</tr>
			<tr>
				<th><label>{t}reporter{/t}:</label></th>
				<td>
					<select name="data[reporter]" class="filterTicket">
						<option value="">all</option>
						{foreach item=reporter key='key' from=$reporters}
						<option value="{$reporter.User.id}" {if (!empty($filter['BEObject.user_created']) && ($filter['BEObject.user_created'] == $reporter.User.id))}selected="selected"{/if}>{$reporter.User.userid}</option>
						{/foreach}
					</select>
				</td>
			</tr>
			<tr>
				<th><label>{t}assigned to{/t}:</label></th>
				<td>
					<select name="data[assigned_to]" class="filterTicket">
						<option value="">all</option>
						{foreach item=user key='key' from=$assignedUsers}
						<option value="{$user.User.id}" {if !empty($filter['ObjectUser.user_id']) && $filter['ObjectUser.user_id'] == $user.User.id}selected="selected"{/if}>{$user.User.userid}</option>
						{/foreach}
					</select>
				</td>
			</tr>
			<tr>
				<th><label>{t}severity{/t}:</label></th>
				<td>
					<select name="data[severity]" id="ticketSev" class="filterTicket">
						<option value="">all</option>
					{foreach item=sev from=$conf->ticketSeverity}
						<option value="{$sev}" {if (!empty($filter['Ticket.severity']) && ($filter['Ticket.severity'] == $sev))}selected="selected"{/if}>{$sev}</option>
					{/foreach}
					</select>
				</td>
			</tr>
			<tr>
				<th></th>
				<td colspan="10">
					<input type="submit" id="searchButton" style="width:150px" value=" {t}find it{/t} ">
					<input type="button" id="cleanFilters" value=" {t}reset filters{/t} ">
				</td>
			</tr>
		</table>
	</form>
</div>
