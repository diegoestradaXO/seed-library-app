import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Importa el package dialog_flowtter
import 'package:dialog_flowtter/dialog_flowtter.dart';

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${this.substring(1)}";
    }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DialogFlowtter _dialogFlowtter;
  static const blueColor = Color(0xFF8db2ba);
  final TextEditingController _userTextController = TextEditingController();
  
  /// Creamos una instancia de DialogFlowtter en nuestra clase


  /// Agrega una lista de tipo [Message]
  List<Map<String, dynamic>> messages = [];
  void addMessage(Message message, [bool isUserMessage = false]) {
    if(message.text?.text![0] == ''){
      message.text?.text![0] = 'Lo lamento, no pude entender';
    }
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }

  /// Crea la función sendMessage el cuál manejará
  /// la lógica de nuestros mensajes
  void sendMessage(String text) async {
    if (text.isEmpty) return;
    setState(() {
      Message userMessage = Message(text: DialogText(text: [text]));
      addMessage(userMessage, true);
    });

    /// Creamos la [query] que le enviaremos al agente
    /// a partir del texto del usuario
    QueryInput query = QueryInput(text: TextInput(text: text));

    /// Esperamos a que el agente nos responda
    /// El keyword [await] indica a la función que espere a que [detectIntent]
    /// termine de ejecutarse para después continuar con lo que resta de la función
    DetectIntentResponse res = await _dialogFlowtter.detectIntent(
      queryInput: query,
    );

    /// Si el mensaje de la respuesta es nulo, no continuamos con la ejecución
    /// de la función
    if (res.message == null) return;
    print(res.message!.text?.text![0]);
    /// Si hay un mensaje de respuesta, lo agregamos a la lista y actualizamos
    /// el estado de la app
    setState(() {
      addMessage(res.message!);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    DialogFlowtter.fromFile().then((value) => _dialogFlowtter = value);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: blueColor,
      appBar: AppBar(
        elevation: 0,
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
              decoration: const BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: const Radius.circular(40), topRight: const Radius.circular(40))
              ),
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
    );
  }
}

/// Le agregamos el _ al principio del nombre para
/// indicar que esta es una clase privada que sólo se
/// usará dentro de este archivo
class _MessagesList extends StatelessWidget {
  /// El componente recibirá una lista de mensajes
  final List<Map<String, dynamic>> messages;

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

      separatorBuilder: (_, i) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        
        /// Obtenemos el objecto actual
        var obj = messages[messages.length - 1 - i];
        return _MessageContainer(
          
          /// Obtenemos el mensaje del objecto actual
          message: obj['message'],
          
          /// Diferenciamos si es un mensaje o una respuesta
          isUserMessage: obj['isUserMessage'],
        );
      },
      reverse: true,
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
              color: isUserMessage ? _HomePageState.blueColor : Colors.orange,

              /// Le agrega border redondeados
              borderRadius: BorderRadius.circular(20),
            ),

            /// Espaciado
            padding: const EdgeInsets.all(10),
            child: Text(
              /// Obtenemos el texto del mensaje y lo pintamos.
              /// Si es nulo, enviamos un string vacío.
              /// 
            (message.text?.text![0] ?? '¿Podrías intentar de nuevo?').split('|').length == 2  
            && isUserMessage == false ? 'El módulo que buscas es el de ' 
            +(message.text?.text![0].split("|")[0] ?? '¿Podrías intentar de nuevo?') 
            +', y la sección es la de ' + (message.text?.text![0].split("|")[1] ?? 
            '¿Podrías intentar de nuevo?') + '.': message.text?.text![0] ?? '¿Podrías intentar de nuevo?' ,
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