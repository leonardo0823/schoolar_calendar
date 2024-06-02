import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/home_page.dart';
import '../screens/search_events_page.dart';
import '../screens/signatures_details_page.dart';
import '../utils/features_discoveries.dart';

class DrawerApp extends StatelessWidget {
  const DrawerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/drawer_header.jpg'),
                  fit: BoxFit.cover),
            ),
            child: ListTile(
              title: Text(''),
            ),
          ),
          ListTile(
            title: const Text(
              'Ver Asignaturas',
            ),
            leading: const Icon(
              Icons.class_outlined,
            ),
            onTap: () {
              Get.offAll(() => SignaturesDetailsPage());
            },
          ),
          ListTile(
            title: const Text(
              'Buscar Eventos',
            ),
            leading: const Icon(Icons.search_outlined),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => SearchEventsPage());
            },
          ),
          ListTile(
            title: const Text(
              'Reiniciar tutoriales',
            ),
            leading: const Icon(
              Icons.help_outline_outlined,
            ),
            onTap: () {
              //Reinicia el tutorial de cada pantalla
              setShowDiscovery(true, keyHome);
              setShowDiscovery(true, keyAddEvent);
              setShowDiscovery(true, keyViewSignatures);
              setShowDiscovery(true, keyDeleteEvent);
              setShowDiscovery(true, keySearchEvents);
              Get.offAll(() => const MyHomePage());
            },
          ),
          AboutListTile(
            applicationName: 'Eventos Escolares',
            applicationVersion: '1.0.0',
            applicationIcon: Image.asset(
              'assets/images/icon.png',
              scale: 2,
            ),
            aboutBoxChildren: const [
              Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                        child: Text(
                      'Autores:',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    )),
                    WidgetSpan(
                      child: Text(
                        'Leonardo Alain Moreira Rodríguez\nAlexis Manuel Hurtado García',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                        child: Text(
                      'Tutor:',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    )),
                    WidgetSpan(
                      child: Text(
                        'Ing. Alfredo Rafael Espinosa Palenque',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            icon: const Icon(
              Icons.info_outline,
            ),
            child: const Text(
              'Sobre Eventos Escolares',
            ),
          ),
        ],
      ),
    );
  }
}
