import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Sobre o Aplicativo', style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text(
              'Este aplicativo foi desenvolvido para a apresentação e demonstração '
                  'para o TCC da Fatec - Jundiaí do curso de Análise e Desenvolvimento '
                  'de Sistemas.\n\n'
                  'Desenvolvido por:\n'
                  'Nathália Araujo\n'
                  'Vitor Fernandes\n'
                  'Juan Moura\n'
                  'Luan Araújo',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
