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

// Get the pet ID from the request
$petId = $_GET['petId'];

if (!$petId) {
    die(json_encode([
        'status' => 'error',
        'message' => 'Pet ID is required'
    ]));
}

// Fetch pet data
$petQuery = "SELECT * FROM animal WHERE id = ?";
$stmt = $conn->prepare($petQuery);
$stmt->bind_param("i", $petId);
$stmt->execute();
$petResult = $stmt->get_result();
$petData = $petResult->fetch_assoc();

if (!$petData) {
    die(json_encode([
        'status' => 'error',
        'message' => 'Pet not found'
    ]));
}

// Fetch comorbidities
$comorbidityQuery = "
    SELECT c.id, c.nome
    FROM comorbidade c
    JOIN animal_comorbidade ac ON c.id = ac.comorbidadeid
    WHERE ac.animalid = ?";
$stmt = $conn->prepare($comorbidityQuery);
$stmt->bind_param("i", $petId);
$stmt->execute();
$comorbidityResult = $stmt->get_result();
$comorbidities = [];
while ($row = $comorbidityResult->fetch_assoc()) {
    $comorbidities[] = [
        'id' => $row['id'],
        'name' => $row['nome']
    ];
}

// Fetch medications
$medicationQuery = "
    SELECT m.id, m.nome, m.dosagem, m.posologia
    FROM medicacao m
    JOIN comorbidade_medicacao cm ON m.id = cm.medicacaoid
    JOIN animal_comorbidade ac ON cm.comorbidadeid = ac.comorbidadeid
    WHERE ac.animalid = ?";
$stmt = $conn->prepare($medicationQuery);
$stmt->bind_param("i", $petId);
$stmt->execute();
$medicationResult = $stmt->get_result();
$medications = [];
while ($row = $medicationResult->fetch_assoc()) {
    $medications[] = [
        'id' => $row['id'],
        'name' => $row['nome'],
        'dosage' => $row['dosagem'],
        'frequency' => $row['posologia']
    ];
}

// Fetch vaccinations
$vaccinationQuery = "
    SELECT v.id, v.nome
    FROM vacinacao v
    JOIN animal_vacinacao av ON v.id = av.vacinacaoid
    WHERE av.animalid = ?";
$stmt = $conn->prepare($vaccinationQuery);
$stmt->bind_param("i", $petId);
$stmt->execute();
$vaccinationResult = $stmt->get_result();
$vaccinations = [];
while ($row = $vaccinationResult->fetch_assoc()) {
    $vaccinations[] = [
        'id' => $row['id'],
        'name' => $row['nome']
    ];
}

// Close the database connection
$conn->close();

echo json_encode([
    'status' => 'success',
    'data' => [
        'pet' => $petData,
        'comorbidities' => $comorbidities,
        'medications' => $medications,
        'vaccinations' => $vaccinations
    ]
], JSON_UNESCAPED_UNICODE);
?>
