<?php

// actual configuration read from .conf.php file
$config = array(
    // log file, absolute path
    "logFile" => "/usr/local/src/bedita-svn/bedita-svn-hook.log", 
    // svn repo path on filesystem
    "/path/to/rep" => array(
        "beUser" => "bedita",  // bedita user with permissions on ticke module
        "bePasswd" => "bedita", // passwd for bedita user
        "hooks" => array (
            // commits in "example" folder will be sent to these url
            // add /tickets/noteHook for bedita backend instance
            "example/" => "http://bedita.example.com/tickets/noteHook",
        )
    )
);

?>
