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
 * tickets controller class
 *
 *
 */
class TicketsController extends ModulesController {

	public $uses = array("Ticket", "User", "Group");
	var $helpers 	= array('BeTree', 'BeToolbar');

	protected $moduleName = 'tickets';

	protected $categorizableModels = array('Ticket');

	protected function beditaBeforeFilter() {
		BeLib::getObject('BeConfigure')->loadPluginLocalConfig($this->moduleName);
		BeLib::getObject('BeConfigure')->loadPluginLocalConfig($this->moduleName, 'module.cfg');
	}

	public function index($id = null, $order = '', $dir = true, $page = 1, $dim = 20) {
		$conf = Configure::getInstance();

		// if BEdita support session filter get current session filter else set it to empty array
		$sessionFilterSupported = (strcmp($conf->majorVersion, '3.3.0') >= 0) ? true : false;
		$currentFilter = ($sessionFilterSupported) ? $this->SessionFilter->read() : array();

		if (!empty($this->params['form']['cleanFilter'])) {
			$this->data = array();
		}

		$filter['object_type_id'] = array($conf->objectTypes['ticket']['id']);
		$filter['user_created'] = '';

		if (!empty($this->data['severity'])) {
			$filter['Ticket.severity'] = $this->data['severity'];
			if ($sessionFilterSupported) {
				$this->SessionFilter->add('Ticket.severity', $this->data['severity']);
			}
		} else {
			$filter['Ticket.severity'] = (!empty($currentFilter['Ticket.severity'])) ? $currentFilter['Ticket.severity'] : '';
		}

		if (!empty($this->data['status'])) {
			$ts = array_keys($this->data['status']);
			$filter['Ticket.ticket_status'] = $ts;
			if ($sessionFilterSupported) {
				$this->SessionFilter->add('Ticket.ticket_status', $ts);
			}
		} elseif (!empty($currentFilter['Ticket.ticket_status'])) {
			$filter['Ticket.ticket_status'] = $currentFilter['Ticket.ticket_status'];
		} else {
			$ticketStatus = array_intersect($conf->ticketStatus, array('draft', 'on'));
			$filter['Ticket.ticket_status'] = array_keys($ticketStatus);
		}

		if (empty($this->data)) {
			$filter['status'] = (!empty($currentFilter['status'])) ? $currentFilter['status'] : array('NOT' => 'off');
		} elseif (!empty($this->data['hide_status_off'])) {
			$filter['status'] = array('NOT' => 'off');
		} else {
			$filter['status'] = array('on', 'draft', 'off');
		}
		if ($sessionFilterSupported) {
			$this->SessionFilter->add('status', $filter['status']);
		}
		$hideStatusOff = (!count(array_diff(array('on', 'draft', 'off'), $filter['status'])))? false : true;

		if (!empty($this->data['assigned_to'])) {
			$filter['ObjectUser.switch'] = 'assigned';
			$filter['ObjectUser.user_id'] = $this->data['assigned_to'];
			if ($sessionFilterSupported) {
				$this->SessionFilter->add('ObjectUser.switch', 'assigned');
				$this->SessionFilter->add('ObjectUser.user_id', $filter['ObjectUser.user_id']);
			}
		} elseif (!empty($currentFilter['ObjectUser.switch'])) {
			$filter['ObjectUser.switch'] = $currentFilter['ObjectUser.switch'];
			$filter['ObjectUser.user_id'] = $currentFilter['user_id'];
		}

		if (!empty($this->data['reporter'])) {
			$filter['BEObject.user_created'] = $this->data['reporter'];
			if ($sessionFilterSupported) {
				$this->SessionFilter->add('BEObject.user_created', $filter['BEObject.user_created']);
			}
		} elseif (!empty($currentFilter['BEObject.user_created'])) {
			$filter['BEObject.user_created'] = $currentFilter['BEObject.user_created'];
		} else {
			$filter['BEObject.user_created'] = '';
		}

		$filter['Ticket.exp_resolution_date'] = '';
		$filter['count_annotation'] = array('EditorNote');

		$f = $filter;
		$this->paginatedList($id, $filter, $order, $dir, $page, $dim);
		$this->loadCategories($filter['object_type_id']);
		$this->loadReporters();
		$this->loadAssignedUsers();

		$f['hide_status_off'] = $hideStatusOff;

		$this->set('filter', $f);
	}

