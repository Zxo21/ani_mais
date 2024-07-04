<?php
header('Content-Type: application/json; charset=utf-8');
header("Access-Control-Allow-Origin: *");

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

// Verifica se os parâmetros necessários foram enviados via POST
if (isset($_POST['id']) && isset($_POST['nome']) && isset($_POST['descricao']) && isset($_POST['observacao'])) {
    // Sanitize and escape inputs for security
    $id = $conn->real_escape_string($_POST['id']);
    $nome = $conn->real_escape_string($_POST['nome']);
    $descricao = $conn->real_escape_string($_POST['descricao']);
    $observacao = $conn->real_escape_string($_POST['observacao']);

    if (empty($id) || empty($nome) || empty($descricao)) {
        echo json_encode(array('status' => 'error', 'message' => 'Todos os campos são obrigatórios'));
        exit;
    }

    // Query para atualizar os dados da comorbidade
    $query = "UPDATE comorbidade SET nome = ?, descricao = ?, observacao = ? WHERE id = ?";

    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("sssi", $nome, $descricao, $observacao, $id);
        if ($stmt->execute()) {
            echo json_encode(array('status' => 'success', 'message' => 'Comorbidade atualizada com sucesso'));
        } else {
            echo json_encode(array('status' => 'error', 'message' => 'Erro ao atualizar comorbidade: ' . $stmt->error));
        }
        $stmt->close();
    } else {
        // Caso algum parâmetro necessário não tenha sido enviado na requisição POST
        echo json_encode(array('status' => 'error', 'message' => 'Erro no servidor ao preparar a query.'));
    }

    // Fecha a conexão com o banco de dados
    $conn->close();
} else {
    echo json_encode(array('status' => 'error', 'message' => 'Parâmetros necessários não enviados.'));
}
?>
