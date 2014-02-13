<?php

// actual configuration read from .conf.php file
$config = array(
    "logFile" => "./bedita-svn-hook.log", 
    "<repo-path>" => array(
        "beUser" => "bedita", 
        "bePasswd" => "bedita",
        "hooks" => array(
            "svn-base-folder" => "bedita-hook-url"
        )
    )
);

//
// DO NOT CHANGE ANYTHING AFTER THIS LINE
//

// load eventum-svn-hook.conf.php from dir of this script if it exists
$configfile = dirname(__FILE__) . DIRECTORY_SEPARATOR . basename(__FILE__, '.php') . '.conf.php';
if (file_exists($configfile)) {
    require_once $configfile;
}

$h = fopen($config["logFile"], 'a');

// save name of this script
$PROGRAM = basename(array_shift($argv));

fprintf($h, "$PROGRAM: started " .  date("Y-m-d H:i:s") . "\n");

if (!isset($svnlook)) {
    $svnlook = '/usr/bin/svnlook';
}

if (!is_executable($svnlook)) {
    fprintf ($h, "$PROGRAM: svnlook is not executable, edit \$svnlook\n");
    exit(1);
}

if ($argc < 3) {
    fprintf ($h, "$PROGRAM: Missing arguments, got ".($argc - 1).", expected 2\n");
    exit(1);
}

$repos = $argv[0];
$new_revision = $argv[1];
$old_revision = $new_revision - 1;

fprintf($h, "$PROGRAM: revision " . $new_revision . " repo " . $repos . "\n");

$scm_module = rawurlencode(basename($repos));

exec($svnlook . ' info ' . $repos . ' -r ' . $new_revision, $results);
$username = array_shift($results);
$date = array_shift($results);
// ignore file length
array_shift($results);

// get the full commit message
$commit_msg = join("\n", $results);
// remove | from message
$commit_msg = str_replace("|", "", $commit_msg);

// now parse the list of modified files
$hookUrls = array();
$hooks = array();
exec($svnlook . ' changed ' . $repos . ' -r ' . $new_revision, $files);
foreach ($files as $file_info) {
    $pieces = explode('   ', $file_info);
    $filename = $pieces[1];
    fprintf ($h,  $filename . "\n");
    foreach ($config[$repos]["hooks"] as $hookPath => $hUrl) {
        if (strpos($filename, $hookPath) === 0 && ! in_array($hookPath, $hooks)) {
            $hooks[] = $hookPath;
            $hookUrls[] = $hUrl;
            fprintf ($h,  "hook url " . $hUrl . "\n");
        }
    }
}

foreach ($hookUrls as $hUrl) {

    $commit_data = rawurlencode($username . "|" .  $new_revision . "|" . $commit_msg);
    $u = $config[$repos]["beUser"];
    $p = $config[$repos]["bePasswd"];
    $cmd = "curl --request POST --data-urlencode \"userid=$u\" --data-urlencode \"passwd=$p\" --data \"commit_data=$commit_data\" $hUrl";
    echo "$cmd \n";
    //fprintf ($h, "cmd: " . $cmd . "\n");
    exec($cmd, $res);
    fprintf ($h, "result: " . print_r($res, true) . "\n");
}

fclose($h);