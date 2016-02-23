<div class="flow-toolbar">
    <div class="js-toolbar-categories">
        {foreach $categories as $categoryId => $categoryLabel}
            {$url = '/tickets/board/toggleCategory:'|cat:$categoryId}
            {$toggleCategoryClass = ''}
            {if $view->SessionFilter->check('boardCategories')}
                {if in_array($categoryId, $view->SessionFilter->read('boardCategories'))}
                    {$toggleCategoryClass = 'on'}
                {/if}
            {/if}
            <a href="{$html->url($url)}" class="filter-category-btn {$toggleCategoryClass}">{$categoryLabel}</a>
        {/foreach}
    </div>
</div>



<div class="flow-wrapper noselect">
{foreach array_keys($conf->ticketBoard) as $fs}
	<div class="flow-column" style="width: {100 / $fs@total - 1}%;">
		<h1>{$fs}</h1>
        {if in_array($fs, $showOffColumns)}
            {if $view->SessionFilter->check('status') && in_array('off', $view->SessionFilter->read('status'))}
                <a href="{$html->url('/tickets/board/show:default')}" class="show-hide-btn" title="{t}hide off{/t}">{t}hide off{/t}</a>
            {else}
                <a href="{$html->url('/tickets/board/show:all')}" class="show-hide-btn off" title="{t}show all{/t}">{t}show all{/t}</a>
            {/if}
        {/if}

        {foreach array_keys($conf->ticketBoard[$fs].ticketStatus) as $s}
        <label>{$s}</label>
        <div class="flow-container" data-flow-status="{$s}">
    		{if !empty($objectsByStatus[$fs][$s])}
    			{foreach $objectsByStatus[$fs][$s] as $o}
                {$itemTitle = $o.description|strip_tags}
    			<div class="flow-item js-flow-item" title="{$itemTitle}" data-flow-id="{$o.id}">
    				{*dump var=$o*}
    				<h2><span>#{$o.id}&nbsp;</span><br>{$o.title}</h2>

                    {if !empty($o.UsersAssigned)}
                    <p class="item-assign">
                        {foreach $o.UsersAssigned as $u}
                            {if !empty($conf->showGravatar)}
                                {$gravatar->image($u, [
                                    'html' => [
                                        'align' => 'center'
                                    ]
                                ])}
                            {/if}
                            <span>{$u.userid}</span>
                        {/foreach}
                    </p>
                    {/if}

                    {*if !empty($o.categories)}
                    <p class="item-assign">
                        {foreach $o.categories as $cid => $cl}
                            <span>{$cl}</span>
                        {/foreach}
                    </p>
                    {/if*}

                    <footer>
                        {if !empty($o.severity)}
                        <span class="item-severity {if !empty($o.severity)}{$o.severity}{/if} js-item-severity"></span>
                        {/if}
                        {if $o.num_of_editor_note|default:''}
                        <span class="item-notes">{$o.num_of_editor_note|default:''}</span>
                        {/if}
                        <span class="item-create-date">{t}created{/t}: {$o.created|date_format:$conf->dateTimePattern}</span>
                        <span class="item-modify-date">{$o.modified|date_format:$conf->dateTimePattern}</span>
                    </footer>

                    <a class="edit-btn js-edit-btn" href="{$html->url('view/')}{$o.id}" target="_blank">{t}open{/t}</a>
                </div>
                {/foreach}
            {/if}
            
        </div>
        {/foreach}

	</div>
{/foreach}
</div>


{$html->script('/tickets/js/dragula.min')}
{$html->css("/tickets/css/dragula.css", null, ['inline' => false])}
{$html->script('/tickets/js/board')}
