import 'package:ertaklaraudio/data/cubit/male_cubit.dart';
import 'package:ertaklaraudio/data/cubit/saveItem_cubit.dart';
import 'package:ertaklaraudio/view/screens/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.brown,
      title: 'Ertaklar Audio',
      home: MultiBlocProvider(
        providers: [
          BlocProvider<MaleCubit>(
            create: (context) => MaleCubit(),
          ),
          BlocProvider<SaveItemCubit>(
            create: (context) => SaveItemCubit(),
          ),
        ],
        child: const BottomNawBar(),
      ),
    );
  }
}


