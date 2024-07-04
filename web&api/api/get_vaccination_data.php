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

// Verifica se o par�metro id foi enviado via GET
if (isset($_GET['id'])) {
    $id = $_GET['id'];

    // Query para selecionar os dados da vacina��o com base no ID
    $sql = "SELECT * FROM vacinacao WHERE id = $id";

    // Executa a query
    $result = $conn->query($sql);

    // Verifica se a query retornou resultados
    if ($result->num_rows > 0) {
        // Array para armazenar os dados da vacina��o
        $vaccination_data = array();

        // Retorna os dados como um array associativo
        while ($row = $result->fetch_assoc()) {
            $vaccination_data['id'] = $row['id'];
            $vaccination_data['nome'] = $row['nome'];
            $vaccination_data['dose'] = $row['dose'];
            $vaccination_data['descricao'] = $row['descricao'];
            $vaccination_data['proximaDose'] = $row['proxDose'];
            $vaccination_data['observacao'] = $row['observacao'];
        }

        // Resposta JSON com os dados da vacina��o
        $response = array(
            'status' => 'success',
            'data' => array(
                'vaccination' => $vaccination_data
            )
        );
    } else {
        // Caso n�o encontre nenhum registro com o ID fornecido
        $response = array(
            'status' => 'error',
            'message' => 'Vacina��o n�o encontrada'
        );
    }
} else {
    // Caso o par�metro ID n�o tenha sido fornecido na requisi��o GET
    $response = array(
        'status' => 'error',
        'message' => 'ID da vacina��o n�o especificado'
    );
}

// Converte a resposta para JSON e imprime
header('Content-Type: application/json');
echo json_encode($response);

// Fecha a conex�o com o banco de dados
$conn->close();
?>
