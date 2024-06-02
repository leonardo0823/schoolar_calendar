// import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
// import 'package:klocalizations_flutter/klocalizations_flutter.dart';
import 'controllers/database_controller.dart';
import 'screens/home_page.dart';
import 'themes/theme.dart';
import 'utils/features_discoveries.dart';

///[MyApp] clase que contiene a la aplicación
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Este widget es la raíz de la aplicación.
  @override
  Widget build(BuildContext context) {
    initPreferences(); //Iniciando las preferencias compartidas para poder guardar configuraciones de la app
    databaseController.init(); //Iniciando la base de datos

    return FutureBuilder(
        future: Init.instance.initialize(),
        builder: (context, AsyncSnapshot snapshot) {
          // Muestra una pantalla de carga mientras espera que carguen los recursos de la app:
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(home: Splash());
          } else {
            // Cuando termina de cargar, retorna la app:
            return
                // FeatureDiscovery(
                // child:
                GetMaterialApp(
              title: 'Flutter Demo',
              theme: dark,
              debugShowCheckedModeBanner: false,
              locale: const Locale(
                // Idioma de la app configurado al Español
                'es',
                'ES',
              ),
              supportedLocales: const [
                // Idiomas soportados por la app
                Locale(
                  'es',
                  'ES',
                ),
                Locale('en', 'US'),
              ],
              localizationsDelegates: //[
                  FlutterLocalization.instance.localizationsDelegates,
              //GlobalMaterialLocalizations.delegates,
              //   GlobalWidgetsLocalizations.delegate,
              // ],
              home: const MyHomePage(), // pantalla principal de la aplicación
              // getPages: [
              //   GetPage(name: '/', page: () => MyHomePage()),
              //   GetPage(
              //       name: '/signatures_details',
              //       page: () => SignaturesDetailsPage()),
              // ],
              // initialRoute: '/',
              // onGenerateRoute: (settings) {
              //   return MaterialPageRoute(
              //     builder: (context) {
              //       switch (settings.name) {
              //         case '/':
              //           return MyHomePage();
              //         case '/add_event':
              //           return BottomSheetAddEventWidget();
              //       }
              //       return const AlertDialog(
              //         title: Text(
              //           "Page not found!",
              //           textAlign: TextAlign.center,
              //         ),
              //         titleTextStyle: TextStyle(
              //           color: Colors.red,
              //           wordSpacing: 2,
              //           letterSpacing: 2,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       );
              //     },
              //   );
              //},
            );
            // );
          }
        });
  }
}

///[Splash] pantalla de carga de la app
class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06296B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/icon256x256.png'),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Eventos Escolares',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const Text(
              'Versión 1.0.0',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  ///[initialize]
  ///Aquí es donde se inician los recursos necesarios de la app mientras la pantalla [Splash] está desplegada.
  Future initialize() async {
    await Future.delayed(const Duration(seconds: 3));
  }
}