	public function view($id = null) {
		$this->viewObject($this->Ticket, $id);
		if (!empty($id)) {
			$this->viewVars['object']['User'] = Set::combine($this->viewVars['object'], 'User.{n}.id', 'User.{n}', 'User.{n}.ObjectUser.switch');
		}
		$this->set("objectTypeId", Configure::read("objectTypes.ticket.id"));
		$this->filterCommits();
	}

	private function filterCommits() {
	    // filter commits on scmIntegration
	    $scmGroup = Configure::read("scmIntegration.groupVisible");
        if (!empty($scmGroup)) {
            $groups = $this->BeAuth->user["groups"];
	        if (!in_array($scmGroup, $groups)) {
	            $this->set("hideCommits", true);
	        }
        }
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
		$this->saveObject($this->Ticket);
	 	$this->Transaction->commit() ;
 		$this->userInfoMessage(__("Ticket saved", true)." - ".$this->data["title"]);
		$this->eventInfo("ticket [". $this->data["title"]."] saved");
	}

	public function saveStatus() {
		$this->checkWriteModulePermission();

		$ticketStatus = Configure::read('ticketStatus');
		if (!empty($ticketStatus[$this->data['ticket_status']])) {
			$objectUser = ClassRegistry::init('ObjectUser');
			$assigned = $objectUser->find('all', array(
				'conditions' => array(
					'object_id' => $this->data['id'],
					'switch' => array('assigned', 'notify')
				),
				'contain' => array()
			));
			$this->data['users'] = array('assigned' => '', 'notify' => '');
			$users = Set::combine($assigned, '{n}.ObjectUser.id', '{n}.ObjectUser.user_id', '{n}.ObjectUser.switch');
			if (!empty($users['assigned'])) {
				$this->data['users']['assigned'] = implode(',', $users['assigned']);
			}
			if (!empty($users['notify'])) {
				$this->data['users']['notify'] = implode(',', $users['notify']);
			}
			$this->data['status'] = $ticketStatus[$this->data['ticket_status']];

			$ticket = ClassRegistry::init('BEObject')->find('first', array(
				'fields' => array('title', 'description'),
				'conditions' => array('id' => $this->data['id']),
				'contain' => array()
			));
			$this->data['title'] = $ticket['BEObject']['title'];
			$this->data['description'] = $ticket['BEObject']['description'];


			$this->Transaction->begin();
			$this->saveObject($this->Ticket);
		 	$this->Transaction->commit() ;
			$this->eventInfo('status for ticket [' . $this->data['id'] . '] changed');

            $this->ResponseHandler->setType('json');
            $this->set(array(
                'id' => $this->data['id'],
                'ticket_status' => $this->data['ticket_status'],
                '_serialize' => array('id', 'ticket_status')
            ));
        } else {
            $this->log('Unknown status in saveStatus: ' . $this->data['ticket_status'], 'error');
        }
    }

	/**
	 * save editor note
	 * if it fails throw BeditaAjaxException managed like json object
	 */
	public function saveNote() {
		$EditorNote = ClassRegistry::init("EditorNote");
		$EditorNote->Behaviors->detach("Notify");
		$EditorNote->Behaviors->attach("TicketNotifier");
		$this->requestAction(array(
				"controller" => "pages",
				"action" => "saveNote"
			), array("data" => $this->data)
		);
	}

    /**
    * delete ticket thread note
     * if it fails throw BeditaAjaxException managed like json object
     */
    public function deleteNote() {
        $EditorNote = ClassRegistry::init('EditorNote');
        $EditorNote->Behaviors->detach('Notify');
        $EditorNote->Behaviors->attach('TicketNotifier');
        $this->requestAction(array(
            'controller' => 'pages',
            'action' => 'deleteNote'
            ),  array('form' => $this->params['form'])
        );
    }
	
	/**
     * Add notes via scripts/hooks - e.g. svn/git commits for ticket
     */
	public function noteHook() {
        $res = '{"ok": "true"}';
	    $this->BeAuth->logout();
        // do some stuff...
        if (empty($this->params['form']['commit_data'])) {
            $res = '{"ok": "false", "errorMessage" : "missing commit_data"}';
        } else {
            $commitData = $this->params['form']['commit_data'];
            $repo = $this->params['form']['repo'];
            $this->Ticket->saveScmData($commitData, $repo);
        }
        echo $res;
        exit;
	}

	protected function beforeCheckLogin() {
        if ($this->action === "noteHook") {
            if(!empty($this->params['form']['userid']) && 
                !empty($this->params['form']['passwd'])) {
                $userid = $this->params['form']['userid'];
                $password = $this->params['form']['passwd'];
                if(!$this->BeAuth->login($userid, $password)) {
                    $this->eventError("Hook login error");
                    $this->log("Hook login error: " . $userid . ":" . $password);
                }
            }
        }
	}
	
