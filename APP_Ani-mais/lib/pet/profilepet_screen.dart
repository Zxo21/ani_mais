import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:phploginflutter/pet/addcomorbity_screen.dart';
import 'package:phploginflutter/pet/addmedication_screen.dart';
import 'package:phploginflutter/pet/addvaccination_screen.dart';
import 'package:phploginflutter/pet/editcomorbity_screen.dart';
import 'package:phploginflutter/pet/editmedication_screen.dart';
import 'package:phploginflutter/pet/editvaccination_screen.dart';
import 'package:phploginflutter/pet/editpet_screen.dart';

class PetProfileScreen extends StatefulWidget {
  final int petId;

  PetProfileScreen({required this.petId});

  @override
  _PetProfileScreenState createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _racaController;
  late TextEditingController _chipController;
  late TextEditingController _sexoController;
  late TextEditingController _especieController;
  late TextEditingController _dataNascimentoController;
  late TextEditingController _fotoController;

  List<Comorbidity> _comorbidades = [];
  List<Medication> _medications = [];
  List<Vaccination> _vaccinations = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _racaController = TextEditingController();
    _chipController = TextEditingController();
    _sexoController = TextEditingController();
    _especieController = TextEditingController();
    _dataNascimentoController = TextEditingController();
    _fotoController = TextEditingController();

