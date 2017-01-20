<?php
    /* echo 'Hello ' . htmlspecialchars($_GET["text"]) . '!';*/
    $text = $_GET["text"];
    shell_exec("./coopSlackIntegration.sh $text");
    $data = file_get_contents('test.json');
    echo $data;
?>
