import 'dart:async';
import 'package:flutter/material.dart';

import 'package:activity_ring/activity_ring.dart';
import 'package:flutter/services.dart';
import 'package:ring/colors.dart';
import 'package:ring/widgets/ring_button.dart';
import 'package:ring/widgets/ring_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isRunning = false;
  var isInit = true;
  var store = -1;

  DateTime firstDay;
  DateTime lastDay;

  int totalDays;
  int remainingDays;
  int passedDays;

  Future<void> setup() async {
    if (isInit) {
      isInit = false;

      var prefs = await SharedPreferences.getInstance();

      setState(() {
        totalDays = prefs.getInt('totalDays');

        store = prefs.getInt('store') ?? -1;
        print(store);

        var firstDayValue = prefs.getString('firstDay') ?? '';
        firstDay = DateTime.tryParse(firstDayValue);

        isRunning = totalDays == null ? false : true;
      });
    }
  }

  void start(bool isInsert) async {
    setState(() {
      if (isInsert) {
        store -= 1;
      }
      isRunning = true;
      totalDays = isInsert ? 21 : 7;
      firstDay = DateTime.now();
    });

    var prefs = await SharedPreferences.getInstance();

    prefs.setInt('totalDays', isInsert ? 21 : 7);
    prefs.setString('firstDay', DateTime.now().toIso8601String());

    if (isInsert) {
      prefs.setInt('store', store);
    }
  }

  void reset() async {
    setState(() {
      isRunning = false;
    });

    var prefs = await SharedPreferences.getInstance();

    prefs.remove('totalDays');
    prefs.remove('firstDay');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    final date = DateTime.now();

    if (isRunning) {
      lastDay = firstDay.add(Duration(days: totalDays));
      remainingDays = lastDay.difference(date).inDays;
      passedDays = totalDays - remainingDays;
    }

    void onRingStore() {
      showDialog(
        context: context,
        barrierColor: RingColors.of(context).text.withOpacity(
              MediaQuery.of(context).platformBrightness == Brightness.light
                  ? 0.3
                  : 0.075,
            ),
        builder: (context) => RingOverlay((i) async {
          Navigator.of(context).pop();

          if (i != null) {
            var prefs = await SharedPreferences.getInstance();
            prefs.setInt('store', i);

            setState(() {
              store = i;
            });
          }
        }),
      );
    }

    setup();

    return Scaffold(
      backgroundColor: RingColors.of(context).background,
      appBar: AppBar(
        elevation: 0,
        brightness: MediaQuery.of(context).platformBrightness,
        backgroundColor: RingColors.of(context).background,
        title: Text(
          'appTitle'.tr(),
          style: TextStyle(color: RingColors.of(context).textHeadingContrast),
        ),
        actions: [
          FlatButton(
            onPressed: onRingStore,
            highlightColor: RingColors.of(context).primary.withOpacity(0.05),
            splashColor: RingColors.of(context).primary.withOpacity(0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.radio_button_unchecked,
                  color: RingColors.of(context).primary,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  (store + 1).toString(),
                  style: TextStyle(
                    color: RingColors.of(context).textHeadingContrast,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 170,
            height: 170,
            child: Ring(
              percent: isRunning ? passedDays / totalDays * 100 : 0,
              color: RingColorScheme(
                  ringColor: RingColors.of(context).primary,
                  backgroundColor:
                      RingColors.of(context).primary.withOpacity(0.2)),
              radius: 80,
              width: 10,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: isRunning
                      ? [
                          Text(
                            remainingDays == 0
                                ? 'appTitle'.tr()
                                : totalDays == 21
                                    ? 'removeRing'.tr()
                                    : 'insertRing'.tr(),
                            style:
                                TextStyle(color: RingColors.of(context).text),
                          ),
                          Text(
                            remainingDays == 0
                                ? 'today'.tr()
                                : remainingDays.toString() +
                                    ' ' +
                                    'day'.plural(remainingDays),
                            style: TextStyle(
                              color: RingColors.of(context).textHeading,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                          if (remainingDays == 0)
                            Text(
                              totalDays == 21 ? 'remove'.tr() : 'insert'.tr(),
                              style:
                                  TextStyle(color: RingColors.of(context).text),
                            ),
                        ]
                      : [
                          Text(
                            'countdownTitle'.tr(),
                            style: TextStyle(
                              color: RingColors.of(context).textHeading,
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                          ),
                          Text(
                            'countdownSubtitle'.tr(),
                            style:
                                TextStyle(color: RingColors.of(context).text),
                          ),
                        ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 128,
          ),
          if (!isRunning)
            Container(
              height: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: store < 0 ? 0.3 : 1,
                    child: RingButton(
                      'insertedButton'.tr(),
                      onPressed: store < 0
                          ? null
                          : () {
                              start(true);
                            },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RingButton(
                    'removedButton'.tr(),
                    onPressed: () {
                      start(false);
                    },
                  ),
                ],
              ),
            ),
          if (isRunning)
            Container(
              height: 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RingButton(
                    remainingDays == 0
                        ? 'doneButton'.tr()
                        : 'cancelButton'.tr(),
                    onPressed: reset,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
