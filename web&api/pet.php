<?php
    include_once('conexao.php');

    header('Content-Type: text/html; charset=utf-8');

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
?>
<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta http-equiv="content-type" content="text/html;charset=utf-8" />
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
		<!--
        <h1 class="text-center">Ani+</h1> -->
		<div class="mt-5 d-flex flex-column justify-content-center align-items-center" >
			<img class="img-fluid logo" style="width: 15%" src="assets/logo_animais.png" alt="Ani+ logo">
		</div>
        <div class="mt-5 d-flex flex-column justify-content-center align-items-center">
            <img class="foto-perfil img-fluid" src="<?php echo 'data:image/jpeg;base64,'.$verificadorAnimal['foto']?>" alt="">
            <h2><?php echo utf8_encode($verificadorAnimal['nome'])?></h2>
            <p><?php echo utf8_encode($verificadorAnimal['raca'])?></p>
        </div>
        <div class="d-flex mt-5 flex-row justify-content-around align-items-center">
            <div class="d-flex flex-column align-items-center">
                <h6>Espécie</h6>
                <p><?php echo utf8_encode($verificadorAnimal['especie'])?></p>
            </div>
            <div class="d-flex flex-column align-items-center">
                <h6>Gênero</h6>
                <p><?php echo utf8_encode($verificadorAnimal['genero'])?></p>
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
                            <?php while ($vacina = mysqli_fetch_assoc($resultadoVacina)) {                                
                            
                            echo "<p><b>". utf8_encode($vacina['nome'])."</b></p>";
                            echo "<p>". utf8_encode($vacina['descricao'])."</p>";
                            echo "<p>Dose:". $vacina['dose']."ª | Próxima dose: ". date('d/m/Y', strtotime($vacina['proxDose']))."</p>";
                            echo "<p>Obs:". utf8_encode($vacina['observacao'])."<p>";
                            
                           }?>
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
                            <?php while($comorbidade = mysqli_fetch_assoc($resultadoComorbidade)){
                                echo "<p><b>". utf8_encode($comorbidade['nome'])."</b></p>";
                                echo "<p>". utf8_encode($comorbidade['descricao'])."</p>";
                                echo "<p>Obs: ". utf8_encode($comorbidade['observacao'])."</p>";
                            }?>
                        
                        
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
                            <?php while($medicacao = mysqli_fetch_assoc($resultadoMedicacao)){

                                echo "<p><b>". utf8_encode($medicacao['nome'])."</b></p>";
                                echo "<p>". utf8_encode($medicacao['dosagem'])."</p>";
                                echo "<p>Dose: " . $medicacao['posologia']."</p>";
                                echo "<p>Obs: ". utf8_encode($medicacao['observacao'])."</p>";
                            }?>
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