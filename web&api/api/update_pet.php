<?php
header('Content-Type: application/json');
header('Content-Type: text/html; charset=utf-8');

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

// Set the character set to utf8mb4 to handle special characters
$conn->set_charset("utf8mb4");

// Get the input data
$input = json_decode(file_get_contents('php://input'), true);

if (isset($input['id']) && isset($input['nome']) && isset($input['genero'])) {
    $id = $conn->real_escape_string($input['id']);
    $nome = $conn->real_escape_string($input['nome']);
    $dataNascimento = isset($input['dataNascimento']) ? $conn->real_escape_string($input['dataNascimento']) : NULL;
    $raca = isset($input['raca']) ? $conn->real_escape_string($input['raca']) : NULL;
    $genero = $conn->real_escape_string($input['genero']);
    $especie = isset($input['especie']) ? $conn->real_escape_string($input['especie']) : NULL;
    $numChip = isset($input['numChip']) ? $conn->real_escape_string($input['numChip']) : NULL;
    $foto = isset($input['imagemBase64']) ? $conn->real_escape_string($input['imagemBase64']) : NULL;

    // Prepare the SQL query
    $sql = "UPDATE animal SET 
                nome = '$nome',
                dataNasc = '$dataNascimento',
                raca = '$raca',
                genero = '$genero',
                especie = '$especie',
                numChip = '$numChip',
                foto = '$foto'
            WHERE id = $id";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(['status' => 'success', 'message' => 'Pet updated successfully']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Error updating pet: ' . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Required fields are missing']);
}

$conn->close();
?>
