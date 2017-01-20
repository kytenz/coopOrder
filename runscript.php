<?php
/* echo 'Hello ' . htmlspecialchars($_GET["text"]) . '!';*/
/* TODO: The $text variable does not work when sending multiple words? */
    $text = $_GET["text"];
    $text=escapeshellarg($text);
    shell_exec('./coopSlackIntegration.sh '.$text.'');
    
    /* $data = file_get_contents('test.json'); */
    $data = file_get_contents('output.txt');
    /* json_string = json_encode($data, JSON_PRETTY_PRINT); */
    echo $data;
?>
