import 'package:flutter/material.dart';

class FullScreenloader extends StatelessWidget {
  const FullScreenloader({super.key});



  Stream<String> getLoadingMessages (){

    final  messages = <String>[
      "Cargando peliculas",
      "Cargando populares",
      "Cargando siguientes estrenos", 
      "Cargando el top rated",
      "Esto esta tardando mas de lo esperado! :("
    ];


    return Stream.periodic(const Duration(milliseconds: 1200) , (step){
      return messages[step];
    }).take(messages.length); // COn el take, solo tomamos o ejecutamos la cantidad de elementos que haya
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Espere por favor'),
          SizedBox(height: 10,) , 
          const CircularProgressIndicator(strokeWidth: 2,) , 
          SizedBox(height: 10,) , 
          StreamBuilder(
            stream: getLoadingMessages(), 
            builder: (context, snapshot){
              if(!snapshot.hasData) return const Text('Cargando');
              return Text(snapshot.data!); // Retornamos el snapshot
            }
          )
        ],
      ),
    );
  }
}