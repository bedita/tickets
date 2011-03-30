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
 * tickets controller class 
 * 
 *
 */
class TicketsController extends ModulesController {
	
	public $uses = array("Ticket", "User", "Group");
	var $helpers 	= array('BeTree', 'BeToolbar');
	
	protected $moduleName = 'tickets';

	protected function beditaBeforeFilter() {
		BeLib::getObject('BeConfigure')->loadPluginLocalConfig($this->moduleName);
	}
	
	public function index($id = null, $order = "", $dir = true, $page = 1, $dim = 20) {
		$conf  = Configure::getInstance() ;
		$filter["object_type_id"] = array($conf->objectTypes['ticket']["id"]);
		$filter["user_created"] = "";
		$filter["Ticket.severity"] =  (!empty($this->data['severity'])) ? $this->data['severity'] : "";
		if(!empty($this->data['status'])) {
			$filter["Ticket.ticket_status"] = array_keys($this->data['status']);
		} else {
			$filter["Ticket.ticket_status"] = "";
		}
		if(!empty($this->data['hide_status_off'])) {
			$filter["status"] = "<> 'off'";
		}
		//$filter["object_user"] = "assigned";
		$filter["exp_resolution_date"] = "";
		$filter["BEObject.user_created"] = (!empty($this->data['reporter'])) ? $this->data['reporter'] : "";
		$filter["count_annotation"] = array("EditorNote");
		$f = $filter;
		$this->paginatedList($id, $filter, $order, $dir, $page, $dim);
		$this->loadCategories($filter["object_type_id"]);
		$this->loadReporters();
		if(!empty($this->data['status'])) $f["f_status"] = $this->data['status'];
		if(!empty($this->data['reporter'])) $f["f_reporter"] = $this->data['reporter'];
		if(!empty($this->data['severity'])) $f["f_severity"] = $this->data['severity'];
		if(!empty($this->data['hide_status_off'])) $f["hide_status_off"] = "true";
		$this->set("filter",$f);
	}

	public function view($id = null) {
		$this->viewObject($this->Ticket, $id);
		$this->set("objectTypeId", Configure::read("objectTypes.ticket.id"));
	}
	
	public function delete() {
		$this->checkWriteModulePermission();
		$objectsListDeleted = $this->deleteObjects("Ticket");
		$this->userInfoMessage(__("Ticket deleted", true) . " -  " . $objectsListDeleted);
		$this->eventInfo("ticket $objectsListDeleted deleted");
	}
	
	public function deleteSelected() {
		$this->checkWriteModulePermission();
		$objectsListDeleted = $this->deleteObjects("Ticket");
		$this->userInfoMessage(__("Ticket", true) . " -  " . $objectsListDeleted);
		$this->eventInfo("Ticket $objectsListDeleted deleted");
	}
	
	public function save() {
		$this->checkWriteModulePermission();
		$this->Transaction->begin();

		$numRev = 0;
		if(!empty($this->data['id'])) {
			$versionModel = ClassRegistry::init("Version");
			$numRev = $versionModel->numRevisions($this->data['id']);
		}
		$this->saveObject($this->Ticket);

		// remove and create obj/user assignement
		$objectUserModel = ClassRegistry::init("ObjectUser");
		$prevUsers = $objectUserModel->findAll(array("object_id" => $this->Ticket->id, 
			"switch" => "assigned"));
		$objectUserModel->deleteAll(array("object_id" => $this->Ticket->id, 
			"switch" => "assigned"));
		$users = array();
		if(!empty($this->data["users"])) {
			$users = explode(",",$this->data["users"]);
			foreach($users as $user_id) {
				$objectUserModel->create();
				$objectUserModel->save(array("user_id"=>trim($user_id), 
					"object_id" => $this->Ticket->id, "switch" => "assigned"));
			}
		}
		// notify users
		$prev = array();
		foreach($prevUsers as $u) {
			$prev[] = $u["ObjectUser"]["user_id"];
		}
		$this->notify($users, $prev, $numRev);
	 	$this->Transaction->commit() ;
 		$this->userInfoMessage(__("Ticket saved", true)." - ".$this->data["title"]);
		$this->eventInfo("ticket [". $this->data["title"]."] saved");
	}

