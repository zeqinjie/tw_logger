
A logger with network, crash, regular log to cache, and you can search information 

## introduce

![](https://github.com/zeqinjie/blog/blob/master/source/images/2024/tw_logger/1.gif)

## Features

- Supports the output function of general logger and writes log content to db
- Support network request interception output function, write request and response results to db
- Support exception capture function and write errors to db
- Implement UI interface addition, deletion and tag query records

## Getting started
Add tw_logger to your pubspec.yaml file:

```yaml
dependencies:
  tw_logger: latest_version
```

## Usage

import tw_logger in files that it will be used:
```dart
import 'package:tw_logger/tw_logger.dart';
```

```dart
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tw_logger/tw_logger.dart';

// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';

void main(List<String> args) async {
  FlutterError.onError = (FlutterErrorDetails details) {
    TWCrashHelper.handleCrashCache(details);
  };
  runZonedGuarded(
    () {
      runApp(const MyApp());
    },
    (error, stacktrace) {
      TWCrashHelper.handleCrashCache(FlutterErrorDetails(
        stack: stacktrace,
        exception: error,
      ));
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tw_logger',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'tw_logger'),
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
  final dio = Dio();
  late OverlayEntry overlayEntry;
  @override
  void initState() {
    super.initState();
    setUp();
    setLoggerFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Switch(
              value: TWLoggerConfigure().open,
              onChanged: switchOpenChanged,
            ),
            FilledButton(
              onPressed: () {
                log();
              },
              child: const Text('log'),
            ),
            FilledButton(
              onPressed: () {
                log2();
              },
              child: const Text('log2'),
            ),
            FilledButton(
              onPressed: () {
                log3();
              },
              child: const Text('log3'),
            ),
            FilledButton(
              onPressed: () {
                throw Exception('This is a crash test');
              },
              child: const Text('throw error'),
            ),
            FilledButton(
              onPressed: () {
                get1();
              },
              child: const Text('get1'),
            ),
            FilledButton(
              onPressed: () {
                get2();
              },
              child: const Text('get2'),
            ),
            FilledButton(
              onPressed: () {
                delete();
              },
              child: const Text('delete'),
            ),
            FilledButton(
              onPressed: () {
                post();
              },
              child: const Text('post'),
            ),
          ],
        ),
      ),
    );
  }

  void setLoggerFilter() {
    TWLogger().filter = (
      level,
      message,
      error,
      stackTrace,
      time,
    ) {
      return message != 'filter log';
    };
  }

  void setUp() {
    if (TWLoggerConfigure().open) {
      overlayEntry = TWLoggerOverlay.attachTo(context);
    } else {
      overlayEntry.remove();
    }
    TWNetworkSetting.updateInterceptor(dio);
  }

  void switchOpenChanged(bool value) {
    setState(() {
      TWLoggerConfigure().isEnabled = value;
      setUp();
    });
  }

  void log() {
    String randomString = generateRandomString(120);
    TWLogger.log(randomString);
  }

  void log2() {
    String randomString = generateRandomString(120);
    TWLogger.log(
      randomString,
      level: TWLogLevel.error,
    );
  }

  void log3() {
    TWLogger.log('filter log');
  }

  String generateRandomString(int length) {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(
            length, (index) => characters[random.nextInt(characters.length)])
        .join();
  }

  void get1() {
    dio.get('https://flutter.dev/');
  }

  void get2() {
    dio.get('https://jsonplaceholder.typicode.com/todos');
  }

  void delete() {
    dio.delete(
        'http://ajax.googleapis.com/ajax/services/feed/load?q=FeedName&v=1.0');
  }

  void post() {
    dio.post(
      'https://run.mocky.io/v3/9d059bf9-4660-45f2-925d-ce80ad6c4d15',
      data: <String, dynamic>{
        "id": 1,
        "title": "Hello World",
        "content": "This is a post"
      },
    );
  }
}

```

## Additional information

If you have any questions, please give me feedback, thank you
