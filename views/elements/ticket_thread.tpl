<script type="text/javascript">
var urlLoadNote = "{$html->url('/tickets/loadNote')}";
var urlDelNote = "{$html->url('/pages/deleteNote')}";
var comunicationErrorMsg = "{t}Communication error{/t}";
var confirmDelNoteMsg = "{t}Are you sure that you want to delete the note?{/t}";

{literal}
$(document).ready( function (){
	$("#editornotes").prev(".tab").BEtabsopen();

	var optionsNoteForm = {
		beforeSubmit: function() {$("#noteloader").show();},
		success: showNoteResponse,
		dataType: "json",
		resetForm: true,
		error: function() {
			alert(comunicationErrorMsg);
			$("#noteloader").hide();
		}
	};

	var overrideOptions = {
		success: function(data, textStatus, jqXHR) {
			showNoteResponse(data, textStatus, jqXHR, true);
		}
	};
	var optionsNoteCloseForm = $.extend({}, optionsNoteForm, overrideOptions);

	$("#saveNote").ajaxForm(optionsNoteForm);
	
	$("#saveNoteAndClose").click(function() {
		$("#saveNote").ajaxSubmit(optionsNoteCloseForm);
	});

	$(document).delegate('#listNote input[name=deletenote]', 'click', function() {
		refreshNoteList($(this));
	});
});	

function showNoteResponse(data, textStatus, jqXHR, closeTicket) {
	if (data.errorMsg) {
		alert(data.errorMsg);
		$("#noteloader").hide();
	} else {
		var closeTicket = (typeof closeTicket == 'boolean') ? closeTicket : false;
		$.ajax({
			url: urlLoadNote,
			type:"post",
			dataType: "html",
			data: data,
			success: function(response, status, xhr) {
				$("#listNote").append(response);
				$("#noteloader").hide();
				if ($("#listNote div.js-single-note").length > 0) {
					$("#delBEObject").remove();
				}
				if (closeTicket) {
					$("#closeDialogButton").click();
				}
			}
		});
	}
}

function refreshNoteList(delButton) {
	var div = delButton.parents("div:first");
	var postdata = {id: delButton.attr("rel")};
	if (confirm(confirmDelNoteMsg)) {
		$.ajax({
			type: "POST",
			url: urlDelNote,
			data: postdata,
			dataType: "json",
			beforeSend: function() {$("#noteloader").show();},
			success: function(data){
				if (data.errorMsg) {
					alert(data.errorMsg);
					$("#noteloader").hide();
				} else {
					$("#noteloader").hide();
					div.remove();
				}
			},
			error: function() {
				alert(comunicationErrorMsg);
				$("#noteloader").hide();
			}
		});
	}
}

</script>

<style>
	
	P.editornotes {
		background-color:#FFF;
		min-height:40px;
		line-height:1.5em !important;
	}
	#listNote input{
		margin-left:570px !important;
	}

	#editornotes .author {
		white-space: nowrap;
	}

	.editorheader .date {
		text-align:left !important; padding-left:10px;
	}
		
</style>

{/literal}
{if !empty($object)}

	<div class="tab"><h2>{t}Notes{/t}</h2></div>
 
	<div id="editornotes">

	{strip}

		<div id="listNote">
		{if (!empty($object.EditorNote))}
            {foreach from=$object.EditorNote item="note" name=notes}
                {assign_associative var="params" note=$note count=$smarty.foreach.notes.iteration}
				{$view->element('single_note', $params)}
			{/foreach}
		{/if}
		</div>
		
		<form id="saveNote" action="{$html->url('/tickets/saveNote')}" method="post">
		<input type="hidden" name="data[object_id]" value="{$object.id}"/>

		<table class="editorheader ultracondensed">
		<tr>
			<td class="author">you</td>
			<td class="date">now</td>
		</tr>
		</table>	
		<textarea id="notetext" name="data[description]" style="width: 100%"></textarea>
		<input type="submit" style="margin:10px 10px 10px 0px;" value="{t}send{/t}"  />
		<input type="button" id="saveNoteAndClose" value="{t}send & close{/t}"{if $conf->ticketStatus[$object.ticket_status] == "off"}disabled{/if} />
		</form>
		
		<br style="clear:both" />
		<div class="loader" id="noteloader" style="clear:both">&nbsp;</div>
	
	{/strip}
	</div>

{/if}