import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCalendar extends StatelessWidget {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Replace this with your appointment details
            addAppointmentToCalendar('Appointment With Janek ', 'Get Promotion', DateTime.now());
          },
          child: Text('Add Testtttt Appointment'),
        ),
      ),
    );
  }

  Future<void> addAppointmentToCalendar(String title, String description, DateTime startTime) async {
    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();

    if (calendarsResult.isSuccess && calendarsResult.data?.isNotEmpty == true) {
      final calendar = calendarsResult.data![0]; // Choose the first calendar

      print("length: " + calendarsResult.data!.length.toString());
      print("type: " + calendarsResult.data![0].toString());

      for(int i = 0; i < calendarsResult.data!.length; i++){
        print("index: " + i.toString());
        print(calendarsResult.data![i].id);
        print(calendarsResult.data![i].name);
        print(calendarsResult.data![i].accountName);
      }

      final event = Event(
          calendarsResult.data![0].id,
          title: title,
          description: description, // Replace with the desired duration
          start: TZDateTime.now(getLocation('Europe/Berlin')),
          //end: TZDateTime.fromMillisecondsSinceEpoch(timeZone('Europe/Berlin'), 1640979000000)
          end: TZDateTime.now(getLocation('Europe/Berlin'))
      );

      print(event.title! + " : " + event.start.toString() + " " + event.end.toString());

      final createResult = await _deviceCalendarPlugin.createOrUpdateEvent(event);

      if (createResult!.isSuccess) {
        print('Appointment added to calendar');
      } else {
        print('Error adding appointment');
      }
    } else {
      print('Error retrieving calendars');
    }
  }
}