	/**
	 * load an editor note
	 */
	public function loadNote() {
		$this->layout = "ajax";
		$editorNoteModel = ClassRegistry::init("EditorNote");
		$this->set("note", $editorNoteModel->find("first", array(
			"conditions" => array("EditorNote.id" => $this->params["form"]["id"]))
		));
		$this->render('/elements/single_note');
	}

	public function categories() {
		$this->showCategories($this->Ticket);
	}


	public function board() {
		$this->helpers[] = 'Gravatar';
		$this->loadCategories(Configure::read('objectTypes.ticket.id'));

		if (!empty($this->params['named']['show'])) {
			if ($this->params['named']['show'] == 'all') {
				$this->SessionFilter->add('status', array('on', 'draft', 'off'));
			} else {
				$this->SessionFilter->add('status', array('on', 'draft'));
			}
		}

		if (!empty($this->params['named']['toggleCategory'])) {
			$boardCategoriesFilter = $this->SessionFilter->read('boardCategories');
			if (empty($boardCategoriesFilter)) {
				$boardCategoriesFilter = array($this->params['named']['toggleCategory']);
			} elseif (in_array($this->params['named']['toggleCategory'], $boardCategoriesFilter)) {
				$boardCategoriesFilter = array_diff($boardCategoriesFilter, array($this->params['named']['toggleCategory']));
			} else {
				$boardCategoriesFilter[] = $this->params['named']['toggleCategory'];
			}

			if (empty($boardCategoriesFilter)) {
				$this->SessionFilter->delete('boardCategories');
			} else {
				$this->SessionFilter->add('boardCategories', $boardCategoriesFilter);
			}
		}

		$objectsByStatus = array();
		$showOffColumns = array();
		$ticketBoardOptions = Configure::read('ticketBoard');
		$ticketStatus = Configure::read('ticketStatus');
		foreach ($ticketBoardOptions as $boardColumn => $options) {
			$arr = array_intersect_key($ticketStatus, $options['ticketStatus']);
			if (in_array('off', $arr)) {
				$showOffColumns[] = $boardColumn;
			}

			// load each column
			foreach (array_keys($options['ticketStatus']) as $ts) {
				$this->loadBoardColumn($boardColumn, $ts);



				foreach ($this->viewVars['objects'] as $o) {
					$objectsByStatus[$boardColumn][$o['ticket_status']][] = $o;
				}
			}
		}

		$this->set('showOffColumns', $showOffColumns);
		$this->set('objectsByStatus', $objectsByStatus);
	}


	public function loadBoardColumn($boardColumn, $ticketStatus) {
		if ($this->RequestHandler->isAjax()) {
			$this->layout = 'ajax';
			$this->SessionFilter->setup('Tickets.board');	
		}
		$boardColumnOptions = Configure::read('ticketBoard.' . $boardColumn);
		$id = null;
		$order = $boardColumnOptions['orderBy'];
		$dir = 1;
		$page = 1;
		$dim = $boardColumnOptions['ticketStatus'][$ticketStatus];
		$filter['object_type_id'] = array(Configure::read('objectTypes.ticket.id'));
		$filter['Ticket.ticket_status'] = $ticketStatus;
		$filter['user_created'] = '';
		$filter['Ticket.*'] = ''; 
		$filter['count_annotation'] = array('EditorNote');

		$currentFilter = $this->SessionFilter->read();
		$filter['status'] = empty($currentFilter['status']) ? array('on', 'draft') : $currentFilter['status'];

		if (!empty($currentFilter['boardCategories'])) {
			$filter['joins'] = array(
				array(
					'table' => 'object_categories',
					'alias' => 'ObjectCategory',
					'type' => 'INNER',
					'conditions' => array(
						'BEObject.id = ObjectCategory.object_id',
						'ObjectCategory.category_id' => $currentFilter['boardCategories']
					)
				)
			);
		}

		$this->paginatedList($id, $filter, $order, $dir, $page, $dim);

		$category = ClassRegistry::init('Category');
		$category->Behaviors->disable('CompactResult');
		foreach ($this->viewVars['objects'] as &$o) {
			$o['categories'] = ClassRegistry::init('Category')->find('list', array(
				'fields' => array('id', 'label'),
				'joins' => array(
					array(
						'table' => 'object_categories',
						'alias' => 'ObjectCategory',
						'type' => 'INNER',
						'conditions' => array(
							'Category.id = ObjectCategory.category_id',
							'ObjectCategory.object_id' => $o['id']
						)
					)
				)
			));
		}
		$category->Behaviors->enable('CompactResult');
		$this->loadAssignedUsers();
	}


