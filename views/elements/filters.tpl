<div class="tab{if $filterActive} open filteractive{/if}"><h2>{t}filters{/t}</h2></div>
<div class="filters" id="ticketfilter">
	<form id="formFilter" action="{$beurl->getUrl(['page', 'dim', 'dir', 'order'])}" method="post">
		<input type="hidden" name="cleanFilter" value=""/>
			{if !empty($view->SessionFilter)}
	        <div class="cell word">
	            <label>{t}search word{/t}:</label>
	                <input type="text" placeholder="{t}search word{/t}" name="filter[query]" id="search" style="width:255px" value="{$view->SessionFilter->read('query')}"/>&nbsp;
	                <input type="checkbox"
	                    {if $view->SessionFilter->check('substring') || !$view->SessionFilter->check()}
	                        checked="checked"
	                    {/if} 
	                    id="modalsubstring" name="filter[substring]" /> <span>{t}substring{/t}</span>
	        </div>
			<div class="cell categories">
				<label>{t}categories{/t}:</label>
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
			</div>
			<div class="cell position">
				<label>{t}on position{/t}:</label>
					<select name="filter[parent_id]" id="parent_id" class="areaSectionAssociation">
						<option value="">{t}None{/t}</option>
						{$beTree->option($tree, $view->SessionFilter->read('parent_id'))}
					</select>
					&nbsp;<input type="checkbox" name="filter[descendants]"
					{if $view->SessionFilter->check('descendants')}checked="checked"{/if} />
					<span>{t}descendants{/t}</span>
			</div>
			{/if}
			<div class="cell ticket-status">			
			{assign var="prevsta" value="draft"}	
				<label>{t}status:{/t}</label>
				<ul>
				{foreach item=sta key='key' name=s from=$conf->ticketStatus}
					{if ($prsta|default:'draft' != $sta)}</ul><ul>{/if}
					<li>
						<input type="checkbox" value="{$key}" name="data[status][{$key}]" class="filterTicket" rel="{$sta}" id="status_{$key}" {if in_array($key, $filter['Ticket.ticket_status'])}checked="checked"{/if}/>
						<span>{t}{$key}{/t}</span>
					</li>
					{$prsta = $sta}
				{/foreach}
				</ul>
			</div>

			<div class="cell relations">
				<label>{t}relations{/t}:</label>
				<select name="filter[relation]" id="relation">
					<option value="">{t}all{/t}</option>
					{foreach $ticketRelations as $relName => $relLabel}
						{strip}
						<option value="{$relName}" {if $view->SessionFilter->read('relation') == $relName}selected="selected"{/if}>
							{t}{$relLabel}{/t}
						</option>
						{/strip}
					{/foreach}
				</select>

				&nbsp;
					<input type="checkbox" name="filter[tree_related_object]"
						{if $view->SessionFilter->check('tree_related_object')}checked="checked"{/if} />
						<span>{t}with items located on above position{/t}</span>
			</div>

			<div class="cell reporter">
				<label>{t}reporter{/t}:</label>
					<select name="data[reporter]" class="filterTicket">
						<option value="">all</option>
						{foreach item=reporter key='key' from=$reporters}
						<option value="{$reporter.User.id}" {if (!empty($filter['BEObject.user_created']) && ($filter['BEObject.user_created'] == $reporter.User.id))}selected="selected"{/if}>{$reporter.User.userid}</option>
						{/foreach}
					</select>
			</div>
			<div class="cell assigned">
				<label>{t}assigned to{/t}:</label>
					<select name="data[assigned_to]" class="filterTicket">
						<option value="">all</option>
						{foreach item=user key='key' from=$assignedUsers}
						<option value="{$user.User.id}" {if !empty($filter['ObjectUser.user_id']) && $filter['ObjectUser.user_id'] == $user.User.id}selected="selected"{/if}>{$user.User.userid}</option>
						{/foreach}
					</select>
			</div>

			<div class="cell severity">
				<label>{t}severity{/t}:</label>
					<select name="data[severity]" id="ticketSev" class="filterTicket">
						<option value="">all</option>
					{foreach item=sev from=$conf->ticketSeverity}
						<option value="{$sev}" {if (!empty($filter['Ticket.severity']) && ($filter['Ticket.severity'] == $sev))}selected="selected"{/if}>{$sev}</option>
					{/foreach}
					</select>
			</div>

			<div class="cell" style="padding-top:10px">
				{assign var="hide_off" value=$filter.hide_status_off|default:false}
				<input type="checkbox" name="data[hide_status_off]" id="filterHideClosed" 
				{if ($hide_off)}checked="checked"{/if} />
				<span class="showclosed">{t}hide closed tickets{/t}</span>	
			</div>

			<div class="formbuttons">
				<input type="submit" id="searchButton" style="width:150px" value=" {t}find it{/t} ">
				<input type="button" id="cleanFilters" value=" {t}reset filters{/t} ">
			</div>
	</form>
</div>
