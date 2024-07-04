import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddMedicationScreen extends StatefulWidget {
  final int petId;

  AddMedicationScreen({required this.petId});

  @override
  _AddMedicationScreenState createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _dosagemController = TextEditingController();
  final _posologiaController = TextEditingController();
  final _observacaoController = TextEditingController();

  Future<void> _addMedication() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://fasttec.com.br/animais/api/add_medication.php'),
        body: {
          'nome': _nomeController.text,
          'dosagem': _dosagemController.text,
          'posologia': _posologiaController.text,
          'observacao': _observacaoController.text,
          'petId': widget.petId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Sucesso'),
                content: Text('Medicação adicionada com sucesso!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pop(context, true); // Voltar para a tela anterior
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          print('Falha ao adicionar medicação: ${data['message']}');
        }
      } else {
        print('Erro de requisição HTTP: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Medicação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome da Medicação',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira o nome da medicação';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _dosagemController,
                decoration: InputDecoration(
                  labelText: 'Dosagem',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira a dosagem';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _posologiaController,
                decoration: InputDecoration(
                  labelText: 'Posologia',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira a posologia';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _observacaoController,
                decoration: InputDecoration(
                  labelText: 'Observação',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addMedication,
                child: Text('Cadastrar Medicação'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
