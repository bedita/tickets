{if strnatcmp($conf->majorVersion, '3.3') <= 0}
    {$javascript->link("jquery/jquery.changealert", false)}
{else}
    {$html->script('libs/jquery/jquery-migrate-1.2.1', false)} {* assure js retrocompatibility *}
    {$html->script('libs/jquery/plugins/jquery.changealert', false)}
{/if}
	
{$view->element("modulesmenu")}

{assign_associative var="params" method="categories"}
{$view->element("menuleft", $params)}


<div class="head">
	
	<h1>{t}Categories{/t}</h1>

</div>

{$view->element("menucommands", $params)}

<div class="main">
{$view->element("list_categories")}
</div>
