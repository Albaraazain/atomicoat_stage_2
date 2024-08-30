import 'package:flutter/material.dart';
import '../widgets/status_indicator.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atomicoat Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/images/logo.png', height: 100),
          SizedBox(height: 20),
          Text('Welcome to Atomicoat Mobile App', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          StatusIndicator(status: 'System Idle'), // Mock status
          SizedBox(height: 40),
          ElevatedButton(
            child: Text('System Control'),
            onPressed: () => Navigator.pushNamed(context, '/system_control'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text('Recipes'),
            onPressed: () => Navigator.pushNamed(context, '/recipe'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text('Monitoring'),
            onPressed: () => Navigator.pushNamed(context, '/monitoring'),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text('Settings'),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }
}