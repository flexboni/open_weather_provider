import 'package:flutter/material.dart';
import 'package:open_weather_provider/providers/providers.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Text('Temperature Unit'),
          subtitle: Text('Celsius/Fahrenheit (Default: Celsius)'),
          trailing: Switch(
            value: context.watch<TempSettingsProvider>().state.tempUnit ==
                TempUnit.celsius,
            onChanged: (_) =>
                context.read<TempSettingsProvider>().toggleTempUnit(),
          ),
        ),
      ),
    );
  }
}
