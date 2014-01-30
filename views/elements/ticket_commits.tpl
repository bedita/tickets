{if empty($hideCommits) && !empty($object)}

	<div class="tab"><h2>{t}Commits{/t}</h2></div>
 
	<div id="ticketcommits" style="padding-left:10px">

	{strip}
		<div id="listCommit" style="margin:10px;">
		{if (!empty($object.TicketCommitNote))}
            {foreach from=$object.TicketCommitNote item="tickNote" name=tickNotes}
                {assign_associative var="params" note=$tickNote count=$smarty.foreach.tickNotes.iteration}
				{$view->element('single_note', $params)}
			{/foreach}
		{/if}
		</div>
	{/strip}
	</div>

{/if}