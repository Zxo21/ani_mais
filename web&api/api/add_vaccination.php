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

// Capture incoming POST data (assuming it's a POST request)
$nome = isset($_POST['nome']) ? $_POST['nome'] : '';
$dose = isset($_POST['dose']) ? $_POST['dose'] : '';
$descricao = isset($_POST['descricao']) ? $_POST['descricao'] : '';
$proximaDose = isset($_POST['proximaDose']) ? $_POST['proximaDose'] : '';
$observacao = isset($_POST['observacao']) ? $_POST['observacao'] : '';
$petId = isset($_POST['petId']) ? $_POST['petId'] : '';

// Validate required fields
if (empty($nome) || empty($dose) || empty($descricao) || empty($proximaDose) || empty($petId)) {
    die(json_encode([
        'status' => 'error',
        'message' => 'Missing required fields.'
    ]));
}

// Prepare SQL statements using prepared statements
$sql = "INSERT INTO vacinacao (nome, dose, descricao, proxDose, observacao) VALUES (?, ?, ?, ?, ?)";
$stmt = $conn->prepare($sql);

if (!$stmt) {
    die(json_encode([
        'status' => 'error',
        'message' => 'Erro ao preparar query: ' . $conn->error
    ]));
}

$stmt->bind_param("sssss", $nome, $dose, $descricao, $proximaDose, $observacao);

// Execute the query
if ($stmt->execute()) {
    $vaccinationId = $stmt->insert_id;

    // Link vaccination to pet
    $sqlLink = "INSERT INTO animal_vacinacao (animalid, vacinacaoid) VALUES (?, ?)";
    $stmtLink = $conn->prepare($sqlLink);

    if (!$stmtLink) {
        die(json_encode([
            'status' => 'error',
            'message' => 'Erro ao preparar query de vinculação: ' . $conn->error
        ]));
    }

    $stmtLink->bind_param("ii", $petId, $vaccinationId);

    if ($stmtLink->execute()) {
        echo json_encode(['status' => 'success']);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Erro ao vincular vacinação ao pet.',
            'sql_error' => $stmtLink->error
        ]);
    }
    $stmtLink->close();
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Erro ao adicionar vacinação.',
        'sql_error' => $stmt->error
    ]);
}

// Close statements and database connection
$stmt->close();
$conn->close();
?>
