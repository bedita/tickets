<?php
/*-----8<--------------------------------------------------------------------
 * 
 * BEdita - a semantic content management framework
 * 
 * Copyright 2008 ChannelWeb Srl, Chialab Srl
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
 * Tickets ticket object
 *
 */
class Ticket extends BEAppObjectModel {

	public $searchFields = array("title" => 8 , "description" => 4, 
		"ticket_status" => 6, "severity" => 6);

	public $objectTypesGroups = array("related");

		protected $modelBindings = array( 
				"detailed" =>  array("BEObject" => array("ObjectType", 
															"UserCreated", 
															"UserModified", 
															"ObjectProperty",
															"RelatedObject",
															"Annotation",
															"Category"
															)),
				"default" => array("BEObject" => array("ObjectProperty", 
									"ObjectType", "Annotation",
									"Category", "RelatedObject" )),

				"minimum" => array("BEObject" => array("ObjectType"))		
	);
	
	function beforeSave() {	
		if("off" === $this->data["Ticket"]["status"] && empty($this->data["Ticket"]["closed_date"]) ) {
			$this->data["Ticket"]["closed_date"] = date("Y-m-d H:i:s");
		} else if(!empty($this->data["Ticket"]["closed_date"])){
			$this->data["Ticket"]["closed_date"] = null;
		}
		return true ;
	}
	
}
?>
