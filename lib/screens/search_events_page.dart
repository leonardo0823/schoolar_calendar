// import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import '../components/bottom_sheet_add_event_widget.dart';
import '../components/dropdown_button_event_type.dart';
import '../components/dropdown_button_signature.dart';
import '../controllers/database_controller.dart';
import '../enums/event_type.dart';
import '../models/alarm.dart';
import '../models/event.dart';
import '../models/signature.dart';
// import '../utils/features_discoveries.dart';

class SearchEventsPage extends StatefulWidget {
  const SearchEventsPage({Key? key}) : super(key: key);

  @override
  State<SearchEventsPage> createState() => _SearchEventsPageState();
}

class _SearchEventsPageState extends State<SearchEventsPage> {
  late BuildContext cont;
  @override
  void initState() {
    // if (getShowDiscovery(keySearchEvents) ?? true) {
    //   SchedulerBinding.instance.addPostFrameCallback((Duration duration) =>
    //       showDiscovery(cont,
    //           listId: [kFeatureId8SearchEvents], key: keySearchEvents));
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      cont = context;
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          // buildWidget(
          //   context,
          //   featureId: kFeatureId8SearchEvents,
          //   tapTarget: const Icon(Icons.search),
          //   child:
          IconButton(
            onPressed: () {
              _showSearch(context);
            },
            icon: const Icon(Icons.search),
          ),
          // contentLocation: ContentLocation.trivial,
          //   title: 'Buscar Eventos',
          //   description: 'Pulse aquí para buscar un evento por nombre',
          // ),
        ],
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: CustomSearchDelegate(
        context,
        searchFieldStyle:
            TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
      ),
    );
  }
}

///[CustomSearchDelegate] clase para definir las búsquedas, su contenido y funcionamiento
///
///[events] lista de todos los eventos
///
///[signatures] lista de todas las asignaturas
class CustomSearchDelegate extends SearchDelegate {
  List<Event> events = [];
  List<Signature> signatures = [];

  BuildContext context;

  @override
  TextStyle? searchFieldStyle;

  CustomSearchDelegate(
    this.context, {
    this.searchFieldStyle,
  }) {
    getEvents();
    getSignatures();
  }

  ///[getEvents] método para cargar los eventos de la base de datos
  void getEvents() async {
    events = await databaseController.getEvents();
  }

  ///[getSignatures] método para cargar las asignaturas de la base de datos
  void getSignatures() async {
    signatures = await databaseController.getSignatures();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  TextInputAction get textInputAction => TextInputAction.search;

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Event> eventQuery = [];
    for (var event in events) {
      if (event.name.toLowerCase().contains(query.toLowerCase())) {
        eventQuery.add(event);
      }
    }
    if (eventQuery.isEmpty) {
      return Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No se han encontrado resultados.',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ));
    }
    return ListView.builder(
      itemCount: eventQuery.length,
      itemBuilder: (context, indexEvent) {
        var event = eventQuery[indexEvent];
        int indexSignature = signatures
            .indexWhere((signature) => signature.id == event.idSignature);
        var currentStartTime = DateTime(
            event.startTime.year, event.startTime.month, event.startTime.day);
        late DateTime lastStartTime;
        if (indexEvent != 0) {
          lastStartTime = DateTime(
              eventQuery[indexEvent - 1].startTime.year,
              eventQuery[indexEvent - 1].startTime.month,
              eventQuery[indexEvent - 1].startTime.day);
        }
        var signature = signatures[indexSignature];
        String textDate =
            "${DateFormat('EEEE, d ', 'es_ES').format(currentStartTime)}de${DateFormat(' MMMM ', 'es_ES').format(currentStartTime)}del${DateFormat(' y', 'es_ES').format(currentStartTime)}";
        if (currentStartTime.isAtSameMomentAs(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .subtract(const Duration(days: 1)))) {
          textDate = 'Ayer';
        } else if (currentStartTime.isAtSameMomentAs(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
          textDate = 'Hoy';
        } else if (currentStartTime.isAtSameMomentAs(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .add(const Duration(days: 1)))) {
          textDate = 'Mañana';
        }
        return ((indexEvent == 0)
                ? true
                : (!currentStartTime.isAtSameMomentAs(lastStartTime)))
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 20),
                    child: Text(
                      textDate,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                  ),
                  _buildListTile(context, signature, event),
                ],
              )
            : _buildListTile(context, signature, event);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Event> eventQuery = [];
    for (var event in events) {
      if (event.name.toLowerCase().contains(query.toLowerCase())) {
        eventQuery.add(event);
      }
    }
    if (eventQuery.isEmpty) {
      return Center(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'No se han encontrado resultados.',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            )),
      );
    }
    return ListView.builder(
      itemCount: eventQuery.length,
      itemBuilder: (context, indexEvent) {
        var event = eventQuery[indexEvent];
        int indexSignature = signatures
            .indexWhere((signature) => signature.id == event.idSignature);
        if (indexSignature < 0) return const Text('');
        var currentStartTime = DateTime(
            event.startTime.year, event.startTime.month, event.startTime.day);
        late DateTime lastStartTime;
        if (indexEvent != 0) {
          lastStartTime = DateTime(
              eventQuery[indexEvent - 1].startTime.year,
              eventQuery[indexEvent - 1].startTime.month,
              eventQuery[indexEvent - 1].startTime.day);
        }
        var signature = signatures[indexSignature];
        String textDate =
            "${DateFormat('EEEE, d ', 'es_ES').format(currentStartTime)}de${DateFormat(' MMMM ', 'es_ES').format(currentStartTime)}del${DateFormat(' y', 'es_ES').format(currentStartTime)}";
        if (currentStartTime.isAtSameMomentAs(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .subtract(const Duration(days: 1)))) {
          textDate = 'Ayer';
        } else if (currentStartTime.isAtSameMomentAs(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
          textDate = 'Hoy';
        } else if (currentStartTime.isAtSameMomentAs(DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .add(const Duration(days: 1)))) {
          textDate = 'Mañana';
        }
        return ((indexEvent == 0)
                ? true
                : (!currentStartTime.isAtSameMomentAs(lastStartTime)))
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 20),
                    child: Text(
                      textDate,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).textTheme.bodyLarge!.color),
                    ),
                  ),
                  _buildListTile(context, signature, event)
                ],
              )
            : _buildListTile(context, signature, event);
      },
    );
  }

  ListTile _buildListTile(
      BuildContext context, Signature signature, Event event) {
    return ListTile(
      onTap: () async {
        _showEvent(event, signature);
      },
      leading: Icon(
        Icons.circle,
        color: event.color,
      ),
      title: Text(
        event.name,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
      subtitle: Text(
        '${signature.name}\n${DateFormat('hh:mm a', 'es_ES').format(event.startTime)} - ${DateFormat('hh:mm a', 'es_ES').format(event.endTime)}',
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
    );
  }

  void _showEvent(Event event, Signature signature) async {
    Alarm? alarm = await databaseController.getAlarmById(event.id!);
    DropdownButtonEventTypeWidget.value = event.eventType.asString;
    DropdownButtonSignatureWidget.value = signature.name;

    await showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) => BottomSheetAddEventWidget(
        event: event,
        textAlarmDescription: alarm!.description,
      ),
      useRootNavigator: true,
      context: context,
      elevation: 40,
    );
  }
}
