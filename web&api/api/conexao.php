<?php
$dbHost = 'ani_mais.mysql.dbaas.com.br';
$dbUsername = 'ani_mais';
$dbPassword = 'Animais@!1';
$dbName = 'ani_mais';

try {
    $dsn = "mysql:host=$dbHost;dbname=$dbName";
    $conn = new PDO($dsn, $dbUsername, $dbPassword);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

} catch (PDOException $e) {
    echo "Connection failed: " . $e->getMessage();
    exit;
}
?>
