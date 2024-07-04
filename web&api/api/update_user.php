<?php
header('Content-Type: application/json');
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

// Verifique se o método da requisição é POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Receba os dados enviados via POST
    $userId = $_POST['id'];
    $nome = $_POST['nome'];
    $email = $_POST['email'];
    $senha = $_POST['senha']; // Lembre-se de tratar a senha de forma segura

    // Valide se os campos necessários foram recebidos
    if (empty($userId) || empty($nome) || empty($email) || empty($senha)) {
        echo json_encode(array('status' => 'error', 'message' => 'Todos os campos são obrigatórios'));
        exit;
    }

    // Atualize os dados do usuário no banco de dados
    $query = "UPDATE usuario SET nome = ?, email = ?, senha = ? WHERE id = ?";
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("sssi", $nome, $email, $senha, $userId);

        if ($stmt->execute()) {
            // Caso a atualização seja bem-sucedida, retorne um status de sucesso
            echo json_encode(array('status' => 'success', 'message' => 'Dados do perfil atualizados com sucesso.'));
        } else {
            // Caso ocorra um erro durante a execução da query
            echo json_encode(array('status' => 'error', 'message' => 'Erro ao atualizar dados do perfil: ' . $conn->error));
        }

        $stmt->close();
    } else {
        // Caso ocorra um erro na preparação da query
        echo json_encode(array('status' => 'error', 'message' => 'Erro no servidor ao preparar a query.'));
    }

    // Feche a conexão com o banco de dados
    $conn->close();
} else {
    // Caso o método da requisição não seja POST
    echo json_encode(array('status' => 'error', 'message' => 'Método não permitido.'));
}
?>
