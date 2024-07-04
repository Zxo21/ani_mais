<?php
    $dbHost = 'ani_mais.mysql.dbaas.com.br';
    $dbUsername = 'ani_mais';
    $dbPassword = 'Animais@!1';
    $dbName = 'ani_mais';

    try {
        $con = new mysqli($dbHost,$dbUsername,$dbPassword,$dbName);
        $con->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    } catch(PDOException $e){
        echo "Cobbection failed: " . $e->getMessage();
    }

    
?>