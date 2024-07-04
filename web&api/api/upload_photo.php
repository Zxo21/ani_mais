<?php
   // include_once('conexao.php');
    header('Content-Type: application/json; charset=utf-8');
    date_default_timezone_set('America/Sao_Paulo');

    // Database connection details
$host = 'ani_mais.mysql.dbaas.com.br';
$username = 'ani_mais';
$password = 'Animais@!1';
$dbname = 'ani_mais';

// Create connection
$conn = new mysqli($host, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    http_response_code(500);
    die(json_encode([
        'status' => 'error',
        'message' => 'Database connection failed: ' . $conn->connect_error
    ]));
}

    if($_SERVER['REQUEST_METHOD'] === 'POST'){
        $json = file_get_contents('php://input');
        $dados = json_decode($json);
        $idPet = $dados->idPet;
        $photo = $dados->photo;

        //$nomeArquivo = 'perfil_' . date('YmdHis') . '_' . $idPet . '.jpeg';
       // $path = '../assets/perfil/' . $nomeArquivo;
        $querySelectAnimal = "SELECT * FROM animal WHERE id = $idPet";
        $resultadoAnimal = $conn->query($querySelectAnimal) or die($conn->error);
        if($resultadoAnimal->num_rows > 0){
                $stmtUpdateAnimal = $conn->prepare("UPDATE animal SET foto = ? where id = ?");
                $stmtUpdateAnimal->bind_param("si", $photo, $idPet);
                $stmtUpdateAnimal->execute();
                die(json_encode([
                    'status' => 'sucess',
                    'message' => 'Imagem registrada com sucesso.'
                ], JSON_UNESCAPED_UNICODE));    
        } else {
            http_response_code(599);
            die(json_encode([
                'status' => 'error',
                'message' => 'Pet não econtrado na nossa base'
            ], JSON_UNESCAPED_UNICODE));
        }

    } else {
        http_response_code(499);
        echo json_encode([
            'status' => 'error',
            'message' => 'Método inválido.'
        ], JSON_UNESCAPED_UNICODE);
    }
?>