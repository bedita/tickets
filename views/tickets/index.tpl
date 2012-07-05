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

{assign_associative var="params" method="index"}
{$view->element("menucommands", $params)}

{$view->element("toolbar")}

<div class="mainfull">
	<form method="post" action="" id="formObject">

	{$view->element("filters")}
	
	{$view->element("list_objects")}

	</form>
</div>