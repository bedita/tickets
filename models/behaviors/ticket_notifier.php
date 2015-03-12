<?php
/*-----8<--------------------------------------------------------------------
 *
 * BEdita - a semantic content management framework
 *
 * Copyright 2009 ChannelWeb Srl, Chialab Srl
 *
 * This file is part of BEdita: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * BEdita is distributed WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * version 3 along with BEdita (see LICENSE.LGPL).
 * If not, see <http://gnu.org/licenses/lgpl-3.0.html>.
 *
 *------------------------------------------------------------------->8-----
 */

App::import('Behavior', 'Notify');

/**
 * Behavior class that override NotifyBehavior to send email notification to users.
 * Currenly handles this scenarios:
 * 	- new, changes on tickets
 *  - note on tickets
 * Notifications events are triggered accordingo to user preferences
 * (on comments/notes and objects created)
 */
class TicketNotifierBehavior extends NotifyBehavior {

	protected $ticketParams = array(
		"assignedUsers" => array(),
		"prevAssignedUsers" => array(),
		"notifyUsers" => array(),
		"prevNotifyUsers" => array(),
		"prevNumRev" => 0
	);

	function setup(&$model, $settings=array()) {
		parent::setup($model, $settings);
	}

	public function resetTicketParams() {
		$this->ticketParams = array(
			"assignedUsers" => array(),
			"prevAssignedUsers" => array(),
			"notifyUsers" => array(),
			"prevNotifyUsers" => array(),
			"prevNumRev" => 0
		);
	}

	public function beforeSave($model, $options) {
		if ($model->name == "Ticket") {
			$this->resetTicketParams();
			$data = &$model->data[$model->alias];
			if (!empty($data['id'])) {
				$versionModel = ClassRegistry::init("Version");
				$this->ticketParams["numRev"] = $versionModel->numRevisions($data['id']);
			}
		}
	}

	function afterSave($model, $created) {

		$data =& $model->data[$model->alias];
		$users = array();
		$creator = array();
		$userModel = ClassRegistry::init("User");
		if ($model->name == "EditorNote") {
			$note = ClassRegistry::init($model->name)->find("first", array(
					"conditions" => array(
						"ReferenceObject.id" => $data["object_id"]
					),
					"contain" => array("ReferenceObject")
				)
			);
			$usersIds = ClassRegistry::init("ObjectUser")->find('list', array(
				"conditions" => array(
					"object_id" => $data["object_id"],
					"switch" => array("assigned", "notify"),
					"user_id <> " . $data["user_modified"] // don't send mail to editor itself
				),
				"fields" => "user_id"
			));
			$users = $userModel->find("all", array(
				"conditions" => array("id" => $usersIds),
				"contain" => array()
			));
			if (empty($data['author'])) {
				$data['author'] = $userModel->field("userid",
					array("id" => $data["user_modified"]));
			}
			$data['object_title'] = $note["ReferenceObject"]["title"];
			$this->prepareAnnotationMail($model, $users);
		} elseif ($model->name == "Ticket" && class_exists('CakeSession')) {
			$data['author'] = $userModel->field("userid",array("id" => $data["user_modified"]));
			// remove and create obj/user assignement/notification
			$objectUserModel = ClassRegistry::init("ObjectUser");
			$sessionUser = CakeSession::read("BEAuthUser");
			foreach ($data["users"] as $switch => $usersList) {
				$this->ticketParams["prev" . ucfirst($switch) . "Users"] = $objectUserModel->find('list', array(
						"conditions" => array(
							"object_id" => $data["id"],
							"switch" => $switch,
							"user_id <> " . $sessionUser["id"] // don't send mail to editor itself
						),
						"fields" => "user_id"
					));
				$objectUserModel->deleteAll(array(
					"object_id" => $data["id"],
					"switch" => $switch
				));
				if(!empty($usersList)) {
					$usersListArr = explode(",", $usersList);
					foreach($usersListArr as $user_id) {
						$objectUserModel->create();
						$objectUserModel->save(array(
							"user_id"=>trim($user_id),
							"object_id" => $data["id"],
							"switch" => $switch
						));
						// don't send mail to editor itself
						if ($user_id != $sessionUser["id"]) {
							$this->ticketParams[$switch . "Users"][] = $user_id;
						}
					}
				}
			}
			$this->prepareTicketMail($model);
		}
	}

