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

$config['ticketBoard'] = array(
	'backlog' => array(
		'orderBy' => 'modified',
		'loadMore' => true,
		'ticketStatus' => array(
			"new" => 6
		)
	),
	'todo' => array(
		'orderBy' => 'modified',
		'loadMore' => true,
		'ticketStatus' => array(
			"reopened" => 1,
			"assigned" => 5
		)
	),
	'in progress' => array(
		'orderBy' => 'modified',
		'loadMore' => true,
		'ticketStatus' => array(
			"analysis" => 7,
			"development" => 8
		)
	),
	'test' => array(
		'orderBy' => 'modified',
		'loadMore' => true,
		'ticketStatus' => array(
			"test" => 2
		)
	),
	'done' => array(
		'orderBy' => 'modified',
		'loadMore' => true,
		'ticketStatus' => array(
			"resolved" => 3,
			"unresolvable" => 4,
			"obsolete" => 6,
			"duplicate" => 9
		)
	)
);

$config['showGravatar'] = true;

// define groups for ticket assignement, default backend authorized groups 
$config["ticketAssignGroups"] = array(
	// "administrator",
	// "tickets",
);

