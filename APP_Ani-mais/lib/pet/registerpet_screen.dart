import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RegisterPetScreen extends StatefulWidget {
  final int userId;

  RegisterPetScreen({required this.userId});

  @override
  _RegisterPetScreenState createState() => _RegisterPetScreenState();
}

class _RegisterPetScreenState extends State<RegisterPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _chipController = TextEditingController();
  final _sexoController = TextEditingController();
  final _especieController = TextEditingController();
  final _dataNascimentoController = TextEditingController();

  File? _petImage;
  String? _base64Image;

  Future<void> _registerPet() async {
    var url = 'https://fasttec.com.br/animais/api/register_pet.php';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'nome': _nomeController.text,
      'dataNascimento': _dataNascimentoController.text,
      'raca': _racaController.text,
      'especie': _especieController.text,
      'genero': _sexoController.text,
      'numChip': _chipController.text,
      'id_usuario': widget.userId,
      'imagemBase64': _base64Image,
    });

    try {
      var response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          print('Pet registrado com sucesso!');
          // Chama a função para enviar a imagem do pet após o registro
          await _uploadImage(jsonData['petId']); // Supondo que a resposta contenha o ID do pet registrado
          Navigator.pop(context, true);
        } else {
          print('Erro ao registrar pet: ${jsonData['message']}');
        }
      } else {
        print('Falha ao registrar pet: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  Future<void> _uploadImage(int petId) async {
    if (_petImage != null) {
      try {
        List<int> imageBytes = await _petImage!.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        print(base64Image);
        var url = 'https://fasttec.com.br/animais/api/upload_photo.php';
        var headers = {'Content-Type': 'application/json'};
        var body = jsonEncode({
          'idPet': petId,
          'photo': base64Image,
        });

        var response = await http.post(Uri.parse(url), headers: headers, body: body);
        if (response.statusCode == 200) {
          print('Imagem do pet enviada com sucesso!');
        } else {
          print('Falha ao enviar imagem do pet: ${response.reasonPhrase}');
        }
      } catch (e) {
        print('Erro ao enviar imagem do pet: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                SizedBox(height: 10),
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
                SizedBox(height: 10),
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
                SizedBox(height: 10),
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
                SizedBox(height: 10),
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
                    ? Image.file(
                  _petImage!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
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
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.camera);
                    setState(() {
                      if (pickedFile != null) {
                        _petImage = File(pickedFile.path);
                      } else {
                        _petImage = File(' ');
                      }
                    });
                  },
                  child: Text('Adicionar Foto'),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _registerPet();
                          }
                        },
                        child: Text('Registrar Pet'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