	/**
	 * prepare mail notification for tickets and create the related mail job
	 * @param  Ticket $model        Ticket Model
	 * @param  array  $notifyParams params to override self::ticketParams
	 *                              It can contain:
	 *                              "assignedUsers" => array(),
	 *								"prevAssignedUsers" => array(),
	 *								"notifyUsers" => array(),
	 *								"prevNotifyUsers" => array(),
	 *								"prevNumRev" => int
	 * @return void
	 */
	public function prepareTicketMail($model, array &$notifyParams = array()) {
		$notifyParams = array_merge($this->ticketParams, $notifyParams);
		extract($notifyParams);
		$this->loadMessages();
		$data =& $model->data[$model->alias];
		$data["url_id"] = $data["id"];
		$params = array(
			"author" => $data["author"],
			"title" => $data["title"],
			"id" => $data["id"],
			"url" => $this->getContentUrl($data),
			"text" => strip_tags($data["description"]),
			"beditaUrl" => Configure::read("beditaUrl"),
		);
		$userModel = ClassRegistry::init("User");
		// verify new assignements, and removed assignement
		$newAssigned = array_diff($assignedUsers, $prevAssignedUsers);
		if(!empty($newAssigned)) {
			$users = $userModel->find("all", array(
				"conditions" => array("id" => $newAssigned),
				"contain" => array()
			));
			$this->createMailJob($users, "ticketNewAssignementMsg", $params);
		}
		$unAssigned = array_diff($prevAssignedUsers, $assignedUsers);
		if(!empty($unAssigned)) {
			$users = $userModel->find("all", array(
				"conditions" => array("id" => $unAssigned),
				"contain" => array()
			));
			$this->createMailJob($users, "ticketUnassignementMsg", $params);
		}

		// verify new notify, and removed notify
		$newNotify = array_diff($notifyUsers, $prevNotifyUsers);
		if(!empty($newNotify)) {
			$users = $userModel->find("all", array(
				"conditions" => array("id" => $newNotify),
				"contain" => array()
			));
			$this->createMailJob($users, "ticketAddNotifyMsg", $params);
		}
		$removeNotify = array_diff($prevNotifyUsers, $notifyUsers);
		if(!empty($removeNotify)) {
			$users = $userModel->find("all", array(
				"conditions" => array("id" => $removeNotify),
				"contain" => array()
			));
			$this->createMailJob($users, "ticketRemoveNotifyMsg", $params);
		}

		// notify other changes to already assigned users
		$assignedUsersToNotifyChanges = array_intersect($assignedUsers, $prevAssignedUsers);
		$notifyUsersToNotifyChanges = array_intersect($notifyUsers, $prevNotifyUsers);
		$changeNotifyUsers = array_unique(array_merge($assignedUsersToNotifyChanges, $notifyUsersToNotifyChanges));

		if(!empty($changeNotifyUsers)) {
			$versionModel = ClassRegistry::init("Version");
			$numRev = $versionModel->numRevisions($data["id"]);
			if($numRev > $prevNumRev) {
				$diff = $versionModel->field("diff", array("revision" => $numRev, "object_id" => $data["id"]));
				$diff = unserialize($diff);
				$msg = "";
				// see if an interesting field has changed
				$checkFields = array("description", "ticket_status", "severity");
				foreach ($checkFields as $chk) {
					if(!empty($diff[$chk])) {
						if($chk == "description") {
							$msg .= "'description' changed \n";
						} else {
							$msg .= "'$chk' changed to '" . $data[$chk] . "' \n";
						}
					}
				}
				if(!empty($msg)) {
					$params["changedFields"] = $msg;
					$users = $userModel->find("all", array(
						"conditions" => array("id" => $changeNotifyUsers),
						"contain" => array()
					));
					$this->createMailJob($users, "ticketModifiedMsg", $params);
				}
			}
		}

	}

	protected function loadMessages() {
		// merge default, backend local and frontend messages if present
		$notify = array();
		require(BEDITA_CORE_PATH.DS."config".DS."notify".DS."default.msg.php");

		if (file_exists(BEDITA_CORE_PATH.DS."config".DS."notify".DS."local.msg.php")) {
			require(BEDITA_CORE_PATH.DS."config".DS."notify".DS."local.msg.php");
		}

		require(BEDITA_MODULES_PATH.DS."tickets".DS."config".DS."notify".DS."tickets.msg.php");

		if (file_exists(BEDITA_MODULES_PATH.DS."tickets".DS."config".DS."notify".DS."tickets.local.msg.php")) {
			require(BEDITA_MODULES_PATH.DS."tickets".DS."config".DS."notify".DS."tickets.local.msg.php");
		}

		if (!BACKEND_APP && file_exists(APP . "config" . DS . "notify" . DS . "frontend.msg.php")) {
			require(APP . "config" . DS . "notify" . DS . "frontend.msg.php");
		}
		$this->notifyMsg = &$notify;
	}

}

?>