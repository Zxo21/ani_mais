import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nome = '';
  String _email = '';
  String _senha = '******'; // Senha censurada
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getInt('userId');
    if (_userId != null) {
      await _fetchUserProfile(_userId!);
    }
  }

  Future<void> _fetchUserProfile(int userId) async {
    String url = "https://fasttec.com.br/animais/api/get_user.php";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: {'id': userId.toString()},
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          setState(() {
            _nome = responseBody['user']['nome'];
            _email = responseBody['user']['email'];
          });
        } else {
          // Handle the error message
          print(responseBody['message']);
        }
      } else {
        print('Failed to load profile data');
      }
    } catch (error) {
      print('Erro: $error');
    }
  }

  Future<void> _deleteUserProfile() async {
    String url = "https://fasttec.com.br/animais/api/delete_user.php";

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: {'id': _userId.toString()},
      );

      var responseBody = jsonDecode(response.body);

      if (responseBody['status'] == 'success') {
        // Exclusão bem-sucedida
        print('Perfil excluído com sucesso!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perfil excluído com sucesso!')),
        );
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else {
        print('Erro ao excluir perfil: ${responseBody['message']}');

        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } catch (error) {
      // Exibir mensagem de erro genérico
      print('Erro: $error');

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Nome: $_nome', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Email: $_email', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Senha: $_senha', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen(
                    nome: _nome,
                    email: _email,
                    userId: _userId,
                  )),
                ).then((_) => _loadUserData());
              },
              child: Text('Alterar Dados do Perfil'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showDeleteProfileDialog();
              },
              child: Text('Excluir Perfil'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Perfil'),
          content: Text('Você tem certeza que deseja excluir seu perfil?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () {
                _deleteUserProfile();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String nome;
  final String email;
  final int? userId;

  const EditProfileScreen({
    Key? key,
    required this.nome,
    required this.email,
    this.userId,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nome;
  late String _email;
  late String _senha;

  @override
  void initState() {
    super.initState();
    _nome = widget.nome;
    _email = widget.email;
    _senha = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alterar Dados do Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _nome,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira o nome';
                  }
                  return null;
                },
                onSaved: (value) => _nome = value!,
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira o email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Insira a senha';
                  }
                  return null;
                },
                onSaved: (value) => _senha = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _atualizarDadosPerfil();
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

  Future<void> _atualizarDadosPerfil() async {
    String url = "https://fasttec.com.br/animais/api/update_user.php";

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: {
          'id': widget.userId.toString(),
          'nome': _nome,
          'email': _email,
          'senha': _senha,
        },
      );

      var responseBody = jsonDecode(response.body);

      if (responseBody['status'] == 'success') {
        // Atualização bem-sucedida
        print('Dados do perfil atualizados com sucesso!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados do perfil atualizados com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        // Exibir mensagem de erro do servidor
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseBody['message'])),
        );
      }
    } catch (error) {
      // Exibir mensagem de erro genérico
      print('Erro: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar dados do perfil')),
      );
    }
  }
}
