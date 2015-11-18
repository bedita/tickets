<?php

$config["ticketSeverity"] = array(
	 "minor", "normal", "major", "critical",
);

$config["ticketStatus"] = array(
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

$config['flowStatus'] = array(
	'backlog' => array(
		"new"
	),
	'todo' => array(
		"reopened", "assigned"
	),
	'in progress' => array(
		"analysis", "development"
	),
	'test' => array(
		"test"
	),
	'done' => array(
		"resolved", "unresolvable", "obsolete", "duplicate"
	)
);

$config['flowShowGravatar'] = true;

// define groups for ticket assignement, default backend authorized groups 
$config["ticketAssignGroups"] = array(
	// "administrator",
	// "tickets",
);

?>