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

$nome = isset($_POST['nome']) ? $_POST['nome'] : '';
$descricao = isset($_POST['descricao']) ? $_POST['descricao'] : '';
$observacao = isset($_POST['observacao']) ? $_POST['observacao'] : '';
$petId = isset($_POST['petId']) ? $_POST['petId'] : '';

// Validate required fields
if (empty($nome) || empty($descricao) || empty($petId)) {
    die(json_encode([
        'status' => 'error',
        'message' => 'Missing required fields.'
    ]));
}

// Adicionar comorbidade
$sql_comorbidade = "INSERT INTO comorbidade (nome, descricao, observacao) VALUES (?, ?, ?)";
$stmt_comorbidade = $conn->prepare($sql_comorbidade);

if (!$stmt_comorbidade) {
    die(json_encode([
        'status' => 'error',
        'message' => 'Erro ao preparar query: ' . $conn->error
    ]));
}

$stmt_comorbidade->bind_param("sss", $nome, $descricao, $observacao);

if ($stmt_comorbidade->execute()) {
    $comorbidadeId = $stmt_comorbidade->insert_id;

    // Vincular comorbidade ao animal
    $sql_animal_comorbidade = "INSERT INTO animal_comorbidade (animalid, comorbidadeid) VALUES (?, ?)";
    $stmt_animal_comorbidade = $conn->prepare($sql_animal_comorbidade);

    if (!$stmt_animal_comorbidade) {
        die(json_encode([
            'status' => 'error',
            'message' => 'Erro ao preparar query de vinculação: ' . $conn->error
        ]));
    }

    $stmt_animal_comorbidade->bind_param("ii", $petId, $comorbidadeId);

    if ($stmt_animal_comorbidade->execute()) {
        echo json_encode(['status' => 'success', 'message' => 'Comorbidade adicionada com sucesso ao animal.']);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Erro ao vincular comorbidade ao animal.',
            'sql_error' => $stmt_animal_comorbidade->error
        ]);
    }
    $stmt_animal_comorbidade->close();
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Erro ao adicionar comorbidade.',
        'sql_error' => $stmt_comorbidade->error
    ]);
}

$stmt_comorbidade->close();
$conn->close();
?>
