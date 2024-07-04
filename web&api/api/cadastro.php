<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

include "conexao.php";

// Check if all required POST parameters are set
if (!isset($_POST['nome'], $_POST['email'], $_POST['senha'])) {
    echo json_encode(array("status" => "error", "message" => "Missing required fields"));
    exit;
}

// Sanitize and validate inputs
$name = filter_input(INPUT_POST, 'nome', FILTER_SANITIZE_STRING);
$email = filter_input(INPUT_POST, 'email', FILTER_SANITIZE_EMAIL);
$password = $_POST['senha'];

if (!$name || !$email || !$password) {
    echo json_encode(array("status" => "error", "message" => "Invalid input"));
    exit;
}

try {
    $sql = "INSERT INTO `usuario` (`nome`, `email`, `senha`) VALUES (:nome, :email, :senha)";
    $stmt = $conn->prepare($sql);
    $stmt->bindParam(':nome', $name);
    $stmt->bindParam(':email', $email);
    $stmt->bindParam(':senha', $password);
    $stmt->execute();

    $response = array("status" => "success", "message" => "User registered successfully.");
} catch (PDOException $e) {
    $response = array("status" => "error", "message" => "Error: " . $e->getMessage());
}

// Close the database connection
$conn = null;

echo json_encode($response);
?>
