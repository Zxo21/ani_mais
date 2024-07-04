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

// Capture incoming POST data (assuming it's a POST request)
$petId = isset($_POST['petId']) ? $_POST['petId'] : '';

// Validate required fields
if (empty($petId)) {
    die(json_encode([
        'status' => 'error',
        'message' => 'Missing required fields.'
    ]));
}

// Verifica se o ID do animal foi fornecido via mщtodo POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $id_animal = $_POST['petId']; // Id do animal a ser deletado

  // Inicia uma transaчуo
  $conn->begin_transaction();

  // Deleta as medicacoes relacionadas as comorbidades do animal
  $sql_select_comorbidades = "SELECT comorbidadeid FROM animal_comorbidade WHERE animalid = ?";
  $stmt = $conn->prepare($sql_select_comorbidades);
  $stmt->bind_param("i", $id_animal);
  $stmt->execute();
  $stmt->bind_result($comorbidadeid);

  // Array para armazenar as comorbidades do animal
  $comorbidades = array();

  // Armazena os IDs das comorbidades
  while ($stmt->fetch()) {
    $comorbidades[] = $comorbidadeid;
  }
  $stmt->close();

  // Deleta as medicacoes relacionadas as comorbidades do animal
  foreach ($comorbidades as $comorbidade_id) {
    $sql_delete_medicacoes = "DELETE FROM comorbidade_medicacao WHERE comorbidadeid = ?";
    $stmt = $conn->prepare($sql_delete_medicacoes);
    $stmt->bind_param("i", $comorbidade_id);
    $stmt->execute();
    $stmt->close();
  }

  // Deleta as vacinaчѕes vinculadas ao animal
  $sql_delete_vacinacoes = "DELETE FROM animal_vacinacao WHERE animalid = ?";
  $stmt = $conn->prepare($sql_delete_vacinacoes);
  $stmt->bind_param("i", $id_animal);
  $stmt->execute();
  $stmt->close();

  // Deleta as comorbidades vinculadas ao animal
  $sql_delete_comorbidades = "DELETE FROM animal_comorbidade WHERE animalid = ?";
  $stmt = $conn->prepare($sql_delete_comorbidades);
  $stmt->bind_param("i", $id_animal);
  $stmt->execute();
  $stmt->close();

  // Deleta o relacionamento do animal com os usuсrios
  $sql_delete_usuario_animal = "DELETE FROM usuarioAnimal WHERE idAnimal = ?";
  $stmt = $conn->prepare($sql_delete_usuario_animal);
  $stmt->bind_param("i", $id_animal);
  $stmt->execute();
  $stmt->close();

  // Agora podemos deletar o animal principal
  $sql_delete_animal = "DELETE FROM animal WHERE id = ?";
  $stmt = $conn->prepare($sql_delete_animal);
  $stmt->bind_param("i", $id_animal);

  // Executa a query
  if ($stmt->execute()) {
    // Verifica se algum animal foi deletado
    if ($stmt->affected_rows > 0) {
      // Confirma a transaчуo
      $conn->commit();
      echo json_encode(array("message" => "Animal deletado com sucesso."));
    } else {
      // Desfaz a transaчуo em caso de falha
      $conn->rollback();
      echo json_encode(array("message" => "Nenhum animal encontrado com o ID fornecido."));
    }
  } else {
    // Desfaz a transaчуo em caso de falha na execuчуo da query
    $conn->rollback();
    echo json_encode(array("message" => "Erro ao tentar deletar o animal: " . $stmt->error));
  }

  // Fecha o statement
  $stmt->close();
} else {
  echo json_encode(array("message" => "Mщtodo invсlido. Use POST para deletar um animal."));
}

// Fecha a conexуo com o banco de dados
$conn->close();
?>