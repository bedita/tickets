<?php 
/* SVN FILE: $Id$ */
/* Magazines schema generated on: 2010-06-08 17:06:02 : 1276011782*/
class TicketsSchema extends CakeSchema {
	var $name = 'Tickets';

	function before($event = array()) {
		return true;
	}

	function after($event = array()) {
	}

	var $tickets = array(
		'id' => array('type' => 'integer', 'null' => false, 'default' => NULL, 'length' => 10, 'values' => NULL, 'key' => 'primary'),
		'severity' => array('type' => 'string', 'null' => true, 'length' => 30, 'values' => NULL),
		'ticket_status' => array('type' => 'string', 'null' => true, 'length' => 30, 'values' => NULL),
		'exp_resolution_date' => array('type' => 'datetime', 'null' => true, 'default' => NULL, 'values' => NULL),
		'closed_date' => array('type' => 'datetime', 'null' => true, 'default' => NULL, 'values' => NULL),
		'percent_completed' => array('type' => 'integer', 'null' => false, 'default' => NULL, 'length' => 10, 'values' => NULL, 'key' => 'primary'),
		'indexes' => array('PRIMARY' => array('column' => 'id', 'unique' => 1))
	);
}
?>