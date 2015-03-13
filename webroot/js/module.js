$(document).ready(function(){
	
	// uncheck closed ticket status if 'hide closed tickets' is selected
	$("#filterHideClosed").change(function() {

		//alert($("#filterHideClosed:checked").length);
		if ($("#filterHideClosed:checked").length > 0) {
			$("input[id^='status_'][rel=off]").each(function() {
				$(this).attr("checked", false);
			});
		} else {
			$("input[id^='status_'][rel=off]").each(function() {
				$(this).attr("checked", true);
			});
		}
	});
	
	// uncheck 'hide closed tickets' if 'resolved'  and/or 'unresolvable' and/or 'obsolete'are selected
	$("input[id^='status_'][rel=off]").change(function() {
		if ($("input[id^='status_'][rel=off]:checked").length > 0) {
			$("#filterHideClosed").attr("checked", false);
		} else {
			$("#filterHideClosed").attr("checked", "checked");
		}
	});

	// close ticket through out close button in modal dialog
	$(document).delegate('div#closeDialogContainer #closeTicket', 'click', function() {
		var status = $("input[name=closeAs]:checked", "#closeDialogContainer").val();
		$("select#ticketStatus option[value='" + status + "']").attr('selected', 'selected');
		$("#saveBEObject").click();
		$("#modalmain").empty().css({height: '80px'}).addClass("modaloader");
	});
	
	$('#ticketStatus').change(function () {
		$('#status').val(ts[this.value]);
	});

});