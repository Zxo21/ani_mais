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

// Set charset to UTF-8
$conn->set_charset("utf8");

// Retrieve POST data
$id = $_POST['id']; // Assuming you pass the medication ID from Flutter
$nome = $conn->real_escape_string($_POST['nome']);
$dosagem = $conn->real_escape_string($_POST['dosagem']);
$pesologia = $conn->real_escape_string($_POST['pesologia']);
$observacao = $conn->real_escape_string($_POST['observacao']);

// Update medication in database
$sql_update = "UPDATE medicacao SET nome='$nome', dosagem='$dosagem', pesologia='$pesologia', observacao='$observacao' WHERE id='$id'";
if (mysqli_query($conn, $sql_update)) {
    $response = array('status' => 'success', 'message' => 'Medicação atualizada com sucesso.');
} else {
    $response = array('status' => 'error', 'message' => 'Erro ao atualizar medicação: ' . mysqli_error($conn));
}

echo json_encode($response, JSON_UNESCAPED_UNICODE); // Garante que caracteres especiais não sejam escapados
mysqli_close($conn);
?>
