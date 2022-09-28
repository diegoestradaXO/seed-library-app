import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const blueColor = Color(0xFF8db2ba);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/heifer-logo.png',
            scale: 5,
            ), 
            // Text('Biblioteca Heifer')
          ],
        ),
        backgroundColor: blueColor,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido(a),',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                  Text(
                    'Selecciona un módulo!',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20, top: 30),
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFcfe9a2),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: blueColor,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xfff7b054),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
