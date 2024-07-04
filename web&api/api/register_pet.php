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

// Verificar se a requisi��o � do tipo POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Receber os dados do pet do corpo da requisi��o
    $data = json_decode(file_get_contents("php://input"), true);

    // Extrair os dados do pet
    $nome = $data['nome'];
    $dataNasc = $data['dataNascimento'];
    $raca = $data['raca'];
    $genero = $data['genero'];
    $especie = $data['especie'];
    $numChip = $data['numChip'];
    $id_usuario = $data['id_usuario']; // Este ser� o userId enviado pelo Flutter

    // Preparar e executar a consulta SQL para inserir o pet
    $sql = "INSERT INTO animal (nome, dataNasc, raca, genero, especie, numChip) 
            VALUES ('$nome', '$dataNasc', '$raca', '$genero', '$especie', '$numChip')";

    if ($conn->query($sql) === TRUE) {
        $pet_id = $conn->insert_id; // Obt�m o ID do pet inserido

        // Agora, vincule este pet ao usu�rio na tabela usuarioAnimal
        $sql_usuario_animal = "INSERT INTO usuarioAnimal (id_usuario, idAnimal) 
                               VALUES ('$id_usuario', '$pet_id')";
        
        if ($conn->query($sql_usuario_animal) === TRUE) {
            // Retornar resposta JSON de sucesso
            $response = array("status" => "success", "message" => "Pet registrado com sucesso!", "petId" => $pet_id);
            echo json_encode($response);
        } else {
            // Se houver erro ao vincular o pet ao usu�rio
            $response = array("status" => "error", "message" => "Erro ao vincular o pet ao usu�rio: " . $conn->error);
            echo json_encode($response);
        }
    } else {
        // Se houver erro ao inserir o pet
        $response = array("status" => "error", "message" => "Erro ao registrar o pet: " . $conn->error);
        echo json_encode($response);
    }
} else {
    // Se n�o for uma requisi��o POST
    $response = array("status" => "error", "message" => "M�todo n�o permitido. Utilize POST.");
    echo json_encode($response);
}

// Fechar conex�o com o banco de dados
$conn->close();
?>
