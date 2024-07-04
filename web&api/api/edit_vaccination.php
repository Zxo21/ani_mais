<?php
header('Content-Type: application/json; charset=utf-8');
header("Access-Control-Allow-Origin: *");

// Database connection details
$host = 'ani_mais.mysql.dbaas.com.br';
$username = 'ani_mais';
$password = 'Animais@!1';
$dbname = 'ani_mais';

// Step 1: Create connection
$conn = new mysqli($host, $username, $password, $dbname);


// Step 2: Check connection
if ($conn->connect_error) {
    die(json_encode([
        'status' => 'error',
        'message' => 'Step 2: Database connection failed: ' . $conn->connect_error
    ]));
} 
// Step 3: Set charset to UTF-8
$conn->set_charset("utf8");


// Step 4: Verifica se os parâmetros necessários foram enviados via POST
if (isset($_POST['id'], $_POST['nome'], $_POST['dose'], $_POST['descricao'], $_POST['proximaDose'], $_POST['observacao'])) {


    // Step 5: Sanitize and escape inputs for security
    $id = $conn->real_escape_string($_POST['id']);
    $nome = $conn->real_escape_string($_POST['nome']);
    $dose = $conn->real_escape_string($_POST['dose']);
    $descricao = $conn->real_escape_string($_POST['descricao']);
    $proxDose = $conn->real_escape_string($_POST['proximaDose']);
    $observacao = $conn->real_escape_string($_POST['observacao']);


    // Step 6: Check if required fields are empty
    if (empty($id) || empty($nome) || empty($descricao)) {
        echo json_encode(array('status' => 'error', 'message' => 'Step 6: All fields are mandatory'));
        exit;
    }

    // Step 7: Prepare and execute update query
    $query = "UPDATE vacinacao SET nome = ?, dose = ?, descricao = ?, proxDose = ?, observacao = ? WHERE id = ?";

    if ($stmt = $conn->prepare($query)) {
        $stmt->bind_param("sssssi", $nome, $dose, $descricao, $proxDose, $observacao, $id);

        if ($stmt->execute()) {
            echo json_encode(array('status' => 'success', 'message' => 'Step 9: Vaccination updated successfully'));
        } else {
            echo json_encode(array('status' => 'error', 'message' => 'Step 9: Failed to update vaccination: ' . $stmt->error));
        }

        $stmt->close();
        
    } else {
        echo json_encode(array('status' => 'error', 'message' => 'Step 8: Server error preparing query.'));
    }

    // Step 11: Close database connection
    $conn->close();
  
} else {
    echo json_encode(array('status' => 'error', 'message' => 'Step 4: Required parameters not received.'));
}
?>
