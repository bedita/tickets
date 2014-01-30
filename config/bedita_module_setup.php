<?php
/*-----8<--------------------------------------------------------------------
 * 
 * BEdita - a semantic content management framework
 * 
 * Copyright 2013 ChannelWeb Srl, Chialab Srl
 * 
 * This file is part of BEdita: you can redistribute it and/or modify
 * it under the terms of the Affero GNU General Public License as published 
 * by the Free Software Foundation, either version 3 of the License, or 
 * (at your option) any later version.
 * BEdita is distributed WITHOUT ANY WARRANTY; without even the implied 
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the Affero GNU General Public License for more details.
 * You should have received a copy of the Affero GNU General Public License 
 * version 3 along with BEdita (see LICENSE.AGPL).
 * If not, see <http://gnu.org/licenses/agpl-3.0.html>.
 * 
 *------------------------------------------------------------------->8-----
 */

/**
 * tickets setup 
 */
$moduleSetup = array(

	"publicName" => "tickets",
	"author" => "Channelweb and Chialab",
	"website" => "http://www.bedita.com",
	"emailAddress" => "info@bedita.com",
	"version" => "0.1",
	"BEditaMinVersion" => "3.1",
	"description" => "Tickets Module",
	"BEditaObjects" => array("Ticket", "TicketCommitNote"),
	"tables" => array("tickets"),
);

?>