    _fetchPetData();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _racaController.dispose();
    _chipController.dispose();
    _sexoController.dispose();
    _especieController.dispose();
    _dataNascimentoController.dispose();
    _fotoController.dispose();
    super.dispose();
  }

  Future<void> _fetchPetData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://fasttec.com.br/animais/api/get_pet_data.php?petId=${widget.petId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final pet = data['data']['pet'];
          print('Pet Data: $pet'); // Debug print
          print('Comorbidities: ${data['data']['comorbidities']}'); // Debug print
          print('Medications: ${data['data']['medications']}'); // Debug print
          print('Vaccinations: ${data['data']['vaccinations']}'); // Debug print

          setState(() {
            _nomeController.text = pet['nome'];
            _racaController.text = pet['raca'];
            _chipController.text = pet['numChip'];
            _sexoController.text = pet['genero'];
            _especieController.text = pet['especie']; // Assuming 'Cachorro' as the species
            _dataNascimentoController.text = pet['dataNasc'];
            _fotoController.text = pet['foto'];
            if (_fotoController.text == null && _fotoController.text.isEmpty) {
            _fotoController.text = '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';
            }

             _comorbidades = (data['data']['comorbidities'] as List).map((e) {
              if (e is String) {
                return Comorbidity(id: 0, name: e);
              } else
              if (e is Map && e.containsKey('id') && e.containsKey('name')) {
                return Comorbidity(
                    id: int.tryParse(e['id'].toString()) ?? 0,
                    name: e['name']
                );
              } else {
                print('Invalid comorbidity data: $e'); // Debug invalid data
                return Comorbidity(id: 0, name: 'Unknown');
              }
            }).toList();

            _medications = (data['data']['medications'] as List).map((e) {
              if (e is Map && e.containsKey('name') &&
                  e.containsKey('dosage') && e.containsKey('frequency')) {
                return Medication(
                  id: 0, // Assuming id is not provided in the data
                  name: e['name'],
                  dosage: e['dosage'],
                  frequency: e['frequency'],
                );
              } else {
                print('Invalid medication data: $e'); // Debug invalid data
                return Medication(id: 0,
                    name: 'Unknown',
                    dosage: 'Unknown',
                    frequency: 'Unknown');
              }
            }).toList();

            _vaccinations = (data['data']['vaccinations'] as List).map((e) {
              if (e is String) {
                return Vaccination(id: 0, name: e);
              } else
              if (e is Map && e.containsKey('id') && e.containsKey('name')) {
                return Vaccination(
                    id: int.tryParse(e['id'].toString()) ?? 0,
                    name: e['name']
                );
              } else {
                print('Invalid vaccination data: $e'); // Debug invalid data
                return Vaccination(id: 0, name: 'Unknown');
              }
            }).toList();

            _isLoading = false;
          });
        } else {
          // Handle response error
          print('Failed to load pet data: ${data['message']}');
        }
      } else {
        // Handle request error
        print('Failed to load pet data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any other exceptions
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Perfil do Pet'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil do Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pet photo and share button
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: MemoryImage(base64Decode(_fotoController.text)),
                        fit: BoxFit.cover, // Ajuste da imagem dentro do container
                      ),
                    ),
                  ),

                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Link do pet'),
                            content: SelectableText(
                                'https://fasttec.com.br/animais/pet.php?id=${widget
                                    .petId}',
                              style: TextStyle(
                                color: Colors.blue, // Altere a cor do link conforme necessário
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Fechar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(Icons.share),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Pet information
              _buildInfoRow('Nome', _nomeController.text),
              _buildInfoRow('Raça', _racaController.text),
              _buildInfoRow('Chip', _chipController.text),
              _buildInfoRow('Sexo', _sexoController.text),
              _buildInfoRow('Espécie', _especieController.text),
              _buildInfoRow(
                  'Data de Nascimento', _dataNascimentoController.text),
              SizedBox(height: 20),
              // Action buttons
              _buildActionButtons(),
              SizedBox(height: 20),
              // Comorbidities
              _buildSectionTitle('Comorbidades'),
              _buildComorbitiesList(),
              _buildAddButton('Adicionar Comorbidade',
                  AddComorbidityScreen(petId: widget.petId)),
              SizedBox(height: 20),
              // Medication
              _buildSectionTitle('Medicação'),
              _buildMedicationsList(),
              _buildAddButton('Adicionar Medicação',
                  AddMedicationScreen(petId: widget.petId)),
              SizedBox(height: 20),
              // Vaccinations
              _buildSectionTitle('Vacinação'),
              _buildVaccinationsList(),
              _buildAddButton('Adicionar Vacinação',
                  AddVaccinationScreen(petId: widget.petId)),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAddButton(String label, Widget destination) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Text(label),
    );
  }


  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditPetScreen(petId: widget.petId),
              ),
            );
          },
          child: Text('Editar Perfil'),
        ),
        ElevatedButton(
          onPressed: () {
            _deletePet(); // Call delete function
          },
          child: Text('Excluir pet'),
        ),
      ],
    );
  }

  Future<void> _deletePet() async {
    try {
      final response = await http.post(
        Uri.parse('https://fasttec.com.br/animais/api/delete_pet.php'),
        body: {
          'petId': widget.petId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // Pet deletion successful, navigate back to previous screen or perform appropriate action
          Navigator.pop(context);
        } else {
          // Handle deletion failure
          print('Failed to delete pet: ${data['message']}');
          Navigator.pop(context, true);
        }
      } else {
        // Handle request error
        print('Failed to delete pet: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete pet: ${response.reasonPhrase}'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Handle any other exceptions
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildComorbitiesList() {
    return Column(
      children: _comorbidades.map((comorbidity) {
        return ListTile(
          title: Text('${comorbidity.name} (ID: ${comorbidity.id})'),
          trailing: _buildActionButtonsForItem(
                () => _deleteComorbidity(comorbidity.id),
            EditComorbidityScreen(id: comorbidity.id, nome: comorbidity.name),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMedicationsList() {
    return Column(
      children: _medications.map((medication) {
        return ListTile(
          title: Text('${medication.name} (ID: ${medication.id})'),
          subtitle: Text('${medication.dosage} | ${medication.frequency}'),
          trailing: _buildActionButtonsForItem(
                () => _deleteMedication(medication.id),
            EditMedicationScreen(
                id: medication.id, nome: medication.name, observacao: ''),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVaccinationsList() {
    return Column(
      children: _vaccinations.map((vaccination) {
        return ListTile(
          title: Text('${vaccination.name} (ID: ${vaccination.id})'),
          trailing: _buildActionButtonsForItem(
                () => _deleteVaccination(vaccination.id),
            EditVaccinationScreen(id: vaccination.id),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtonsForItem(VoidCallback onDelete, Widget destination) {
    return SizedBox(
      width: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => destination),
                );
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(80, 36)),
              ),
              child: Icon(Icons.update),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: onDelete,
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(80, 36)),
              ),
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteComorbidity(int comorbidityId) async {
    try {
      final response = await http.post(
        Uri.parse('https://fasttec.com.br/animais/api/delete_comorbidity.php'),
        body: {
          'comorbidityId': comorbidityId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // Remove the comorbidity from the list
          setState(() {
            _comorbidades.removeWhere((comorbidity) =>
            comorbidity.id == comorbidityId);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Comorbidade deletada com sucesso.'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          print('Failed to delete comorbidity: ${data['message']}');
          setState(() {
            _comorbidades.removeWhere((comorbidity) =>
            comorbidity.id == comorbidityId);
          });
        }
      } else {
        // Handle request error
        print('Failed to delete comorbidity: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to delete comorbidity: ${response.reasonPhrase}'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Handle any other exceptions
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _deleteMedication(int medicationId) async {
    try {
      final response = await http.post(
        Uri.parse('https://fasttec.com.br/animais/api/delete_medication.php'),
        body: {
          'medicationId': medicationId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // Remove the medication from the list
          setState(() {
            _medications.removeWhere((medication) =>
            medication.id == medicationId);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Medicação deletada com sucesso.'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          // Handle deletion failure
          print('Failed to delete medication: ${data['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete medication: ${data['message']}'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Handle request error
        print('Failed to delete medication: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to delete medication: ${response.reasonPhrase}'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Handle any other exceptions
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _deleteVaccination(int vaccinationId) async {
    try {
      final response = await http.post(
        Uri.parse('https://fasttec.com.br/animais/api/delete_vaccination.php'),
        body: {
          'vaccinationId': vaccinationId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          // Remove the vaccination from the list
          setState(() {
            _vaccinations.removeWhere((vaccination) =>
            vaccination.id == vaccinationId);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Vacinação deletada com sucesso.'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          // Handle deletion failure
          print('Failed to delete vaccination: ${data['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete vaccination: ${data['message']}'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Handle request error
        print('Failed to delete vaccination: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to delete vaccination: ${response.reasonPhrase}'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Handle any other exceptions
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
class Comorbidity {
  final int id;
  final String name;

  Comorbidity({
    required this.id,
    required this.name,
  });
}

class Medication {
  final int id;
  final String name;
  final String dosage;
  final String frequency;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
  });
}

class Vaccination {
  final int id;
  final String name;

  Vaccination({
    required this.id,
    required this.name,
  });
}
