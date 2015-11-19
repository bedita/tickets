<div class="flow-wrapper noselect">
{foreach array_keys($conf->flowStatus) as $fs}
	<div class="flow-column" style="width: {100 / $fs@total - 1}%;">
		<h1>{$fs}</h1>
        {if in_array($fs, $showOffColumns)}
            {if $view->SessionFilter->check('status')}
                <a href="{$html->url('/tickets/board')}" class="show-hide-btn" title="{t}hide off{/t}">{t}hide off{/t}</a>
            {else}
                <a href="{$html->url('/tickets/board/show:off')}" class="show-hide-btn off" title="{t}show all{/t}">{t}show all{/t}</a>
            {/if}
        {/if}

        {foreach $conf->flowStatus[$fs] as $s}
        <label>{$s}</label>
        <div class="flow-container" data-flow-status="{$s}">
    		{if !empty($objectsByStatus[$fs][$s])}
    			{foreach $objectsByStatus[$fs][$s] as $o}
                {$itemTitle = $o.description|strip_tags}
    			<div class="flow-item" title="{$itemTitle}" data-flow-id="{$o.id}">
    				{*dump var=$o*}
    				<h2><span>#{$o.id}&nbsp;</span><br>{$o.title}</h2>

                    {if !empty($o.UsersAssigned)}
                    <p class="item-assign">
                        {foreach from=$o.UsersAssigned item="u" name="assigned"}
                            {if !empty($conf->flowShowGravatar)}
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

                    {if $fs@index == 0}
                       
                    {/if}

                    <footer>
                        {if !empty($o.severity)}
                        <span class="item-severity {if !empty($o.severity)}{$o.severity}{/if}"></span>
                        {/if}
                        {if $o.num_of_editor_note|default:''}
                        <span class="item-notes">{$o.num_of_editor_note|default:''}</span>
                        {/if}
                        <span class="item-create-date">{t}created{/t}: {$o.created|date_format:$conf->dateTimePattern}</span>
                        <span class="item-modify-date">{$o.modified|date_format:$conf->dateTimePattern}</span>
                    </footer>

                    <a class="edit-btn" href="{$html->url('view/')}{$o.id}" target="_blank">{t}open{/t}</a>
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

<script>
$(document).ready(function() {

    // dragging
    var flowElems = document.getElementsByClassName('flow-container');
    var flowElemsArr = [].slice.call(flowElems);

    dragula(flowElemsArr, {
        revertOnSpill: true,
        invalid: function (el) {
            // return el.tagName === 'LABEL';
        }
    }).on('drag', function (el, source) {
        // nothing
    }).on('drop', function (el, target, source) {
        var sourceStatus = $(source).attr('data-flow-status');
        var targetStatus = $(target).attr('data-flow-status');
        var objectId = $(el).attr('data-flow-id');

        if (sourceStatus != targetStatus) {
            var postData = {
                data: {
                    id: objectId,
                    ticket_status: targetStatus
                }
            };

            $('.secondacolonna label.tickets').addClass('save');
            $.ajax({
                type: "POST",
                url: "{$html->url('/tickets/saveStatus')}",
                data: postData,
                dataType: 'json'
            }).done(function(response) {
                // console.log(response);
            }).error(function(jqXHR, textStatus, errorThrown) {
                $(source).append($(el));
                try {
                    if (jqXHR.responseText) {
                        var data = JSON.parse(jqXHR.responseText);
                        if (typeof data != 'undefined' && data.errorMsg && data.htmlMsg) {
                            $('#messagesDiv').empty();
                            $('#messagesDiv').html(data.htmlMsg).triggerMessage('error');
                        }
                    }
                } catch (e) {
                    console.error("Missing responseText or it's not a valid json");
                }
            }).always(function() {
                $('.secondacolonna label.tickets').removeClass('save');
            });
        }
    });

    // more UI
    $('.flow-item').mouseenter(function() {
        $(this).addClass('active-item');
    }).mouseleave(function() {
        $(this).removeClass('active-item');
    });

    
    $('.flow-item').on( "dblclick", function() {
        var url = $(this).find('a.edit').attr('href');
        location.href = url;
    });

});
</script>
