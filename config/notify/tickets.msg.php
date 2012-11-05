<?php
// NOTIFICATION MESSAGES
// ticketNewAssignementMsg - ticketUnassignementMsg - ticketAddNotifyMsg - ticketRemoveNotifyMsg - ticketModifiedMsg

$notify["ticketNewAssignementMsg"]["eng"] = array(
	"subject" => "[BEdita] #[\$id]: ticket assignement",
	"mail_body" => "Hi [\$user]," .
					"\n\n[\$author] has assigned to you the ticket #[\$id] " .
					"\n\nview ticket here: [\$url]" .
					"\n\n'[\$title]'" .
					"\n\n<<[\$text]>>",
);

$notify["ticketUnassignementMsg"]["eng"] = array(
	"subject" => "[BEdita] #[\$id]: ticket unassignement",
	"mail_body" => "Hi [\$user], " .
					"\n\n[\$author] has removed you from ticket #[\$id] " .
					"\n\nview ticket here: [\$url]" .
					"\n'[\$title]'",
);

$notify["ticketAddNotifyMsg"]["eng"] = array(
	"subject" => "[BEdita] #[\$id]: ticket notification",
	"mail_body" => "Hi [\$user]," .
					"\n\n[\$author] has added you to the notification list for ticket #[\$id] " .
					"\n\nview ticket here: [\$url]" .
					"\n\n'[\$title]'" .
					"\n\n<<[\$text]>>",
);

$notify["ticketRemoveNotifyMsg"]["eng"] = array(
	"subject" => "[BEdita] #[\$id]: ticket notification removed",
	"mail_body" => "Hi [\$user], " .
					"\n\n[\$author] has removed you from notification list for ticket #[\$id] " .
					"\n\nview ticket here: [\$url]" .
					"\n'[\$title]'",
);

$notify["ticketModifiedMsg"]["eng"] = array(
	"subject" => "[BEdita] #[\$id]: ticket changed",
	"mail_body" => "Hi [\$user], " .
					"\n\n[\$author] changed ticket #[\$id] : [\$url] - '[\$title]'" .
					"\n\n[\$changedFields]" .
					"\n\nview ticket here: [\$url]",

);

?>