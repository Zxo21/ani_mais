<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "conexao.php";

$name = $_POST['nome'];
$email = $_POST['email'];
$password = $_POST['password'];

try {
    $sql = "INSERT INTO `ani_mais`.`usuario` (`nome`, `email`, `senha`) VALUES (:nome, :email, :password)";

    $stmt = $conn->prepare($sql);
    $stmt->bindParam(":nome", $name);
    $stmt->bindParam(":email", $email);
    $stmt->bindParam(":password", $password);
    $stmt->execute();

    $response = array("status" => "success", "message" => "User registered successfully.");
} catch (PDOException $e) {
    $response = array("status" => "error", "message" => "Error: " . $e->getMessage());
}

echo json_encode($response);
?>
