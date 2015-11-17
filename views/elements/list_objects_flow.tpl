<div class="flow-wrapper noselect">
{foreach $flowStatusKeys as $s}
	<div id="flow-col-{$s@index}" class="container" style="width: {100 / $s@total - 1}%;">
		<h1>{$s}</h1>

		{if !empty($objectsByStatus[$s])}
			{foreach $objectsByStatus[$s] as $o}
			<div class="flow-item" title="{$o.description|strip_tags:true}">
				{*dump var=$o*}
				<h2>{$o.title}</h2>
                <p>{if !empty($o.UsersAssigned)}
                    {foreach from=$o[i].UsersAssigned item="u" name="assigned"}
                    {$u.userid}
                    {/foreach}
                {/if}</p>

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





{$html->script('/tickets/js/dragula.min')}
{$html->css("/tickets/css/dragula.css", null, ['inline' => false])}

<script>
$(document).ready(function() {
    var flowElems = document.getElementsByClassName('container');
    var flowElemsArr = [].slice.call(flowElems);
    dragula(flowElemsArr, {
        invalid: function (el) {
            return el.tagName === 'H1';
        }
    });
});
</script>
