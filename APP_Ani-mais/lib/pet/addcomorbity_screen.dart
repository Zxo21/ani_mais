import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddComorbidityScreen extends StatefulWidget {
  final int petId;

  AddComorbidityScreen({required this.petId});

  @override
  _AddComorbidityScreenState createState() => _AddComorbidityScreenState();
}

class _AddComorbidityScreenState extends State<AddComorbidityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _observacaoController = TextEditingController();

  Future<void> _addComorbidity() async {
    final response = await http.post(
      Uri.parse('https://fasttec.com.br/animais/api/add_comorbidity.php'),
      body: {
        'nome': _nomeController.text,
        'descricao': _descricaoController.text,
        'observacao': _observacaoController.text,
        'petId': widget.petId.toString(), // Passando o ID do pet
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        // Mostrar um popup de confirmação
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sucesso'),
              content: Text('Comorbidade adicionada com sucesso!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Voltar para a tela anterior
                    Navigator.pop(context, true);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Tratar erro de resposta
        print('Failed to add comorbidity: ${data['message']}');
      }
    } else {
      // Tratar erro de solicitação HTTP
      print('Failed to add comorbidity: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Comorbidade'),
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
                  labelText: 'Nome da Comorbidade',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira o nome da comorbidade';
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
                    _addComorbidity();
                  }
                },
                child: Text('Cadastrar Comorbidade'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
