<div class="flow-wrapper">
{foreach $flowStatusKeys as $s}
	<div id="flow-col-{$s@index}" class="container" style="width: {100 / $s@total - 1}%;">
		<h1>{$s}</h1>

		{if !empty($objectsByStatus[$s])}
			{foreach $objectsByStatus[$s] as $o}
			<div class="flow-item">
				{*dump var=$o*}
				<h2>{$o.title}</h2>
                <p>{if !empty($o.UsersAssigned)}
                    {foreach from=$o[i].UsersAssigned item="u" name="assigned"}
                    {$u.userid}
                    {/foreach}
                {/if}</p>

                <table>
                    <tr>
                        <td>{t}Status{/t}:</td>
                        <td>{$o.ticket_status}</td>
                    </tr>
                    <tr>
                        <td>{t}Creato{/t}:</td>
                        <td>{$o.created|date_format:$conf->dateTimePattern}</td>
                    </tr>
                    <tr>
                        <td>{t}Modificato{/t}:</td>
                        <td>{$o.modified|date_format:$conf->dateTimePattern}</td>
                    </tr>
                </table>
			</div>
			{/foreach}
		{/if}
	</div>
{/foreach}


{*
      <div id="left-defaults" class="container">
        <div>You can move these elements between these two containers</div>
        <div>Moving them anywhere else isn't quite possible</div>
        <div>Anything can be moved around. That includes images, <a href="https://github.com/bevacqua/dragula">links</a>, or any other nested elements.
        	<sub>(You can still click on links, as usual!)</sub>
        </div>
      </div>
      <div id="right-defaults" class="container">
        <div>There's also the possibility of moving elements around in the same container, changing their position</div>
        <div>This is the default use case. You only need to specify the containers you want to use</div>
        <div>More interactive use cases lie ahead</div>
        <div>Moving <code>&lt;input/&gt;</code> elements works just fine. You can still focus them, too. <input placeholder="See?"></div>
        <div>Make sure to check out the <a href="https://github.com/bevacqua/dragula#readme">documentation on GitHub!</a></div>
      </div>
      <div id="sfaccimma" class="container">
        <div>You can move these elements between these two containers</div>
        <div>Moving them anywhere else isn't quite possible</div>
        <div>Anything can be moved around. That includes images, <a href="https://github.com/bevacqua/dragula">links</a>, or any other nested elements.
        	<sub>(You can still click on links, as usual!)</sub>
        </div>
      </div>
*}
</div>





{$html->script('/tickets/js/dragula.min')}
{$html->css("/tickets/css/dragula.css", null, ['inline' => false])}


<script>
$(document).ready(function() {
    var flowElems = document.getElementsByClassName('container');
    var flowElemsArr = [].slice.call(flowElems);
    dragula(flowElemsArr);
});

</script>


