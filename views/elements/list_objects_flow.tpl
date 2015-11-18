<div class="flow-wrapper noselect">
{foreach array_keys($conf->flowStatus) as $fs}
	<div class="flow-column" style="width: {100 / $fs@total - 1}%;">
		<h1>{$fs}</h1>

        {foreach $conf->flowStatus[$fs] as $s}
        <div class="flow-container" data-flow-status="{$s}">
            {$s}<br>
    		{if !empty($objectsByStatus[$fs][$s])}
    			{foreach $objectsByStatus[$fs][$s] as $o}
    			<div class="flow-item" title="{$o.description|strip_tags:true}" data-flow-id="{$o.id}">
    				{*dump var=$o*}
    				<h2>{$o.title}</h2>

                    <p>Assigned: {if !empty($o.UsersAssigned)}
                        {foreach from=$o.UsersAssigned item="u" name="assigned"}
                        {$u.userid}
                        {/foreach}
                    {/if}</p>
numero di note

                    <table>
                        <tr>
                            <td>{t}status{/t}:</td>
                            <td>{$o.ticket_status}</td>
                        </tr>
                        <tr>
                            <td>{t}created{/t}:</td>
                            <td>{$o.created|date_format:$conf->dateTimePattern}</td>
                        </tr>
                        <tr>
                            <td>{t}modified{/t}:</td>
                            <td>{$o.modified|date_format:$conf->dateTimePattern}</td>
                        </tr>
                    </table>

                    <a class="edit button" href="{$html->url('view/')}{$o.id}" target="_blank">{t}open{/t}</a>
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
var drake;
$(document).ready(function() {
    var flowElems = document.getElementsByClassName('flow-container');
    var flowElemsArr = [].slice.call(flowElems);
    drake = dragula(flowElemsArr, {
            revertOnSpill: true,
            invalid: function (el) {
                return el.tagName === 'H1';
            }
        }).on('drag', function (el, source) {
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
                });
            }
        });
});
</script>
