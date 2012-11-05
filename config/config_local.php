<?php

$config["ticketSeverity"] = array (
	 "minor", "normal", "major", "critical",
);

$config["ticketStatus"] = array (
	"new" => "draft",
	"reopened" => "draft",
	"assigned" => "on",
	"analysis" => "on",
	"development" => "on",
	"test" => "on",
	"resolved" => "off",
	"unresolvable" => "off",
	"obsolete" => "off",
	"duplicate" => "off"
);

// define groups for ticket assignement, default backend authorized groups 
$config["ticketAssignGroups"] = array (
	// "administrator",
	// "tickets",
);

?>