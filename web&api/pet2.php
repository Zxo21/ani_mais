<?php
    include_once('conexao.php');

    if(isset($_GET['id'])){

        $id = $_GET['id'];
        $querySelectAnimal = "SELECT * FROM animal WHERE id = $id";
        $querySelectVacina = "SELECT V.nome, V.proxDose, V.descricao, V.observacao, V.dose FROM vacinacao  V INNER JOIN animal_vacinacao AV ON AV.vacinacaoid = V.id INNER JOIN animal A ON A.id = AV.animalid WHERE A.id = $id";
        $querySelectComorbidade = "SELECT C.nome, C.descricao, C.observacao FROM comorbidade C INNER JOIN animal_comorbidade AC ON C.id = AC.comorbidadeid INNER JOIN animal A ON A.id = AC.animalid WHERE A.id = $id";
        $querySelectMedicacao = "SELECT M.nome, M.dosagem, M.posologia, M.observacao FROM medicacao M INNER JOIN comorbidade_medicacao CM ON M.id = CM.medicacaoid INNER JOIN comorbidade C ON C.id = CM.comorbidadeid INNER JOIN animal_comorbidade AC ON C.id = AC.comorbidadeid INNER JOIN animal A ON A.id = AC.animalid WHERE A.id = $id";
        
        $resultadoAnimal = $con->query($querySelectAnimal) or die($con->error);

        if(mysqli_num_rows($resultadoAnimal) > 0){
            $verificadorAnimal = $resultadoAnimal->fetch_assoc();

            if($verificadorAnimal['genero'] == 0) $verificadorAnimal['genero'] = "macho";
            if($verificadorAnimal['genero'] == 1) $verificadorAnimal['genero'] = "fêmea";
            $verificadorAnimal['dataNasc'] = date('d/m/Y', strtotime($verificadorAnimal['dataNasc']));

            $resultadoVacina = $con->query($querySelectVacina) or die($con->error);
            $resultadoComorbidade = $con->query($querySelectComorbidade) or die($con->error);
            $resultadoMedicacao = $con->query($querySelectMedicacao) or die($con->error);

            if(mysqli_num_rows($resultadoVacina) > 0){
                $verificadorVacina = $resultadoVacina->fetch_assoc();
                $verificadorVacina['proxDose'] = date('d/m/Y', strtotime($verificadorVacina['proxDose']));
            } else {
                $verificadorVacina = [
                    'nome' => '',
                    'dose' => '',
                    'descricao' => '',
                    'proxDose' => '',
                    'observacao' => ''
                ];
            }

            if(mysqli_num_rows($resultadoComorbidade) > 0){
                $verificadorComorbidade = $resultadoComorbidade->fetch_assoc();
            } else {
                $verificadorComorbidade = [
                    'nome' => '',
                    'descricao' => '',
                    'observacao' => ''
                ];
            }

            if(mysqli_num_rows($resultadoMedicacao) > 0){
                $verificadorMedicacao = $resultadoMedicacao->fetch_assoc();
            } else {
                $verificadorMedicacao = [
                    'nome' => '',
                    'dosagem' => '',
                    'posologia' => '',
                    'observacao' => ''
                ];
            }
?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ani+ | Perfil de <?php echo $verificadorAnimal['nome']?></title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css"
        integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">

    <link rel="stylesheet" href="styles/pet.css">

    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js"
        integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49"
        crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js"
        integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy"
        crossorigin="anonymous"></script>
</head>

<body>
    <div>
        <h1 class="text-center">Ani+</h1>
        <div class="mt-5 d-flex flex-column justify-content-center align-items-center">
            <img class="foto-perfil img-fluid" src="<?php echo $verificadorAnimal['foto']?>" alt="">
            <h2><?php echo $verificadorAnimal['nome']?></h2>
            <p><?php echo $verificadorAnimal['raca']?></p>
        </div>
        <div class="d-flex mt-5 flex-row justify-content-around align-items-center">
            <div class="d-flex flex-column align-items-center">
                <h6>Espécie</h6>
                <p><?php echo $verificadorAnimal['especie']?></p>
            </div>
            <div class="d-flex flex-column align-items-center">
                <h6>Gênero</h6>
                <p><?php echo $verificadorAnimal['genero']?></p>
            </div>
            <div class="d-flex flex-column align-items-center">
                <h6>Data de nascimento</h6>
                <p><?php echo $verificadorAnimal['dataNasc']?></p>
            </div>
            <div class="d-flex flex-column align-items-center">
                <h6>Chip</h6>
                <p><?php echo $verificadorAnimal['numChip']?></p>
            </div>
        </div>
        <hr class="m-4">
        <div class="p-2">
            <h5>Registros do animal</h5>
            <div class="mb-4 mt-3">
            <p>
                <a class="h6" data-toggle="collapse" href="#multiCollapseExample1" role="button" aria-expanded="false" aria-controls="multiCollapseExample1">Vacinação</a>
              </p>
              <div class="row w-75">
                <div class="col">
                    <div class="collapse multi-collapse" id="multiCollapseExample1">
                        <div class="card card-body">
                            <p><b><?php echo $verificadorVacina['nome'];?></b></p>
                            <p><?php echo utf8_encode($verificadorVacina['descricao'])?></p>
                            <p><?php echo "Dose: ".$verificadorVacina['dose'] . "ª | Próxima dose: " . $verificadorVacina['proxDose'];?>    </p>
                            <p><?php echo "Obs: ". $verificadorVacina['observacao']?></p>
                                                    </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="mb-4 mt-3">
            <p>
                <a class="h6" data-toggle="collapse" href="#multiCollapseExample2" role="button" aria-expanded="false" aria-controls="multiCollapseExample2">Comorbidade</a>
              </p>
              <div class="row w-75">
                <div class="col">
                    <div class="collapse multi-collapse" id="multiCollapseExample2">
                        <div class="card card-body">
                        <p><b><?php echo $verificadorComorbidade['nome'];?></b></p>
                            <p><?php echo utf8_encode($verificadorComorbidade['descricao'])?></p>
                            <p><?php echo "Obs: ". $verificadorComorbidade['observacao']?></p>
                                                   </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="mb-4 mt-3"></div>
            <p>
                <a class="h6" data-toggle="collapse" href="#multiCollapseExample3" role="button" aria-expanded="false" aria-controls="multiCollapseExample3">Medicação</a>
              </p>
              <div class="row w-75">
                <div class="col">
                    <div class="collapse multi-collapse" id="multiCollapseExample3">
                        <div class="card card-body">
                            <p><b><?php echo $verificadorMedicacao['nome'];?></b></p>
                            <p><?php echo utf8_encode($verificadorMedicacao['dosagem'])?></p>
                            <p><?php echo "Dose: " . $verificadorMedicacao['posologia']?></p>
                            <p><?php echo "Obs: ". $verificadorMedicacao['observacao']?></p>
                          </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>

</html>
<?php
        } else{
            echo "ERRO! ANIMAL NÃO ENCONTRADO!";
        }
    } else {
        echo "ERRO! PERFIL NÃO ENCONTRADO";
    }
?>