<?php

$config["ticketSeverity"] = array (
	 "minor", "normal", "major", "critical",
);

$config["ticketStatus"] = array (
	"new" => "draft",
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

// NOTIFICATION MESSAGES
// ticketNewAssignementMsg - ticketUnassignementMsg - ticketModifiedMsg

$config["ticketNewAssignementMsg"] = array(
	"subject" => "[BEdita] #[\$id]: ticket assignement",
	"mail_body" => "Hi [\$user]," .
					"\n\n[\$author] has assigned to you the ticket #[\$id] " .
					"\n\nview ticket here: [\$url]" .
					"\n\n'[\$title]'" .
					"\n\n<<[\$text]>>",
);

$config["ticketUnassignementMsg"] = array(
	"subject" => "[BEdita] #[\$id]: ticket unassignement",
	"mail_body" => "Hi [\$user], " .
					"\n\n[\$author] has removed you from ticket #[\$id] " .
					"\n\nview ticket here: [\$url]" .
					"\n'[\$title]'",
);

$config["ticketModifiedMsg"] = array(
	"subject" => "[BEdita] #[\$id]: ticket changed",
	"mail_body" => "Hi [\$user], " .
					"\n\n[\$author] changed ticket #[\$id] : [\$url] - '[\$title]'" .
					"\n\n[\$changedFields]" .
					"\n\nview ticket here: [\$url]",

);

?>