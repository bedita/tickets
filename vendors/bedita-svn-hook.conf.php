<?php

// actual configuration read from .conf.php file
$config = array(
    "logFile" => "/home/ste/bedita-svn-hook.log", 
    "beUser" => "bedita",
    "bePasswd" => "bedita",
    "hooks" => array (
        "profexa/" => "http://profexa.bedita.net/tickets/noteHook",
        "slides/" => "http://manage.imaslides.bedita.net/tickets/noteHook",
    )
);

?>