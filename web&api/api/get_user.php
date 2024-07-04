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

// Verifica se o método de requisição é POST
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $userId = $_POST['id'];

    $query = "SELECT nome, email FROM usuario WHERE id = ?";
    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $stmt->bind_result($nome, $email);
        $stmt->fetch();

        if ($nome && $email) {
            $response = array(
                'status' => 'success',
                'user' => array(
                    'nome' => $nome,
                    'email' => $email
                )
            );
        } else {
            $response = array('status' => 'error', 'message' => 'Usuário não encontrado.');
        }

        $stmt->close();
    } else {
        $response = array('status' => 'error', 'message' => 'Erro no servidor.');
    }
    $conn->close();
    echo json_encode($response);
}
?>
