<?php
/*-----8<--------------------------------------------------------------------
 * 
 * BEdita - a semantic content management framework
 * 
 * Copyright 2010 ChannelWeb Srl
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
 * Write here your module global configurations. This configurations will be loaded in every BEdita's page
 * For example use it to define objects relations with other BEdita objects  
 */

$config["objRelationType"] = array(
   "seeTicket" => array(
		"hidden" => true,
		"left" 	 => array("ticket"),
		"right"  => array("ticket")
	),
	"assign" => array(
		"hidden" => false,
		"left" 	 => array("ticket"),
		"right"  => array("user")
	)
);


?>