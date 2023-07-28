import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tbib_get_timezone_location/tbib_get_timezone_location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TbibGetTimezoneLocation().init();
  var timezoneName = await TbibGetTimezoneLocation().getTimezones();
  log(timezoneName.toString());
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TBIBDatePickerFormField(
          title: 'Date time picker',
          onSaved: (value) {},
          datePickerStyle: TBIBDatePickerStyle(
            isDateAndTime: true,
            getTime: ({required date}) {
              log('date time is $date');
            },
            initDate: DateTime.now().add(const Duration(days: 5)),
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 10)),
          ),
        ),
      )),
    );
  }
}
