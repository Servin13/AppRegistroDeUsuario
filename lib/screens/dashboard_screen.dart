import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:pmsn2024/setting/app_value_notifier.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'), backgroundColor: Colors.green),
      drawer: Drawer(
        //menu de hamburguesa
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    NetworkImage('https://i.pravatar.cc/150?img=14'),
              ),
              accountName: Text('Juan Angel Nuñez Servin'),
              accountEmail: Text('20030367@itcelaya.edu.mx'),
            ),
            const ListTile(
              leading: Icon(Icons.phone),
              title: Text("Practica 1"),
              subtitle: Text("Aqui va la descripción "),
              trailing: Icon(Icons.chevron_right),
            ),
            // ListTile(
            //   leading: const Icon(Icons.app_registration),
            //   title: const Text("Registrar usuario "),
            //   subtitle:
            //       const Text("Pantalla personalizada de registro de usuarios"),
            //   trailing: const Icon(Icons.chevron_right),
            //   onTap: () => Navigator.pushNamed(context, "/register_screen"),
            // ),
            ListTile(
              leading: Icon(Icons.shop),
              title: Text("Mi despensa "),
              subtitle: Text("Relacion de productos que no voy a usar"),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/despensa"),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text("Movies"),
              subtitle: Text("Consulta peliculas populares"),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/movies"),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Favorites Movies"),
              subtitle: Text("Consulta las peliculas favoritas"),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/favorites"),
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text("Salir"),
              subtitle: Text("Adiós!!"),
              trailing: Icon(Icons.chevron_right),
              onTap: () => {Navigator.pop(context), Navigator.pop(context)},
            ),

            DayNightSwitcherIcon(
              isDarkModeEnabled: AppValueNotifier.banTheme.value,
              onStateChanged: (isDarkModeEnabled) {
                AppValueNotifier.banTheme.value = isDarkModeEnabled;
              },
            ),
          ],
        ),
      ),
    );
  }
}