	protected function notify(array& $assignedUsers, array& $prevUsers, $prevNumRev) {
		
		$auth = $this->BeAuth->user["userid"];
		$authId = $this->BeAuth->user["id"];
		$ticketId = $this->Ticket->id;
		$params = array("author" => $auth,
			"title" => $this->data["title"],
			"id" => $ticketId,
			"url" => Configure::read("beditaUrl") . "/view/" . $ticketId,
			"text" => $this->data["description"],
			"beditaUrl" => Configure::read("beditaUrl"),
		);
		// verify new assignements, and removed assignement
		$newAssigned = array_diff($assignedUsers, $prevUsers);
		$k = array_search($authId, $newAssigned);
		if($k !== false) {
			array_splice($newAssigned, $k, 1);
		}
		if(!empty($newAssigned)) {
			$this->createMailJob($newAssigned, "ticketNewAssignementMsg", $params);
		}
		$unAssigned = array_diff($prevUsers, $assignedUsers);
		$k = array_search($authId, $unAssigned);
		if($k !== false) {
			array_splice($unAssigned, $k, 1);
		}
		if(!empty($unAssigned)) {
			$this->createMailJob($unAssigned, "ticketUnassignementMsg", $params);
		}
		// notify other changes to already assigned users
		$changeNotifyUsers = array_intersect($assignedUsers, $prevUsers);
		$k = array_search($authId, $changeNotifyUsers);
		if($k !== false) {
			array_splice($changeNotifyUsers, $k, 1);
		}
		// add reporter if missing and not $authId
		$creatorId = ClassRegistry::init("BEObject")->field("user_created", array("id" => $ticketId));
		$k = array_search($creatorId, $changeNotifyUsers);
		if($k === false && $creatorId != $authId) {
			$changeNotifyUsers[] = $creatorId;
		}
		if(!empty($changeNotifyUsers)) {
			$versionModel = ClassRegistry::init("Version");
			$numRev = $versionModel->numRevisions($ticketId);
			if($numRev > $prevNumRev) {
				$diff = $versionModel->field("diff", array("revision" => $numRev, "object_id" => $ticketId));
				$diff = unserialize($diff);
				$msg = "";
				// see if an interesting field has changed
				$checkFields = array("description", "ticket_status", "severity");
				foreach ($checkFields as $chk) {
					if(!empty($diff[$chk])) {
						if($chk == "description") {
							$msg .= "'description' changed \n";
						} else {
							$msg .= "'$chk' changed to '" . $this->data[$chk] . "' \n";
						}
					}
				}
				if(!empty($msg)) {
					$params["changedFields"] = $msg;
					$this->createMailJob($changeNotifyUsers, "ticketModifiedMsg", $params);
				}
			}
		}
		
	}

	protected function createMailJob(array &$users, $msgType, array &$params) {
		$jobModel = ClassRegistry::init("MailJob");
		$jobModel->containLevel("default");
		$data = array();
		$data["status"] = "unsent";

		$conf = Configure::getInstance();
		foreach ($users as $usrId) {
			
			$u = $this->User->findById($usrId);
			$data["recipient"] = $u['User']['email'];
			$params["user"] = $u['User']['userid'];
			
			$subject = $this->getNotifyText($msgType, "subject", $params);
			$data["mail_params"] = serialize(array("reply_to" => $conf->mailOptions["reply_to"], 
						"sender" => $conf->mailOptions["sender"], 
						"subject" => $subject,
						"signature" => $conf->mailOptions["signature"]
			));
			
			$data["mail_body"] = $this->getNotifyText($msgType, "mail_body", $params);			
			// skip creation if a duplicate mail is already present
			$res = $jobModel->find("all", array(
				"conditions" => array("recipient" => $data["recipient"], "status" => $data["status"], 
				"mail_body" => $data["mail_body"])));
			if(!empty($res)) {
				$this->log("duplicate job for " . $data["recipient"], LOG_DEBUG);
			} else {
				$jobModel->create();
				if (!$jobModel->save($data)) {
					throw new BeditaException(__("Error creating mail jobs"),true);
				}
			}
		}
		
	}
	
	protected function getNotifyText($msgType, $field, array &$params) {
		$t = Configure::read($msgType);
		if(!empty($t) && !empty($t[$field])) {
			$text = $t[$field];
			$replaceFields = array("user", "id", "author", "title", "text", "url", "beditaUrl", "changedFields");
			foreach ($replaceFields as $f) {
				if(!empty($params[$f])) {
					$plHolder = "[\$" . $f . "]";
					$text = str_replace($plHolder , $params[$f], $text);
				}
			}
		}
		return $text;		
	}
	
	
	