	public function showUsers($id = null) {
        $groups = Configure::read('ticketAssignGroups') ?: $this->Group->getList(array('backend_auth' => 1));
        $userIds = ClassRegistry::init('GroupsUser')->find('all', array(
            'fields' => array('GroupsUser.user_id'),
            'contain' => array(),
            'joins' => array(
                array(
                    'table' => 'groups',
                    'type' => 'INNER',
                    'conditions' => array('groups.id = GroupsUser.group_id', 'groups.name' => $groups),
                ),
            ),
        ));
        $users = $this->User->find('all', array(
            'contain' => array(),
            'conditions' => array(
                'User.id' => Set::classicExtract($userIds, '{n}.GroupsUser.user_id'),
            ),
        ));

		$usersList = array();
		$switch = (!empty($this->params["named"]["relation"]))? $this->params["named"]["relation"] : "assigned";
		if (!empty($id)) {
			$objectUserModel = ClassRegistry::init("ObjectUser");
			$usersList = $objectUserModel->find("list", array(
						"conditions" => array("object_id" => $id, "switch" => $switch),
						"fields" => array("ObjectUser.user_id"),
					)
			);
		// for new object set session user as notified
		} elseif ($switch == 'notify') {
			$userSession = $this->BeAuth->getUSerSession();
			$usersList = array($userSession['id']);
		}

        foreach ($users as &$user) {
            if (in_array($user['User']['id'], $usersList)) {
                $user['User']['related'] = true;
            }
        }
        unset($user);

		$this->set(compact('users', 'switch'));
		$this->layout = null;
	}

	public function closeAs() {
		$this->layout = 'ajax';
		$status = Configure::read('ticketStatus');
		$closeStatus = array();
		foreach ($status as $label => $statusValue) {
			if ($statusValue == "off") {
				$closeStatus[] = $label;
			}
		}
		$this->set('closeStatus', $closeStatus);
	}

	/**
	 * load all users with at least one ticket assigned and
	 * load users assigned foreach ticket
	 */
	protected function loadAssignedUsers() {
		$objectUser = ClassRegistry::init("ObjectUser");

		// load all users with a ticket assigned
		$all_users_id = $objectUser->find("list", array(
			"fields" => "user_id",
			"conditions" => array("switch" => "assigned"),
            'group' => 'user_id',
		));
		$all_users = array();
		if(!empty($all_users_id)) {
			$all_users = ClassRegistry::init("User")->find("all", array(
				"conditions" => array("User.id" => $all_users_id),
                'order' => array('User.userid'),
				"recursive" => -1
			));
		}
		$this->set("assignedUsers", $all_users);

		// load specific tickets assignment
		if (!empty($this->viewVars["objects"])) {
			foreach ($this->viewVars["objects"] as &$object) {
				$users_id = $objectUser->find("list", array(
					"fields" => "user_id",
					"conditions" => array(
						"switch" => "assigned",
						"object_id" => $object["id"]
					),
                    'group' => 'user_id',
				));

				$users = array();
				if(!empty($users_id)) {
					$users = ClassRegistry::init("User")->find("all", array(
						"conditions" => array("User.id" => $users_id),
                        'order' => array('User.userid'),
						"recursive" => -1
					));
				}

				$object["UsersAssigned"] = Set::classicExtract($users, '{n}.User');
			}
		}
	}

	/**
	 * load all reporters
	 */
	protected function loadReporters() {
		$users_id = ClassRegistry::init("BEObject")->find('list', array(
			'fields' => 'user_created',
			'conditions' => array("object_type_id" => Configure::read('objectTypes.ticket.id')),
            'group' => 'user_created',
		));
		$users_id = array_unique($users_id);
		$reporters = array();
		if(!empty($users_id)) {
			$reporters = ClassRegistry::init("User")->find("all", array(
				"conditions" => array('id' => $users_id),
                'order' => array('User.userid'),
				'recursive' => -1
			));
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
			"deleteCategories" 	=> array(
							"OK"	=> "/tickets/categories",
							"ERROR"	=> "/tickets/categories"
							),
            'bulkCategories' => array(
                'OK' => '/tickets/categories',
                'ERROR' => '/tickets/categories',
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