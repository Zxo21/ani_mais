<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");

// Verifica se o método de requisição é POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Database connection details
    $host = 'ani_mais.mysql.dbaas.com.br';
    $username = 'ani_mais';
    $password = 'Animais@!1';
    $dbname = 'ani_mais';

    // Create connection
    $conn = new mysqli($host, $username, $password, $dbname);

    // Check connection
    if ($conn->connect_error) {
        $response = [
            'status' => 'error',
            'message' => 'Database connection failed: ' . $conn->connect_error
        ];
        echo json_encode($response);
        exit;
    }

    $userId = isset($_POST['id']) ? $_POST['id'] : null;

    if (!$userId) {
        $response = [
            'status' => 'error',
            'message' => 'User ID not provided.'
        ];
        echo json_encode($response);
        exit;
    }

    // Query to get pets associated with the user
    $query = "SELECT a.id, a.nome, a.dataNasc, a.raca, a.genero, a.numChip, a.foto
              FROM usuario u
              JOIN usuarioAnimal ua ON u.id = ua.id_usuario
              JOIN animal a ON ua.idAnimal = a.id
              WHERE u.id = ?";

    $stmt = $conn->prepare($query);
    if (!$stmt) {
        $response = [
            'status' => 'error',
            'message' => 'Failed to prepare statement: ' . $conn->error
        ];
        echo json_encode($response);
        exit;
    }

    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $pets = [];
        while ($row = $result->fetch_assoc()) {
            $pets[] = $row;
        }
        $response = [
            'status' => 'success',
            'data' => $pets
        ];
    } else {
        $response = [
            'status' => 'error',
            'message' => 'Nenhum pet encontrado para este usuário.'
        ];
    }

    // Close statement and database connection
    $stmt->close();
    $conn->close();

    echo json_encode($response);
}
?>
