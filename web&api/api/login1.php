<?php
header('Content-Type: application/json');

// Database connection details
$host = 'ani_mais.mysql.dbaas.com.br';
$username = 'ani_mais';
$password = 'Animais@!1';
$dbname = 'ani_mais';

// Create connection
$conn = new mysqli($host, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode([
        'status' => 'error',
        'message' => 'Database connection failed: ' . $conn->connect_error
    ]));
}

// Get data from Flutter app
$email = $_POST['email'] ?? '';
$password = $_POST['senha'] ?? '';

if (empty($email) || empty($password)) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Email and password are required'
    ]);
    $conn->close();
    exit();
}

// Secure the input to prevent SQL injection
$email = $conn->real_escape_string($email);
$password = $conn->real_escape_string($password);

// Query to check if user exists
$sql = "SELECT id, nome, email FROM usuario WHERE email = '$email' AND senha = '$password'";
$result = $conn->query($sql);

$response = array();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    $response['status'] = 'success';
    $response['user'] = $user; // include user details in the response
} else {
    $response['status'] = 'error';
    $response['message'] = 'Invalid email or password';
}

// Return response as JSON
echo json_encode($response);

$conn->close();
?>
