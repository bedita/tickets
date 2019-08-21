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
 * Tickets ticket object
 *
 */
class Ticket extends BEAppObjectModel {

	public $searchFields = array("title" => 8 , "description" => 4,
		"ticket_status" => 6, "severity" => 6);

	public $objectTypesGroups = array("related");

	public $actsAs = array(
		'CompactResult' => array('ReferenceObject'),
		'TicketNotifier'
	);

	protected $modelBindings = array(
			"detailed" =>  array("BEObject" => array("ObjectType",
														"UserCreated",
														"UserModified",
														"Permission",
			                                            "ObjectProperty",
														"RelatedObject",
														"Annotation",
														"Category",
														"User",
														"Version" => array("User.realname", "User.userid")
														)),
			"default" => array("BEObject" => array("ObjectProperty",
								"ObjectType", "Annotation",
								"Category", "RelatedObject","User" )),

			"minimum" => array("BEObject" => array("ObjectType"))
	);

	function beforeValidate() {
        $this->checkDate('exp_resolution_date');
	}

	function beforeSave() {
		if("off" === $this->data["Ticket"]["status"] && empty($this->data["Ticket"]["closed_date"]) ) {
			$this->data["Ticket"]["closed_date"] = date("Y-m-d H:i:s");
		} else if(!empty($this->data["Ticket"]["closed_date"])){
			$this->data["Ticket"]["closed_date"] = null;
		}
		return true ;
	}
	
    /**
     * Create a ticket note from SCM integration
     * @param array $data
    */
    public function saveScmData($commitData, $repoName) {
        $repoName = trim($repoName, '/');
        $slashPos = strrpos($repoName, "/");
        if ($slashPos !== false) {
            $repoName = substr($repoName, $slashPos+1);
        }
        $lines = explode("###", $commitData);
        foreach ($lines as $l) {
            if (!empty($l)) {
                $this->saveCommitData($l, $repoName);
            }
        }
    }

    private function saveCommitData($ciData, $repoName) {
        $userModel = ClassRegistry::init("User");
        $commitNoteModel = ClassRegistry::init("TicketCommitNote");
        
        $this->log("Commit data: " . $ciData, LOG_DEBUG);
        $items = explode("|", $ciData);
        $user = $items[0];
        $this->log("Commit user: " . $user, LOG_DEBUG);
        $this->log("Repo name: " . $repoName, LOG_DEBUG);
        $beditaUser = Configure::read("scmIntegration." . $repoName . ".users. " . $user);
        $this->log("Commit beditauser: " . $beditaUser, LOG_DEBUG);
        if (!empty($beditaUser)) {
            $userId = $userModel->field("id", array("userid" => $beditaUser));
            $commit = $items[1];
            $commitUrl = Configure::read("scmIntegration.". $repoName . ".commitUrl");
            $commitUrl = str_replace("#REV", $commit, $commitUrl);
            $this->log("Commit url: " . $commitUrl, LOG_DEBUG);
            $msg = $items[2];
            $matches = array();
            preg_match_all("/\s*\#([0-9]+)/i", $msg, $matches);
            $ticketIds = $matches[1];
            if (!empty($ticketIds)) {
                foreach ($ticketIds as $objectId) {
                    $data = array(
                            "status" => "on",
                            "object_id" => $objectId,
                            "description" => 'Commit: "' . strip_tags($msg) .
                            '"<br/><a href="' . $commitUrl . '" target="_blank" >' . $commitUrl . "</a>",
                            "author" => "scmIntegration",
                            "user_created" => $userId,
                            "user_modified" => $userId,
                    );
                    $commitNoteModel->create();
                    $commitNoteModel->Behaviors->detach("Notify");
                    if (!$commitNoteModel->save($data)) {
                        throw new BeditaException(__("Error saving ticket note", true),
                                $commitNoteModel->validationErrors);
                    }
                    $this->log("Note saved: " . print_r($data, true), LOG_DEBUG);
                }
            }
        }
    }

}
?>
