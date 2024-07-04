<?php
header('Content-Type: application/json; charset=utf-8');

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

// Capture incoming POST data (assuming it's a POST request)
$vaccinationId = isset($_POST['vaccinationId']) ? $_POST['vaccinationId'] : '';

// Validate required fields
if (empty($vaccinationId)) {
    die(json_encode([
        'status' => 'error',
        'message' => 'Missing required fields.'
    ]));
}

// Set up SQL statement for deletion
$sqlDeleteAnimalVacinacao = "DELETE FROM animal_vacinacao WHERE vacinacaoid = ?";

// Prepare statement for deletion
$stmtDeleteAnimalVacinacao = $conn->prepare($sqlDeleteAnimalVacinacao);
$stmtDeleteAnimalVacinacao->bind_param("i", $vaccinationId);

// Execute the deletion query
if ($stmtDeleteAnimalVacinacao->execute()) {
    echo json_encode([
        'status' => 'success',
        'message' => 'Vaccination record deleted successfully.'
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Failed to delete vaccination record: ' . $conn->error
    ]);
}

// Close statement and database connection
$stmtDeleteAnimalVacinacao->close();
$conn->close();
?>
