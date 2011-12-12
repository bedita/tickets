$(document).ready(function(){

	/* Funzione read/unread
	 * quando entro in un view/detail mi salva nel cookie "BE_visited" (o in sessione?) una stringa che si chiama <id>+<lastmodified>
	 * quando vedo l'elenco, per ogni TR cerco se il suo <id>+<lastmodified> è presente nel cookie (o in sessione?)
	 * se NON c'è aggiunge al TR lo status "unread"
	 * 
	 */
	
	
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