$(document).ready(function(){
	
	// uncheck closed ticket status if 'hide closed tickets' is selected
	$("#filterHideClosed").change(function() {
		if ($("#filterHideClosed").attr("checked")) {
			$("input[id^='status_'][rel=off]").each(function() {
				$(this).attr("checked", "");
			});
		}
	});
	
	// uncheck 'hide closed tickets' if 'resolved'  and/or 'unresolvable' and/or 'obsolete'are selected
	$("input[id^='status_'][rel=off]").change(function() {
		if ($("input[id^='status_'][rel=off]:checked").length > 0) {
			$("#filterHideClosed").attr("checked", "");
		}
	});
	

});