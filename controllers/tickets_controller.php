<?php
/*-----8<--------------------------------------------------------------------
 * 
 * BEdita - a semantic content management framework
 * 
 * Copyright 2010 ChannelWeb Srl, Chialab Srl
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
 * artworks controller class 
 *
 */
class TicketsController extends ModulesController {
	
	public $uses = array();
	var $helpers 	= array('BeTree', 'BeToolbar');
	
	protected $moduleName = 'tickets';
	
	public function index($id = null, $order = "", $dir = true, $page = 1, $dim = 20) {
	}
	
	public function view($id = null) {
	}
	
	public function delete() {
	}
	
	public function deleteSelected() {
	}
	
	public function save() {
	}
	
	public function categories() {
	}
	
	public function saveCategories() {
	}

	public function deleteCategories() {
	}
	
	protected function forward($action, $esito) {
	}
	
}
?>