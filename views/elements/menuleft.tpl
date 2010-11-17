{*
Template incluso.
Menu a SX valido per tutte le pagine del controller.
*}

{$view->set("method", $method)}
<div class="primacolonna">

	<div class="modules"><label class="bedita" rel="{$html->url('/')}">{$conf->projectName|default:$conf->userVersion}</label></div>

	{$view->element("messages")}
	
		<ul class="menuleft insidecol">
		<li {if $method eq 'index'}class="on"{/if}>{$tr->link('Tickets', '/tickets')}</li>
		<li {if $method eq 'categories'}class="on"{/if}>{$tr->link('Categories', '/tickets/categories')}</li>
		{if $module_modify eq '1'}
		<li><a href="{$html->url('/tickets/view')}">{t}Create new ticket{/t}</a></li>
		{/if}
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