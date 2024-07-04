import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditComorbidityScreen extends StatefulWidget {
  final int id;

  EditComorbidityScreen({required this.id, required String nome});

  @override
  _EditComorbidityScreenState createState() => _EditComorbidityScreenState();
}

class _EditComorbidityScreenState extends State<EditComorbidityScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  TextEditingController _observacaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchComorbidityData();
  }

  Future<void> _fetchComorbidityData() async {
    String url = 'https://fasttec.com.br/animais/api/get_comorbidity_data.php?id=${widget.id}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        final comorbidity = data['data']['comorbidity'];
        setState(() {
          _nomeController.text = comorbidity['nome'];
          _descricaoController.text = comorbidity['descricao'];
          _observacaoController.text = comorbidity['observacao'];
        });
      } else {
        print('Failed to load comorbidity data: ${data['message']}');
      }
    } else {
      print('Failed to load comorbidity data: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Comorbidade'),
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
                    _updateComorbidityData();
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

  void _updateComorbidityData() async {
    String url = 'https://fasttec.com.br/animais/api/edit_comorbidity.php';
    var response = await http.post(
      Uri.parse(url),
      body: {
        'id': widget.id.toString(),
        'nome': _nomeController.text,
        'descricao': _descricaoController.text,
        'observacao': _observacaoController.text,
      },
    );

    if (response.statusCode == 200) {
      var data = response.body;
      var jsonResponse = json.decode(data);

      if (jsonResponse['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados da comorbidade atualizados com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['message'])),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar comorbidade')),
      );
    }
  }
}
