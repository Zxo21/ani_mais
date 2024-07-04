<?php
    header('Content-Type: application/json');
    header("Acess-Control-Allow-Origin: *");

    include "conexao.php";

    $email = $_GET['email'];
    $password = $_GET['password'];

    $sql = "SELECT * FROM usuario WHERE email = :email ";
    $sql = "AND senha = :password ";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(":email", $email);
    $stmt->bindParam(":password", $password);
    $stmt->execute();
    $returnValue = $stmt->fetchAll(PDO::FETCH_ASSOC);

    echo json_encode($returnValue);

?>