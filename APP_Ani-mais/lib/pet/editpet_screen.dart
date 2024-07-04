import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditPetScreen extends StatefulWidget {
  final int petId; // Receber o ID do pet da tela anterior

  EditPetScreen({required this.petId});

  @override
  _EditPetScreenState createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _chipController = TextEditingController();
  final _sexoController = TextEditingController();
  final _especieController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _fotoController = TextEditingController(); // Add this line

  File? _petImage;
  String? _base64Image; // Base64 da imagem
  Image? _petImageFromBase64; // Image widget to display Base64 image

  @override
  void initState() {
    super.initState();
    // Carregar os dados reais do pet com o ID recebido
    _loadPetData();
  }

  Future<void> _loadPetData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://fasttec.com.br/animais/api/get_pet_data.php?petId=${widget.petId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final pet = data['data']['pet'];
          print('Pet Data: $pet'); // Debug print

          setState(() {
            _nomeController.text = pet['nome'];
            _racaController.text = pet['raca'];
            _chipController.text = pet['numChip'];
            _sexoController.text = pet['genero'];
            _especieController.text = pet['especie'];
            _dataNascimentoController.text = pet['dataNasc'];
            _fotoController.text = pet['foto'] ?? '';

            if (_fotoController.text.isEmpty) {
              _base64Image = "base64 default";
            } else {
              _base64Image = _fotoController.text;
              _petImageFromBase64 = Image.memory(base64Decode(_base64Image!));
            }
          });
        }
      }
    } catch (e) {
      print('Erro ao carregar dados do pet: $e');
    }
  }

  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pet Atualizado'),
          content: Text('Pet atualizado com sucesso!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Voltar duas vezes para a tela anterior
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 5),
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome do Pet',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira o nome do pet';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: _racaController,
                  decoration: InputDecoration(
                    labelText: 'Raça do Pet',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira a raça do pet';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _chipController,
                  decoration: InputDecoration(
                    labelText: 'Chip do Pet',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira o chip do pet';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: _sexoController,
                  decoration: InputDecoration(
                    labelText: 'Sexo do Pet',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira o sexo do pet';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: _especieController,
                  decoration: InputDecoration(
                    labelText: 'Espécie do Pet',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira a espécie do pet';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: _dataNascimentoController,
                  decoration: InputDecoration(
                    labelText: 'Data de Nascimento do Pet',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira a data de nascimento do pet';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                _petImage != null
                    ? Image.file(_petImage!)
                    : (_petImageFromBase64 != null
                    ? _petImageFromBase64!
                    : Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text('Adicionar Foto'),
                  ),
                )),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      setState(() {
                        _petImage = File(pickedFile.path);
                        // Converte a imagem para base64
                        List<int> imageBytes = _petImage!.readAsBytesSync();
                        _base64Image = base64Encode(imageBytes);
                      });
                    }
                  },
                  child: Text('Adicionar Foto'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Preparar dados para enviar para o servidor
                      var petData = {
                        'id': widget.petId, // Inclui o ID do pet
                        'nome': _nomeController.text,
                        'dataNascimento': _dataNascimentoController.text,
                        'raca': _racaController.text,
                        'genero': _sexoController.text,
                        'especie': _especieController.text,
                        'numChip': _chipController.text,
                        // Incluir imagem em base64 no envio
                        'imagemBase64': _base64Image,
                      };
                      // Enviar dados para o servidor
                      var success = await _updatePetData(petData);
                      if (success) {
                        await _showSuccessDialog();
                      } else {
                        print('Falha ao atualizar o pet.');
                      }
                    }
                  },
                  child: Text('Atualizar Pet'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _updatePetData(Map<String, dynamic> petData) async {
    var url = 'https://fasttec.com.br/animais/api/update_pet.php';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode(petData);

    try {
      var response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          return true;
        } else {
          print('Erro ao atualizar pet: ${jsonData['message']}');
          return false;
        }
      } else {
        print('Falha ao atualizar pet: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro: $e');
      return false;
    }
  }
}
