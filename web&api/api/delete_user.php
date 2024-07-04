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

// Recebe o ID do usuário a ser excluído
$userId = $_POST['id'];

// Verifica se o ID do usuário é válido
if (!isset($userId) || empty($userId)) {
    $response = array(
        "status" => "error",
        "message" => "ID do usuário não foi fornecido."
    );
    echo json_encode($response);
    exit;
}

try {
    // Inicia transação para garantir consistência
    $conn->begin_transaction();

    // Exclui registros na tabela `usuarioAnimal` associados ao usuário
    $sqlDeleteUserAnimal = "DELETE FROM usuarioAnimal WHERE id_usuario = $userId";
    $conn->query($sqlDeleteUserAnimal);

    // Exclui o usuário da tabela `usuario`
    $sqlDeleteUser = "DELETE FROM usuario WHERE id = $userId";
    $conn->query($sqlDeleteUser);

    // Verifica se houve sucesso nas operações
    if ($conn->affected_rows > 0) {
        // Confirma transação
        $conn->commit();

        $response = array(
            "status" => "success",
            "message" => "Usuário excluído com sucesso."
        );
    } else {
        // Caso não tenha afetado nenhum registro (usuário não encontrado)
        $conn->rollback();

        $response = array(
            "status" => "error",
            "message" => "Usuário não encontrado ou não pode ser excluído."
        );
    }
} catch (Exception $e) {
    // Em caso de erro, reverte transação
    $conn->rollback();

    $response = array(
        "status" => "error",
        "message" => "Erro ao excluir usuário: " . $e->getMessage()
    );
}

// Fecha conexão com o banco de dados
$conn->close();

// Retorna resposta JSON
echo json_encode($response);
?>
