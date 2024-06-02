import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import '../controllers/database_controller.dart';
import '../screens/home_page.dart';
import '../screens/signatures_details_page.dart';
import 'bottom_sheet_add_event_widget.dart';
import 'dialog_signature_widget.dart';

class FloatingActionButtonSpeedDial extends StatefulWidget {
  const FloatingActionButtonSpeedDial({Key? key}) : super(key: key);

  @override
  State<FloatingActionButtonSpeedDial> createState() =>
      _FloatingActionButtonSpeedDialState();
}

class _FloatingActionButtonSpeedDialState
    extends State<FloatingActionButtonSpeedDial> {
  bool hasSignatures = true;

  @override
  void initState() {
    super.initState();
    loadState();
  }

  void loadState() async {
    var checkHasSignatures = await databaseController.hasSignatures();
    setState(() {
      hasSignatures = checkHasSignatures;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        activeBackgroundColor: Colors.red,
        overlayColor: Theme.of(context).colorScheme.surface,
        overlayOpacity: 0.5,
        spacing: 5,
        spaceBetweenChildren: 15,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          if (hasSignatures)
            SpeedDialChild(
              backgroundColor: Theme.of(context).textTheme.bodyLarge!.color,
              child: const Icon(
                Icons.add_alarm_outlined,
              ),
              label: 'Añadir Evento',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.surface,
              ),
              labelBackgroundColor:
                  Theme.of(context).textTheme.bodyLarge!.color,
              foregroundColor: Theme.of(context).colorScheme.surface,
              onTap: () => showModalBottomSheet(
                  isScrollControlled: true,
                  enableDrag: true,
                  // transitionAnimationController: AnimationController(
                  //     vsync: AnimatedListState(),
                  //     duration: const Duration(milliseconds: 500)),
                  elevation: 10,
                  context: context,
                  builder: (context) => const BottomSheetAddEventWidget()),
            ),
          SpeedDialChild(
            backgroundColor: Theme.of(context).textTheme.bodyLarge!.color,
            child: const Icon(
              Icons.add,
            ),
            label: 'Agregar Asignatura',
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.surface,
            ),
            labelBackgroundColor: Theme.of(context).textTheme.bodyLarge!.color,
            foregroundColor: Theme.of(context).colorScheme.surface,
            onTap: _showDialogAddSignature,
          ),
          SpeedDialChild(
            backgroundColor: Theme.of(context).textTheme.bodyLarge!.color,
            child: const Icon(
              Icons.class_outlined,
            ),
            label: 'Ver Asignaturas',
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.surface,
            ),
            labelBackgroundColor: Theme.of(context).textTheme.bodyLarge!.color,
            foregroundColor: Theme.of(context).colorScheme.surface,
            onTap: () {
              Get.offAll(() => SignaturesDetailsPage());
            },
          ),
        ]);
  }

  void _showDialogAddSignature() {
    showDialog(
        context: context,
        builder: (BuildContext context) => DialogSignatureWidget(
              page: const MyHomePage(),
            ));
  }
}
