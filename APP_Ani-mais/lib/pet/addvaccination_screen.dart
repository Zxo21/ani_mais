import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddVaccinationScreen extends StatefulWidget {
  final int petId;

  AddVaccinationScreen({required this.petId});

  @override
  _AddVaccinationScreenState createState() => _AddVaccinationScreenState();
}

class _AddVaccinationScreenState extends State<AddVaccinationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _doseController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _proximaDoseController = TextEditingController();
  final _observacaoController = TextEditingController();

  Future<void> _addVaccination() async {
    final response = await http.post(
      Uri.parse('https://fasttec.com.br/animais/api/add_vaccination.php'),
      body: {
        'nome': _nomeController.text,
        'dose': _doseController.text,
        'descricao': _descricaoController.text,
        'proximaDose': _proximaDoseController.text,
        'observacao': _observacaoController.text,
        'petId': widget.petId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        // Mostrar tela de confirmação ou diálogo
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Vacinação Adicionada'),
              content: Text('Vacinação adicionada com sucesso.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context, true); // Voltar para a tela anterior
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Tratar erro de resposta
        print('Failed to add vaccination: ${data['message']}');
      }
    } else {
      // Tratar erro de solicitação
      print('Failed to add vaccination: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Vacina'),
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
                  labelText: 'Nome da Vacina',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira o nome da vacina';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _doseController,
                decoration: InputDecoration(
                  labelText: 'Dose',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira a dose';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira a descrição';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _proximaDoseController,
                decoration: InputDecoration(
                  labelText: 'Próxima Dose',
                  border: OutlineInputBorder(),
                ),
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addVaccination();
                  }
                },
                child: Text('Cadastrar Vacina'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
