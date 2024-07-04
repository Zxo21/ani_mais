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

// Verifica se o ID da comorbidade foi fornecido via método POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $id_comorbidade = $_POST['comorbidityId']; // Id da comorbidade a ser deletada

  // Inicia uma transação
  $conn->begin_transaction();

  try {
    // Deleta as relações da comorbidade na tabela comorbidade_medicacao
    $sql_delete_comorbidade_medicacao = "DELETE FROM comorbidade_medicacao WHERE comorbidadeid = ?";
    $stmt = $conn->prepare($sql_delete_comorbidade_medicacao);
    $stmt->bind_param("i", $id_comorbidade);
    $stmt->execute();
    $stmt->close();

    // Deleta as relações da comorbidade na tabela animal_comorbidade
    $sql_delete_animal_comorbidade = "DELETE FROM animal_comorbidade WHERE comorbidadeid = ?";
    $stmt = $conn->prepare($sql_delete_animal_comorbidade);
    $stmt->bind_param("i", $id_comorbidade);
    $stmt->execute();
    $stmt->close();

    // Deleta a comorbidade da tabela comorbidade
    $sql_delete_comorbidade = "DELETE FROM comorbidade WHERE id = ?";
    $stmt = $conn->prepare($sql_delete_comorbidade);
    $stmt->bind_param("i", $id_comorbidade);
    $stmt->execute();

    // Verifica se a comorbidade foi deletada
    if ($stmt->affected_rows > 0) {
      // Confirma a transação
      $conn->commit();
      echo json_encode(array("message" => "Comorbidade deletada com sucesso."));
    } else {
      // Desfaz a transação em caso de falha ao deletar a comorbidade
      $conn->rollback();
      echo json_encode(array("message" => "Nenhuma comorbidade encontrada com o ID fornecido."));
    }

    $stmt->close();
  } catch (Exception $e) {
    // Desfaz a transação em caso de exceção
    $conn->rollback();
    echo json_encode(array("message" => "Erro ao tentar deletar a comorbidade: " . $e->getMessage()));
  }
} else {
  echo json_encode(array("message" => "Método inválido. Use POST para deletar uma comorbidade."));
}

// Fecha a conexão com o banco de dados
$conn->close();
?>
