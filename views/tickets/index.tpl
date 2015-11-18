{if strnatcmp($conf->majorVersion, '3.3') > 0}
    {$html->script('libs/jquery/jquery-migrate-1.2.1', false)} {* assure js retrocompatibility *}
{/if}

{literal}
<script type="text/javascript">
    $(document).ready(function(){	
    	openAtStart("#ticketfilter");
    });
</script>
{/literal}

{$view->element("modulesmenu")}

{$view->element('menuleft', ['method' => 'index'])}

{$view->element('menucommands', ['method' => 'index'])}

{$view->element("toolbar")}

<div class="mainfull">

	{$view->element("filters")}
		
	{$view->element("list_objects")}

</div>
