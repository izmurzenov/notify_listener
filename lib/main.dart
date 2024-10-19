import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<NotificationEvent> _notifications = [];

  void onData(NotificationEvent event) {
    _notifications.add(event);
    setState(() {});
  }

  Future<void> initPlatformState() async {
    NotificationsListener.initialize();
    NotificationsListener.receivePort?.listen((event) => onData(event));
  }

  @override
  void initState() {
    super.initState();
    startListening();
    unawaited(initPlatformState());
  }

  void startListening() async {
    var hasPermission = await NotificationsListener.hasPermission;
    if (!(hasPermission ?? true)) {
      NotificationsListener.openPermissionSettings();
      return;
    }

    var isR = await NotificationsListener.isRunning;

    if (!(isR ?? false)) {
      await NotificationsListener.startService();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() => AppBar(title: const Text('Погреем ушки))'));

  Widget _buildBody() {
    if (_notifications.isEmpty) return const Center(child: Text('Пока нихуя нет. Жди заебал...'));
    return ListView.builder(
      itemCount: _notifications.length,
      itemBuilder: (context, i) => ListTile(
        title: Text(_notifications[i].title ?? 'Нет заголовка'),
        subtitle: Text(_notifications[i].message ?? 'Нет сообщения'),
      ),
    );
  }
}
