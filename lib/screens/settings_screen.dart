import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/app_state_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;
  late String _selectedRole;
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    _nameController = TextEditingController(text: appState.currentUser?.name ?? '');
    _selectedRole = appState.currentUser?.role ?? 'Operator';
    _selectedLanguage = appState.appSettings.language;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    final appState = Provider.of<AppStateProvider>(context, listen: false);

    // Update user profile
    final updatedUser = UserProfile(
      name: _nameController.text,
      role: _selectedRole,
    );
    appState.updateCurrentUser(updatedUser);

    // Update app settings
    final updatedSettings = appState.appSettings.copyWith(
      language: _selectedLanguage,
    );
    appState.updateAppSettings(updatedSettings);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<AppStateProvider>(
        builder: (context, appState, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Text('User Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: ['Operator', 'Supervisor', 'Administrator']
                    .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              const Text('App Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                decoration: const InputDecoration(
                  labelText: 'Language',
                  border: OutlineInputBorder(),
                ),
                items: ['English', 'Spanish']
                    .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveSettings,
                child: const Text('Save Settings'),
              ),
            ],
          );
        },
      ),
    );
  }
}