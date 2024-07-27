import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditMedicationScreen extends StatefulWidget {
  final int id;
  final String nome;
  final String observacao;

  EditMedicationScreen({
    required this.id,
    required this.nome,
    required this.observacao,
  });

  @override
  _EditMedicationScreenState createState() => _EditMedicationScreenState();
}

class _EditMedicationScreenState extends State<EditMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _dosagemController = TextEditingController();
  TextEditingController _pesologiaController = TextEditingController();
  TextEditingController _observacaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomeController.text = widget.nome;
    _observacaoController.text = widget.observacao;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Medicação'),
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
                controller: _pesologiaController,
                decoration: InputDecoration(
                  labelText: 'Pesologia',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira a pesologia';
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
                    _atualizarDadosMedicacao();
                  }
                },
                child: Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _atualizarDadosMedicacao() async {
    String url = 'https://fasttec.com.br/animais/api/edit_medication.php';
    var response = await http.post(
      Uri.parse(url),
      body: {
        'id': widget.id.toString(),
        'nome': _nomeController.text,
        'dosagem': _dosagemController.text,
        'pesologia': _pesologiaController.text,
        'observacao': _observacaoController.text,
      },
    );
    print(widget.id.toString());
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = response.body;
      var jsonResponse = json.decode(data);

      
      if (jsonResponse['status'] == 'success') {
        // Exibir mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['message'])),
        );

        // Voltar para a tela anterior após salvar
        Navigator.pop(context);
      } else {
        // Exibir mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['message'])),
        );
      }
    } else {
      // Exibir mensagem de erro genérica
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar medicação')),
      );
    }
  }
}
