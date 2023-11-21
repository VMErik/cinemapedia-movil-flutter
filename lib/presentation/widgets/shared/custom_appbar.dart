import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final  titleStyle =Theme.of(context).textTheme.titleMedium;

    // Incluimos el safe area para no dejarl tan pegado arriba
    return SafeArea(
      child: Padding(
        
        padding: const EdgeInsets.symmetric(horizontal: 10), 
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(Icons.movie_outlined , color: colors.primary,) , 
              const SizedBox(width: 5,) , 
              Text('Cinemapedia' , style: titleStyle,),
              const Spacer(), // Este widget, rellena todo el espaci disponible
              IconButton(
                onPressed: (){}, 
                icon: const Icon(Icons.search)
              )
            ],
          ),
        ),
      ),
    );
  }
}