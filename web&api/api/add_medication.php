<?php
header('Content-Type: application/json; charset=utf-8');

// Habilitar exibição de erros para debug
error_reporting(E_ALL);
ini_set('display_errors', 1);

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

// Variáveis recebidas via POST
$nome = $_POST['nome'] ?? '';
$dosagem = $_POST['dosagem'] ?? '';
$posologia = $_POST['posologia'] ?? '';
$observacao = $_POST['observacao'] ?? '';
$petId = $_POST['petId'] ?? '';

// Verificação se os dados foram recebidos corretamente
if (empty($nome) || empty($dosagem) || empty($posologia) || empty($observacao) || empty($petId)) {
    die(json_encode([
        'status' => 'error',
        'message' => 'Todos os campos devem ser preenchidos.'
    ]));
}

try {
    // Begin transaction
    $conn->begin_transaction();

    // Check if the pet already has comorbidities
    $sql_check_comorbidades = "SELECT comorbidadeid FROM animal_comorbidade WHERE animalid = ?";
    $stmt_check_comorbidades = $conn->prepare($sql_check_comorbidades);
    $stmt_check_comorbidades->bind_param("i", $petId);
    $stmt_check_comorbidades->execute();
    $result_check_comorbidades = $stmt_check_comorbidades->get_result();

    if ($result_check_comorbidades && $result_check_comorbidades->num_rows > 0) {
        // Pet already has comorbidities, use the first one found
        $row = $result_check_comorbidades->fetch_assoc();
        $comorbidadeId = $row['comorbidadeid'];

        // Adicionar medicação vinculada à comorbidade encontrada
        $sql_medicacao = "INSERT INTO medicacao (nome, dosagem, posologia, observacao) VALUES (?, ?, ?, ?)";
        $stmt_medicacao = $conn->prepare($sql_medicacao);
        $stmt_medicacao->bind_param("ssss", $nome, $dosagem, $posologia, $observacao);
        $stmt_medicacao->execute();
        $medicacaoId = $stmt_medicacao->insert_id;

        // Vincular medicação à comorbidade existente
        $sql_comorbidade_medicacao = "INSERT INTO comorbidade_medicacao (comorbidadeid, medicacaoid) VALUES (?, ?)";
        $stmt_comorbidade_medicacao = $conn->prepare($sql_comorbidade_medicacao);
        $stmt_comorbidade_medicacao->bind_param("ii", $comorbidadeId, $medicacaoId);
        $stmt_comorbidade_medicacao->execute();

        $response = array('status' => 'success', 'message' => 'Medicação adicionada com sucesso à comorbidade existente.');
    } else {
        // Pet doesn't have comorbidities, create a new comorbidity and link medication
        $comorbidadeNome = 'Padrão ' . $petId;
        $descricao_comorbidade = 'Vínculo de medicação com pet ' . $petId;

        // Criar nova comorbidade
        $sql_comorbidade = "INSERT INTO comorbidade (nome, descricao) VALUES (?, ?)";
        $stmt_comorbidade = $conn->prepare($sql_comorbidade);
        $stmt_comorbidade->bind_param("ss", $comorbidadeNome, $descricao_comorbidade);
        $stmt_comorbidade->execute();
        $comorbidadeId = $stmt_comorbidade->insert_id;

        // Vincular comorbidade ao pet
        $sql_animal_comorbidade = "INSERT INTO animal_comorbidade (animalid, comorbidadeid) VALUES (?, ?)";
        $stmt_animal_comorbidade = $conn->prepare($sql_animal_comorbidade);
        $stmt_animal_comorbidade->bind_param("ii", $petId, $comorbidadeId);
        $stmt_animal_comorbidade->execute();

        // Adicionar medicação vinculada à nova comorbidade criada
        $sql_medicacao = "INSERT INTO medicacao (nome, dosagem, posologia, observacao) VALUES (?, ?, ?, ?)";
        $stmt_medicacao = $conn->prepare($sql_medicacao);
        $stmt_medicacao->bind_param("ssss", $nome, $dosagem, $posologia, $observacao);
        $stmt_medicacao->execute();
        $medicacaoId = $stmt_medicacao->insert_id;

        // Vincular medicação à comorbidade criada
        $sql_comorbidade_medicacao = "INSERT INTO comorbidade_medicacao (comorbidadeid, medicacaoid) VALUES (?, ?)";
        $stmt_comorbidade_medicacao = $conn->prepare($sql_comorbidade_medicacao);
        $stmt_comorbidade_medicacao->bind_param("ii", $comorbidadeId, $medicacaoId);
        $stmt_comorbidade_medicacao->execute();

        $response = array('status' => 'success', 'message' => 'Medicação adicionada com sucesso à nova comorbidade criada.');
    }

    // Commit transaction
    $conn->commit();

    echo json_encode($response, JSON_UNESCAPED_UNICODE); // Garante que caracteres especiais não sejam escapados
} catch (Exception $e) {
    // Rollback em caso de erro
    $conn->rollback();
    echo json_encode(['status' => 'error', 'message' => 'Erro no servidor: ' . $e->getMessage()]);
} finally {
    // Fechar conexões e liberar recursos
    $stmt_check_comorbidades->close();
    $stmt_medicacao->close();
    $stmt_comorbidade_medicacao->close();
    $stmt_comorbidade->close();
    $stmt_animal_comorbidade->close();
    $conn->close();
}
?>
