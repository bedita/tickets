{if strnatcmp($conf->majorVersion, '3.3') > 0}
    {$html->script('libs/jquery/jquery-migrate-1.2.1', false)} {* assure js retrocompatibility *}
{/if}

<script type="text/javascript">
<!--
var userTicketRelation = "{$relation}";
{literal}

$(document).ready(function() {

	$("#usersToTickets").click(function() {
		var users = "";
		var ids = "";
		$(".ucheck:checked").each(function(){
			if (users != "") {
				ids += ",";
				//users+=",";
			}
			ids += $(this).val();
			users += "<li>" + $(this).attr('rel') + "</li>";
		});
		$("#modal").hide();
		$("#modaloverlay").hide();
		relateTicketToUsers(ids,users,userTicketRelation);
	});


});
{/literal}
//-->
</script>

<div class="bodybg" style="min-height:480px; padding:20px;">
	
<form id="uticketsForm" method="post">

<div class="tab stayopen"><h2>{t}Select / unselect user(s) from the list{/t}</h2></div>
<fieldset id="selectuser">
<table class="bordered">
	<tr>
		<td></td>
		<th>{t}username{/t}</th>
		<th style="width:50%">{t}realname{/t}</th>
	</tr>
	{foreach from=$users item=u}
	{if empty($u.Ticket)}
	<tr>
		<td style="text-align:right"><input type="checkbox" class="ucheck" value="{$u.User.id}" rel="{$u.User.userid}" name="data[users][{$u.User.id}]" {if !empty($u.User.related)}checked="checked"{/if}/></td>
		<td>{$u.User.userid}</td>
		<td>{$u.User.realname}</td>
	</tr>
	{/if}
	{/foreach}
</table>

<input id="usersToTickets" style="margin:10px 0px 10px 100px" type="button" value=" {if $relation == "assigned"}{t}assign{/t}{elseif $relation == "notify"}{t}notify{/t}{/if} "/>
</fieldset>

</form>

</div>