import 'package:flutter/material.dart';
import 'package:scientia_app/services/notification_manager.dart';

import '../scientia_app.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Setări",
          style: Theme.of(context).textTheme.headline5
        )
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Notificări",
                  style: Theme.of(context).textTheme.subtitle1
                ),
                Switch(
                  value: NotificationManager().enabled,
                  onChanged: (bool value) {
                    setState(() {
                      if (value) {
                        NotificationManager().enableNotifications(NotificationManager().sharedPrefs);
                      } else {
                        NotificationManager().disableNotifications(NotificationManager().sharedPrefs);
                      }
                    });
                  },
                ),
              ]
            ),
            Divider(),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                      "Dark theme",
                      style: Theme.of(context).textTheme.subtitle1
                  ),
                  Switch(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (bool value) {
                      if (value) {
                        ScientiaApp.of(context)!.changeTheme(ThemeMode.dark);
                      } else {
                        ScientiaApp.of(context)!.changeTheme(ThemeMode.light);
                      }
                    },
                  ),
                ]
            ),
            Divider()
          ]
        ),
      )
    );
  }
}
