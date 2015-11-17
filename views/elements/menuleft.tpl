{$view->set("method", $method)}
<div class="primacolonna">

	<div class="modules"><label class="bedita" rel="{$html->url('/')}">{$conf->projectName|default:''}</label></div>

	{if strcmp($conf->majorVersion, "3.2") < 0}
		{$view->element("messages")}
	{/if}
	
		<ul class="menuleft insidecol">
		<li {if $method eq 'index'}class="on"{/if}>{$tr->link('Tickets', '/tickets')}</li>
		{if $module_modify eq '1'}
		<li><a href="{$html->url('/tickets/view')}">{t}Create new ticket{/t}</a></li>
		{/if}
		<li {if $method eq 'categories'}class="on"{/if}>{$tr->link('Categories', '/tickets/categories')}</li>
		<li {if $method eq 'flow'}class="on"{/if}>{$tr->link('Flow view', '/tickets/flow')}</li>
	</ul>

{$view->element("export")}

{if (!empty($method)) && $method eq "index"}

		<div class="insidecol publishingtree">
			
			{$view->element("tree")}
		
		</div>

{/if}

{$view->element("previews")}

{$view->element("user_module_perms")}

</div>