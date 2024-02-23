import 'package:flutter/material.dart';
import 'package:pmsn2024/screens/dashboard_screen.dart';
import 'package:pmsn2024/screens/despensa_screen.dart';
import 'package:pmsn2024/screens/splash_screen.dart';
import 'package:pmsn2024/setting/app_value_notifier.dart';
import 'package:pmsn2024/setting/theme.dart';
import 'package:pmsn2024/screens/register_screen.dart';

void main() => runApp( MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppValueNotifier.banTheme,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: value 
            ? ThemeApp.darkTheme(context) 
            : ThemeApp.lightTheme(context),
          home: SplashScreen(),
          routes: {
            "/dash" : (BuildContext context) => DashboardScreen(),
            "/despensa" : (BuildContext context) => DespensaScreen(),
            "/registro" : (BuildContext context) => RegisterScreen(),
          },
        );
      }
    );
  }
}

/*class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int contador = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text(
              'Practica 1',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          drawer: Drawer(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              contador++;
              print(contador);
              setState((){});
            },
            
            child: Icon(Icons.ads_click),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.network('https://celaya.tecnm.mx/wp-content/uploads/2021/02/cropped-FAV.png',
                height: 250,
                ),
              ),
              Text('Valor del contador $contador')
            ],
          )),
    );
  }
}*/
