import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Importa el package dialog_flowtter
import 'package:dialog_flowtter/dialog_flowtter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const blueColor = Color(0xFF8db2ba);
  final TextEditingController _userTextController = TextEditingController();

  /// Agrega una lista de tipo [Message]
  List<Message> messages = [];

  /// Crea la función sendMessage el cuál manejará
  /// la lógica de nuestros mensajes
  void sendMessage(String text) {
    // Verifica que el texto del usuario no esté vacío
    // si lo está, termina de ejecutar la función
    if (text.isEmpty) return;

    /// Añade nuestro texto enviado por el usuario en forma de
    /// [Message] a nuestra lista y actualiza el estado del widget
    setState(() {
      Message userMessage = Message(text: DialogText(text: [text]));
      messages.add(userMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/heifer-logo.png',
              scale: 5,
            ),
            // Text('Biblioteca Heifer')
          ],
        ),
        backgroundColor: blueColor,
      ),
      body: Column(
        children: [
          /// Esta parte se asegura que la caja de texto se posicione hasta abajo de la pantalla
          Expanded(
            child: Container(
              child: _MessagesList(messages: messages),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: blueColor,
            child: Row(
              children: [
                /// El Widget [Expanded] se asegura que el campo de texto ocupe
                /// toda la pantalla menos el ancho del [IconButton]
                Expanded(
                  child: TextField(
                      controller: _userTextController,
                      style: TextStyle(color: Colors.white)),
                ),
                IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.send),
                  onPressed: () {
                    /// Mandamos a llamar la función [sendMessage]
                    sendMessage(_userTextController.text);

                    /// Limpiamos nuestro campo de texto
                    _userTextController.clear();
                  },
                ),
              ],
            ), // Fin de la fila
          ), // Fin del contenedor
        ],
      ),
      //   body: SafeArea(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Container(
      //           margin: EdgeInsets.all(20),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Text(
      //                 'Bienvenido(a),',
      //                 style: const TextStyle(
      //                     fontWeight: FontWeight.bold, fontSize: 26),
      //               ),
      //               Text(
      //                 'Selecciona un módulo!',
      //                 style: const TextStyle(
      //                     fontWeight: FontWeight.bold, fontSize: 24),
      //               ),
      //             ],
      //           ),
      //         ),
      //         Center(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Container(
      //                 margin: EdgeInsets.only(bottom: 20, top: 30),
      //                 height: 150,
      //                 width: 200,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(10),
      //                   color: Color(0xFFcfe9a2),
      //                 ),
      //               ),
      //               Container(
      //                 margin: EdgeInsets.only(bottom: 20),
      //                 height: 150,
      //                 width: 200,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(10),
      //                   color: blueColor,
      //                 ),
      //               ),
      //               Container(
      //                 margin: EdgeInsets.only(bottom: 20),
      //                 height: 150,
      //                 width: 200,
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(10),
      //                   color: Color(0xfff7b054),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
    );
  }
}

/// Le agregamos el _ al principio del nombre para 
/// indicar que esta es una clase privada que sólo se 
/// usará dentro de este archivo
class _MessagesList extends StatelessWidget {
  /// El componente recibirá una lista de mensajes
  final List<Message> messages;

  const _MessagesList({
    Key? key,
    
    /// Le indicamos al componente que la lista estará vacía en
    /// caso de que no se le pase como argumento alguna otra lista
    this.messages = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Regresaremos una [ListView] con el constructor [separated]
    /// para que después de cada elemento agregue un espacio
    return ListView.separated(
      /// Indicamos el número de items que tendrá
      itemCount: messages.length,
      
      // Agregamos espaciado
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      
      /// Indicamos que agregue un espacio entre cada elemento
      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        return Container(
          /// Obtenemos el texto del mensaje y lo mostramos en un widget [Text]
          child: Text(messages[i]?.text?.text![0] ?? ''),
        );
      },
    );
  }
}

class _MessageContainer extends StatelessWidget {
  final Message message;
  final bool isUserMessage;

  const _MessageContainer({
    Key? key,
    
    /// Indicamos que siempre se debe mandar un mensaje
    required this.message,
    this.isUserMessage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      /// Cambia el lugar del mensaje
      mainAxisAlignment:
          isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          /// Limita nuestro contenedor a un ancho máximo de 250
          constraints: BoxConstraints(maxWidth: 250),
          child: Container(
            decoration: BoxDecoration(
              /// Cambia el color del contenedor del mensaje
              color: isUserMessage ? Colors.blue : Colors.orange,
              
              /// Le agrega border redondeados
              borderRadius: BorderRadius.circular(20),
            ),
            
            /// Espaciado
            padding: const EdgeInsets.all(10),
            child: Text(
              /// Obtenemos el texto del mensaje y lo pintamos. 
              /// Si es nulo, enviamos un string vacío.
              message?.text?.text![0] ?? '',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
