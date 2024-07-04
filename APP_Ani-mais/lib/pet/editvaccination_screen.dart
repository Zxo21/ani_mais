import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditVaccinationScreen extends StatefulWidget {
  final int id;

  EditVaccinationScreen({required this.id});

  @override
  _EditVaccinationScreenState createState() => _EditVaccinationScreenState();
}

class _EditVaccinationScreenState extends State<EditVaccinationScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _doseController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _proximaDoseController = TextEditingController();
  TextEditingController _observacaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchVaccinationData();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _doseController.dispose();
    _descricaoController.dispose();
    _proximaDoseController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _fetchVaccinationData() async {
    String url =
        'https://fasttec.com.br/animais/api/get_vaccination_data.php?id=${widget.id}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data['status'] == 'success') {
        final vaccination = data['data']['vaccination'];
        setState(() {
          _nomeController.text = vaccination['nome'];
          _doseController.text = vaccination['dose'];
          _descricaoController.text = vaccination['descricao'];
          _proximaDoseController.text = vaccination['proximaDose'];
          _observacaoController.text = vaccination['observacao'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Falha ao carregar dados da vacinação')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha na requisição: ${response.statusCode}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Vacina'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira a próxima dose';
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
                    _atualizarDadosVacina();
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

  void _atualizarDadosVacina() async {
    String url = 'https://fasttec.com.br/animais/api/edit_vaccination.php';
    var response = await http.post(
      Uri.parse(url),
      body: {
        'id': widget.id.toString(),
        'nome': _nomeController.text,
        'dose': _doseController.text,
        'descricao': _descricaoController.text,
        'proximaDose': _proximaDoseController.text,
        'observacao': _observacaoController.text,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);

      if (jsonResponse['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados da vacina atualizados com sucesso!')),
        );
        Navigator.pop(context); // Return to previous screen after successful update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['message'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar vacina')),
      );
    }
  }
}
