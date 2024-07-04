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
    $sql = "SELECT * FROM comorbidade WHERE id = $id";

    // Executa a query
    $result = $conn->query($sql);

    // Verifica se a query retornou resultados
    if ($result->num_rows > 0) {
        // Array para armazenar os dados da vacina��o
        $comorbidity_data = array();

        // Retorna os dados como um array associativo
        while ($row = $result->fetch_assoc()) {
            $comorbidity_data['id'] = $row['id'];
            $comorbidity_data['nome'] = $row['nome'];
            $comorbidity_data['descricao'] = $row['descricao'];
            $comorbidity_data['observacao'] = $row['observacao'];
        }

        // Resposta JSON com os dados da vacina��o
        $response = array(
            'status' => 'success',
            'data' => array(
                'comorbidity' => $comorbidity_data
            )
        );
    } else {
        // Caso n�o encontre nenhum registro com o ID fornecido
        $response = array(
            'status' => 'error',
            'message' => 'Comorbidade n�o encontrada'
        );
    }
} else {
    // Caso o par�metro ID n�o tenha sido fornecido na requisi��o GET
    $response = array(
        'status' => 'error',
        'message' => 'ID da comorbidade n�o especificado'
    );
}

// Converte a resposta para JSON e imprime
header('Content-Type: application/json');
echo json_encode($response);

// Fecha a conex�o com o banco de dados
$conn->close();
?>
