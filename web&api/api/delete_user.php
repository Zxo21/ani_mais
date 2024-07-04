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

// Recebe o ID do usu�rio a ser exclu�do
$userId = $_POST['id'];

// Verifica se o ID do usu�rio � v�lido
if (!isset($userId) || empty($userId)) {
    $response = array(
        "status" => "error",
        "message" => "ID do usu�rio n�o foi fornecido."
    );
    echo json_encode($response);
    exit;
}

try {
    // Inicia transa��o para garantir consist�ncia
    $conn->begin_transaction();

    // Exclui registros na tabela `usuarioAnimal` associados ao usu�rio
    $sqlDeleteUserAnimal = "DELETE FROM usuarioAnimal WHERE id_usuario = $userId";
    $conn->query($sqlDeleteUserAnimal);

    // Exclui o usu�rio da tabela `usuario`
    $sqlDeleteUser = "DELETE FROM usuario WHERE id = $userId";
    $conn->query($sqlDeleteUser);

    // Verifica se houve sucesso nas opera��es
    if ($conn->affected_rows > 0) {
        // Confirma transa��o
        $conn->commit();

        $response = array(
            "status" => "success",
            "message" => "Usu�rio exclu�do com sucesso."
        );
    } else {
        // Caso n�o tenha afetado nenhum registro (usu�rio n�o encontrado)
        $conn->rollback();

        $response = array(
            "status" => "error",
            "message" => "Usu�rio n�o encontrado ou n�o pode ser exclu�do."
        );
    }
} catch (Exception $e) {
    // Em caso de erro, reverte transa��o
    $conn->rollback();

    $response = array(
        "status" => "error",
        "message" => "Erro ao excluir usu�rio: " . $e->getMessage()
    );
}

// Fecha conex�o com o banco de dados
$conn->close();

// Retorna resposta JSON
echo json_encode($response);
?>
