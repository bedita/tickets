<script type="text/javascript">
<!--
var formAction = "{$html->url('/tickets/assign')}";
{literal}

$(document).ready(function() {

	$("#usersToTickets").click(function() {
		var users = "";
		var ids = "";
		$(".ucheck:checked").each(function(){
			if(users!="") {
				ids+=",";
				users+=",";
			}
			ids+=$(this).val();
			users+=$(this).attr("rel");
		});
		$("#modal").hide();
		$("#modaloverlay").hide();
		assignTicketToUsers(ids,users);
	});

	$(".tab").click(function (){
		$(this).BEtabstoggle();
	});

	var openAtStart ="#selectuser";
	$(openAtStart).prev(".tab").BEtabstoggle();

});
{/literal}
//-->
</script>

<div class="bodybg" style="height:480px; padding:20px;">
	
<form id="uticketsForm" method="post">

<div class="tab"><h2>{t}Select user(s) from the list{/t}</h2></div>
<fieldset id="selectuser">
<table class="bordered">
	<tr>
		<td></td>
		<th>{t}username{/t}</th>
		<th style="width:50%">{t}realname{/t}</th>
	</tr>
	{dump var=$users}
	{foreach from=$users item=u}
	{if empty($u.Ticket)}
	<tr>
		<td style="text-align:right"><input type="checkbox" class="ucheck" value="{$u.User.id}" rel="{$u.User.userid}" name="data[users][{$u.User.id}]"/></td>
		<td>{$u.User.userid}</td>
		<td>{$u.User.realname}</td>
	</tr>
	{/if}
	{/foreach}
</table>

<input id="usersToTickets" style="margin:10px 0px 10px 100px" type="button" value=" {t}assign{/t} "/>
</fieldset>

</form>

</div>