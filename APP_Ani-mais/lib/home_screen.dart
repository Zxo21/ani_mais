import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phploginflutter/pet/profilepet_screen.dart';
import 'package:phploginflutter/pet/registerpet_screen.dart'; // Import RegisterPetScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _pets = [];
  int? userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUserId();
    if (userId != null) {
      await _loadPets();
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  Future<void> _loadPets() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (userId != null) {
        final url = 'https://fasttec.com.br/animais/api/get_pets_by_userid.php';
        final response = await http.post(
          Uri.parse(url),
          body: {'id': userId.toString()},
        );

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          if (jsonData['status'] == 'success') {
            setState(() {
              _pets = jsonData['data'];
            });
          } else {
            print('Erro ao carregar pets: ${jsonData['message']}');
          }
        } else {
          print('Falha ao carregar pets: ${response.statusCode}');
        }
      } else {
        print('ID do usuário não encontrado no SharedPreferences');
      }
    } catch (e) {
      print('Erro: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _pets.isEmpty
          ? Center(child: Text('Nenhum pet encontrado'))
          : ListView.builder(
        itemCount: _pets.length,
        itemBuilder: (context, index) {
          final pet = _pets[index];
          return ListTile(
            title: Text(pet['nome']),
            subtitle: Text(pet['raca']),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PetProfileScreen(petId: pet['id']),
                ),
              );

              if (result == true) {
                await _loadPets();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (userId != null) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegisterPetScreen(userId: userId!),
              ),
            );

            if (result == true) {
              await _loadPets();
            }
          } else {
            print('Usuário não encontrado');
          }
        },
        tooltip: 'Adicionar',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
