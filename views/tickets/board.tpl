{if strnatcmp($conf->majorVersion, '3.3') > 0}
    {$html->script('libs/jquery/jquery-migrate-1.2.1', false)} {* assure js retrocompatibility *}
{/if}

{$html->css("/tickets/css/flow.css", null, ['inline' => false])}

{literal}
<script type="text/javascript">
    $(document).ready(function(){	
    	openAtStart("#ticketfilter");
    });
</script>
{/literal}

{$view->element("modulesmenu")}

{assign_associative var="params" method="index"}
{$view->element("menuleft", $params)}
{$view->element("menucommands", $params)}


<div class="mainfull">

	{*$view->element("filters")*}
		
	{$view->element("list_objects_flow")}

</div>
