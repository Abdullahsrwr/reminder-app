import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:groupproject/controller/edit_item.dart';
import 'package:groupproject/database/db_utils.dart';
import 'package:groupproject/views/mapView.dart';
import 'controller/notifications.dart';
import 'controller/add.dart';
import 'models/task.dart';
import 'controller/locations.dart';
import 'models/task_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database/firebase_manager.dart';
import 'controller/task_table.dart';
import 'package:groupproject/controller/task_chart.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'views/mapmarker.dart';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DBUtils.init();
  await Firebase.initializeApp();
  await fillFireTaskList();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Project',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'Home Page'),
      localizationsDelegates: [
        FlutterI18nDelegate(
          missingTranslationHandler: (key, locale) {
            print('MISSING KEY: $key, Language Code: ${locale!.languageCode}');
          },
          translationLoader: FileTranslationLoader(
              useCountryCode: false,
              fallbackFile: 'en',
              basePath: 'assets/i18n'),
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('fr'),
        Locale('es'),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MapController _mapController;
  bool havePermission = false;
  List<Task> firebaseList = [];
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    askLocation();
  }

  askLocation() async {
    await Geolocator.isLocationServiceEnabled().then((value) => null);
    await Geolocator.requestPermission().then((value) => null);
    await Geolocator.checkPermission().then((LocationPermission permission) {
      print("Check Location Permission: $permission");
    });
    await Geolocator.isLocationServiceEnabled()
        .then((value) => havePermission = value);
    if (havePermission == false) {
      await askLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    firebaseList = [];
    for (var i = 0; i < fireTaskList.length; i++) {
      firebaseList.add(fireTaskList[i]);
    }
    print(firebaseList);
    setState(() {});

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(FlutterI18n.translate(context, "page_titles.home_page")),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => showTable(
                            title: FlutterI18n.translate(
                                context, "page_titles.schedule_page"),
                            data: firebaseList,
                          )),
                );
              },
              icon: Icon(Icons.calendar_month),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => showChart(
                            title: FlutterI18n.translate(
                                context, "page_titles.chart_page"),
                            data: firebaseList,
                          )),
                );
              },
              icon: Icon(Icons.bar_chart),
            ),
          ],
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(4),
          itemCount: firebaseList.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                background: Container(color: Color.fromARGB(255, 94, 246, 160)),
                secondaryBackground:
                    Container(color: Color.fromARGB(255, 255, 82, 82)),
                key: UniqueKey(),
                onDismissed: (DismissDirection direction) async {
                  if (direction == DismissDirection.endToStart) {
                    await getFireTasks();
                    await fillFireTaskList();
                    await removeSelectedFireDB(fireTaskList[index]);
                    await Notifications()
                        .cancelNotification(firebaseList[index].id!);
                    await TaskModel().deleteTask(firebaseList[index].id!);

                    setState(() {});
                  } else if (direction == DismissDirection.startToEnd) {
                    if (firebaseList[index].streetName != null) {
                      setState(() {});
                      locationData = [
                        firebaseList[index].streetNumber! +
                            " " +
                            firebaseList[index].streetName! +
                            ", " +
                            firebaseList[index].city! +
                            ", " +
                            firebaseList[index].province!
                      ];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapPage(
                                title: FlutterI18n.translate(
                                    context, "page_titles.map"))),
                      );
                    } else {
                      setState(() {});
                    }
                  }
                },
                child: ListTile(
                  leading: firebaseList[index].streetName == null ||
                          firebaseList[index].streetName == ""
                      ? Icon(Icons.no_transfer_rounded)
                      : Icon(Icons.mode_of_travel_rounded),
                  title: Text(firebaseList[index].eventName!),
                  subtitle: Text(firebaseList[index].eventDesc!),
                  trailing: Text(DateFormat('EEE, M/d/y (hh:mm)').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          firebaseList[index].date!))),
                  onTap: () async {
                    Task temp = firebaseList[index];
                    temp.eventName ??= "";
                    temp.eventDesc ??= "";
                    temp.streetName ??= "";
                    temp.streetNumber ??= "";
                    temp.city ??= "";
                    temp.province ??= "";
                    temp.id ??= 0;
                    await getFireTasks();
                    await fillFireTaskList();
                    await removeSelectedFireDB(fireTaskList[index]);
                    await Notifications()
                        .cancelNotification(firebaseList[index].id!);
                    await TaskModel().deleteTask(firebaseList[index].id!);

                    setState(() {});

                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditPage(
                                body: temp.eventDesc!,
                                city: temp.city!,
                                eventDate: DateTime.fromMillisecondsSinceEpoch(
                                    temp.date!),
                                province: temp.province!,
                                streetName: temp.streetName!,
                                streetNumber: temp.streetNumber!,
                                title: temp.eventName!,
                              )),
                    );
                  },
                ));
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ),
        floatingActionButton: Wrap(
          spacing: 250.0,
          direction: Axis.horizontal,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "lang_btn",
              onPressed: () {
                print(firebaseList.length);
                for (int i = 0; i < firebaseList.length; i++) {
                  print(firebaseList[i]);
                }

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _askDialogLang();
                    });
              },
              tooltip: 'Add task',
              child: const Icon(Icons.language),
            ),
            FloatingActionButton(
              heroTag: "add_btn",
              onPressed: () {
                print(firebaseList.length);
                for (int i = 0; i < firebaseList.length; i++) {
                  print(firebaseList[i]);
                }

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return _askDialog();
                    });
              },
              tooltip: 'Add task',
              child: const Icon(Icons.add),
            ),
          ],
        ));
  }

  Future _showPendingNotifications() async {
    var pendingNotificationRequests =
        await Notifications().getPendingNotificationRequests();

    print("Pending Notifications:");
    for (var pendNot in pendingNotificationRequests) {
      print("${pendNot.id} / ${pendNot.title} / ${pendNot.body}");
    }
    print("Tasks in Cloud Firestore:");
    getFireTasks();

    print("Tasks in Database:");
    TaskModel().getAllTasks();
  }

  _askDialog() {
    return AlertDialog(
      title: Text(FlutterI18n.translate(context, "dialogue.loc_title")),
      content: Text(FlutterI18n.translate(context, "dialogue.location")),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LocationPage(
                        title: FlutterI18n.translate(
                            context, "page_titles.task_add_loc"),
                      )),
            );
          },
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNoti(
                        title: FlutterI18n.translate(
                            context, "page_titles.task_add"),
                      )),
            );
          },
          child: Text('No'),
        ),
      ],
    );
  }

  _askDialogLang() {
    return AlertDialog(
      title: Text(FlutterI18n.translate(context, "dialogue.lang_title")),
      content: Text(FlutterI18n.translate(context, "dialogue.language")),
      actions: [
        TextButton(
          onPressed: () async {
            Locale newLocale = Locale('en');
            await FlutterI18n.refresh(context, newLocale);
            setState(() {
              Navigator.pop(context);
            });
          },
          child: Text('English'),
        ),
        TextButton(
          onPressed: () async {
            Locale newLocale = Locale('fr');
            await FlutterI18n.refresh(context, newLocale);
            setState(() {
              Navigator.pop(context);
            });
          },
          child: Text('French'),
        ),
        TextButton(
          onPressed: () async {
            Locale newLocale = Locale('es');
            await FlutterI18n.refresh(context, newLocale);
            setState(() {
              Navigator.pop(context);
            });
          },
          child: Text('Spanish'),
        ),
      ],
    );
  }
}
