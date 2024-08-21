import 'package:flutter/material.dart';
import 'package:lab_attendance_mobile_teacher/services/session/session_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SessionProvider _sessionProvider;

  @override
  void initState() {
    super.initState();
    _sessionProvider = Provider.of<SessionProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _sessionProvider.sessionManager.resetSessionTimer,
      onPanUpdate: (details) =>
          _sessionProvider.sessionManager.resetSessionTimer(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await _sessionProvider.clearSession();
              },
            )
          ],
        ),
        body: Center(child: Text('Welcome!')),
      ),
    );
  }
}
