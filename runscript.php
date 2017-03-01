<?php
    $locale='sv_SE.UTF-8';
    putenv('LC_ALL='.$locale);
    $text = $_GET["text"];
    $text = escapeshellarg($text);
    $text = trim($text);
    shell_exec('./coopSlackIntegration.sh '.$text.'');
    
    header('Content-Type: application/json');
    $data = file_get_contents('test.json');
    echo $data;
?>