	public function categories() {
		$this->showCategories($this->Ticket);
	}
	
	public function saveCategories() {
		$this->checkWriteModulePermission();
		if(empty($this->data["label"])) 
			throw new BeditaException( __("No data", true));
		$this->Transaction->begin() ;
		if(!ClassRegistry::init("Category")->save($this->data)) {
			throw new BeditaException(__("Error saving tag", true), $this->Category->validationErrors);
		}
		$this->Transaction->commit();
		$this->userInfoMessage(__("Category saved", true)." - ".$this->data["label"]);
		$this->eventInfo("category [" .$this->data["label"] . "] saved");
	}

	public function showUsers($id = null) {

		$groups = Configure::read("ticketAssignGroups");
		if (empty($groups)) {
			$groups = $this->Group->getList(array("backend_auth" => 1));
		}
		$users = $this->User->find("all", array(
				"contain" => array(
					"Group" => array(
						"conditions" => array("name" => $groups)
						)
					)
				)
			);

		$assigned = array();	
		if(!empty($id)) {
			$objectUserModel = ClassRegistry::init("ObjectUser");
			$result = $objectUserModel->find("all", array(
						"conditions" => array("object_id" => $id, "switch" => "assigned"),
						"fields" => "user_id",
					)
			);
			foreach ($result as $r) {
				$assigned[] = $r["ObjectUser"]["user_id"];
			}
			
		}
			
		foreach($users as $k=>$u) {
			if(empty($u["Group"])) {
				unset($users[$k]);
			} else {
				if(in_array($u["User"]["id"], $assigned)) {
					$users[$k]["User"]["assigned"] = true;
				}
			}
		}

		$this->set('users', $users);
		$this->layout = null;
	}

	public function deleteCategories() {
		$this->checkWriteModulePermission();
		if(empty($this->data["id"])) 
			throw new BeditaException( __("No data", true));
		$this->Transaction->begin() ;
		if(!ClassRegistry::init("Category")->del($this->data["id"])) {
			throw new BeditaException(__("Error saving tag", true), $this->Category->validationErrors);
		}
		$this->Transaction->commit();
		$this->userInfoMessage(__("Category deleted", true) . " -  " . $this->data["label"]);
		$this->eventInfo("Category " . $this->data["id"] . "-" . $this->data["label"] . " deleted");
	}

	private function loadReporters() {
		$reporters = array();
		$data = $this->viewVars["objects"];
		foreach($data as $k => $v) {
			$reporters[$v['user_created']] = $v['userid'];
		}
		$this->set("reporters",$reporters);
	}

	protected function forward($action, $esito) {
		$REDIRECT = array(
			"cloneObject"	=> 	array(
							"OK"	=> "/tickets/view/".@$this->Ticket->id,
							"ERROR"	=> "/tickets/view/".@$this->Ticket->id 
							),
			"view"	=> 	array(
							"ERROR"	=> "/tickets" 
							), 
			"save"	=> 	array(
							"OK"	=> "/tickets/view/".@$this->Ticket->id,
							"ERROR"	=> $this->referer()
							),
			"saveCategories" 	=> array(
							"OK"	=> "/tickets/categories",
							"ERROR"	=> "/tickets/categories"
							),
			"deleteCategories" 	=> array(
							"OK"	=> "/tickets/categories",
							"ERROR"	=> "/tickets/categories"
							),
			"delete" =>	array(
							"OK"	=> $this->fullBaseUrl . $this->Session->read('backFromView'),
							"ERROR"	=> $this->referer()
							),
			"deleteSelected" =>	array(
							"OK"	=> $this->referer(),
							"ERROR"	=> $this->referer() 
							),
			"addItemsToAreaSection"	=> 	array(
							"OK"	=> $this->referer(),
							"ERROR"	=> $this->referer() 
							),
			"changeStatusObjects"	=> 	array(
							"OK"	=> $this->referer(),
							"ERROR"	=> $this->referer() 
							)
		);
		if(isset($REDIRECT[$action][$esito])) return $REDIRECT[$action][$esito] ;
		return false ;
	}
	
}
?>