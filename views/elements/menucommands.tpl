{*
Left column menu.
*}

{$view->set("method", $method)}
<div class="secondacolonna {if !empty($fixed)}fixed{/if}">
	
	{if !empty($method) && $method != "index" && $method != "categories"}
		{assign var="back" value=$session->read("backFromView")}
	{else}
		{assign_concat var="back" 1=$html->url('/') 2=$currentModule.url}
	{/if}

	<div class="modules">
		<label class="{$moduleName}" rel="{$back}">{t}{$currentModule.label}{/t}</label>
	</div> 
	
	
	{if !empty($method) && $method != "index" && $method != "categories"}
	<div class="insidecol">
		<input class="bemaincommands" type="button" value=" {t}Save{/t} " name="save" id="saveBEObject" />
		<!-- <input class="bemaincommands" type="button" value=" {t}clone{/t} " name="clone" id="cloneBEObject" /> -->
		{if !empty($object)}
			{if $object.ticket_status == "new" && empty($object.EditorNote)}
				<input class="bemaincommands" type="button" value="{t}Delete{/t}" name="delete" id="delBEObject" />
			{/if}
			<input class="bemaincommands modalbutton" rel="{$html->url('/tickets/closeAs')}" title="{t}Close ticket as{/t}" type="button" value="{t}Close{/t}" name="close" id="closeDialogButton"{if $conf->ticketStatus[$object.ticket_status] == "off"} disabled{/if} />
		{/if}
	</div>
	
		{$view->element("prevnext")}
	
	{/if}
</div>

