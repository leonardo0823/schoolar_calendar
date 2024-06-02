import 'dart:io';

// import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../api/notification_api.dart';
import '../components/bottom_sheet_add_event_widget.dart';
import '../components/drawer_app.dart';
import '../components/dropdown_button_event_type.dart';
import '../components/dropdown_button_signature.dart';
import '../components/floating_action_button_speed_dial.dart';
import '../controllers/database_controller.dart';
import '../enums/event_type.dart';
import '../models/alarm.dart';
import '../models/event.dart';
import '../models/signature.dart';
// import '../utils/features_discoveries.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CalendarController _calendarController;
  late final List<Appointment> _appointments;
  late BuildContext cont;
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  bool hasEvents = false;

  @override
  void initState() {
    // if (getShowDiscovery(keyHome) ?? true) {
    //   SchedulerBinding.instance.addPostFrameCallback((Duration duration) =>
    //       showDiscovery(cont,
    //           listId: [kFeatureId1DeleteAllEvents], key: keyHome));
    // }
    super.initState();
    loadState();
    _appointments = [];
    _calendarController = CalendarController();

    if (!Platform.isWindows) {
      NotificationApi.init();
      listenNotifications();
    }
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) {}

  void loadState() async {
    List<Event> events = await databaseController.getEvents();
    var checkHasEvents = await databaseController.hasEvents();

    setState(() {
      hasEvents = checkHasEvents;
    });

    events.forEach((event) async {
      Signature? signature =
          await databaseController.getSignatureById(event.idSignature!);

      setState(() {
        _addAppointment(Appointment(
          id: event.id,
          startTime: event.startTime,
          endTime: event.endTime,
          color: event.color,
          subject: signature!.symbology,
          notes: event.startTime.toString(),
        ));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const iconDelete = Icon(Icons.delete);
    setState(() {
      cont = context;
    });
    return SafeArea(
      top: false,
      child: Scaffold(
        key: _scaffoldState,
        appBar: AppBar(
          actions: [
            // buildWidget(
            //   context,
            //   child:
            IconButton(
              icon: iconDelete,
              onPressed: hasEvents
                  ? () async {
                      _showDialogDeleteAllEvents(context);
                    }
                  : null,
            ),
            // featureId: kFeatureId1DeleteAllEvents,
            // tapTarget: iconDelete,
            // contentLocation: ContentLocation.below,
            // title: 'Eliminar',
            // description: 'Pulse aquí si desea eliminar todos los eventos',
            // ),
          ],
          title: const Text(
            'Eventos Escolares',
            style: TextStyle(fontSize: 18),
          ),
        ),
        drawer: const DrawerApp(),
        body: SfCalendar(
          monthViewSettings: MonthViewSettings(
            agendaStyle: AgendaStyle(
              dateTextStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                locale: const Locale('es_ES'),
              ),
              dayTextStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                locale: const Locale('es_ES'),
              ),
            ),
            showAgenda: true,
            showTrailingAndLeadingDates: true,
            appointmentDisplayCount: 10,
            monthCellStyle: MonthCellStyle(
              leadingDatesTextStyle: TextStyle(
                color: Colors.grey[600],
                locale: const Locale('es_ES'),
              ),
              textStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                locale: const Locale('es_ES'),
              ),
            ),
          ),
          scheduleViewSettings: ScheduleViewSettings(
            monthHeaderSettings: MonthHeaderSettings(
              monthTextStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                locale: const Locale('es_ES'),
              ),
            ),
            weekHeaderSettings: WeekHeaderSettings(
              backgroundColor: Colors.black26,
              weekTextStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                locale: const Locale('es_ES'),
              ),
            ),
          ),
          allowDragAndDrop: true,
          onDragEnd: _onDragEnd,
          viewHeaderStyle: ViewHeaderStyle(
            dateTextStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              locale: const Locale('es_ES'),
            ),
            dayTextStyle:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
          todayHighlightColor: Theme.of(context).primaryColor.withBlue(170),
          cellBorderColor: const Color(0xFF373739),
          headerStyle: CalendarHeaderStyle(
            backgroundColor: Theme.of(context).highlightColor,
            textStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          weekNumberStyle: WeekNumberStyle(
            backgroundColor: Theme.of(context).highlightColor,
            textStyle:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
          ),
          view: CalendarView.week,
          allowViewNavigation: true,
          allowedViews: const <CalendarView>[
            CalendarView.week,
            CalendarView.workWeek,
            CalendarView.month,
          ],
          showCurrentTimeIndicator: true,
          dataSource: MeetingDataSource(_appointments),
          appointmentBuilder: _appointmentBuilder,
          viewNavigationMode: ViewNavigationMode.snap,
          showWeekNumber: true,
          showDatePickerButton: true,
          controller: _calendarController,
          firstDayOfWeek: 1,
          allowAppointmentResize: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          timeSlotViewSettings: const TimeSlotViewSettings(
            endHour: 24,
            timeIntervalHeight: 80,
            timeFormat: 'h:mm a',
            dateFormat: 'd',
            dayFormat: 'EEE',
            timeTextStyle: TextStyle(
              color: Color(0xFF666666),
              fontSize: 12,
            ),
            timeRulerSize: 80,
          ),
          todayTextStyle:
              TextStyle(color: Theme.of(context).colorScheme.surface),
        ),
        floatingActionButton: const FloatingActionButtonSpeedDial(),
      ),
    );
  }

  void _showDialogDeleteAllEvents(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              '¿Desea eliminar todos los eventos?',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.warning_amber_outlined,
                              ),
                              title: Text(
                                'Nota: Al eliminar todos los eventos todas las alarmas serán eliminadas',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                              onPressed: () async {
                                await databaseController.deleteAllEvents();
                                if (!Platform.isWindows) {
                                  NotificationApi.cancelAll();
                                }
                                Get.offAll(() => const MyHomePage());
                              },
                              child: const Text(
                                'Aceptar',
                                style: TextStyle(fontSize: 18),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(fontSize: 18),
                              ))
                        ],
                      )
                    ],
                  )
                ],
              ),
            ));
  }

  void _onDragEnd(appointmentDragEndDetails) async {
    Appointment appointment =
        appointmentDragEndDetails.appointment as Appointment;
    Event? event = await databaseController.getEventById(appointment.id as int);
    if (!Platform.isWindows) {
      NotificationApi.cancel(event!.idAlarm!);
      NotificationApi.cancel((event.idAlarm! * -1) - 1);
    }

    Alarm? alarm = await databaseController.getAlarmById(event!.idAlarm!);
    bool isUpdated = await databaseController.updateEventStartTimeById(
        event: event, startTime: appointmentDragEndDetails.droppingTime!);
    if (appointmentDragEndDetails.droppingTime!.isAfter(DateTime.now()) &&
        !Platform.isWindows) {
      await NotificationApi.showScheduledNotification(
        id: event.idAlarm!,
        title: event.name,
        body: alarm!.description!,
        payload: event.name,
        scheduledDate: appointmentDragEndDetails.droppingTime!,
        sound: 'alarm.wav',
      );
    }
    if (isUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Evento modificado satisfactoriamente'),
        ),
      );
    }
  }

  Widget _appointmentBuilder(BuildContext context,
      CalendarAppointmentDetails calendarAppointmentDetails) {
    if (calendarAppointmentDetails.isMoreAppointmentRegion) {
      return Container(
        color: Colors.red,
        width: calendarAppointmentDetails.bounds.width,
        height: calendarAppointmentDetails.bounds.height,
        child: const Text('+More'),
      );
    } else if (_calendarController.view == CalendarView.month) {
      final Appointment appointment =
          calendarAppointmentDetails.appointments.first;
      return Container(
          decoration: BoxDecoration(
            color: appointment.color,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          ),
          alignment: Alignment.center,
          child: appointment.isAllDay
              ? Text(
                  appointment.subject,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(appointment.subject,
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 10)),
                    Text(
                        '${DateFormat('hh:mm a').format(appointment.startTime)} - ${DateFormat('hh:mm a').format(appointment.endTime)}',
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 10))
                  ],
                ));
    } else {
      final Appointment appointment =
          calendarAppointmentDetails.appointments.first;
      return GestureDetector(
        onTap: () async {
          Event? event =
              await databaseController.getEventById(appointment.id as int);
          Signature? signature =
              await databaseController.getSignatureById(event!.idSignature!);
          Alarm? alarm = await databaseController.getAlarmById(event.id!);
          DropdownButtonEventTypeWidget.value = event.eventType.asString;
          DropdownButtonSignatureWidget.value = signature!.name;

          showModalBottomSheet(
            isScrollControlled: true,
            enableDrag: true,
            builder: (context) => BottomSheetAddEventWidget(
              event: event,
              textAlarmDescription: alarm!.description,
            ),
            // transitionAnimationController: AnimationController(
            //   vsync: AnimatedListState(),
            //   duration: const Duration(milliseconds: 1000),
            // ),
            context: context,
            elevation: 40,
          );
        },
        child: Container(
          alignment: Alignment.center,
          color: appointment.color,
          width: calendarAppointmentDetails.bounds.width,
          height: calendarAppointmentDetails.bounds.height,
          child: Text(
            (appointment.notes != null) ? appointment.subject : ' ',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  void _addAppointment(Appointment appointment) {
    _appointments.add(appointment);
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
