<?php
    $dbHost = 'ani_mais.mysql.dbaas.com.br';
    $dbUsername = 'ani_mais';
    $dbPassword = 'Animais@!1';
    $dbName = 'ani_mais';

    $con = new mysqli($dbHost,$dbUsername,$dbPassword,$dbName);
/*
    mysqli_query($con, "SET NAMES 'utf8'") or die("Erro na SQL" . mysqli_error($con));
    mysqli_query($con, 'SET character_set_connection=utf8') or die("Erro na SQL" . mysqli_error($con));
    mysqli_query($con, 'SET character_set_client=utf8') or die("Erro na SQL" . mysqli_error($con));
    mysqli_query($con, 'SET character_set_results=utf8') or die("Erro na SQL" . mysqli_error($con));*/
?>