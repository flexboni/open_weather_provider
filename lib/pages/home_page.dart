import 'package:flutter/material.dart';
import 'package:open_weather_provider/constants/constants.dart';
import 'package:open_weather_provider/pages/search_page.dart';
import 'package:open_weather_provider/pages/settings_page.dart';
import 'package:open_weather_provider/providers/providers.dart';
import 'package:open_weather_provider/widgets/error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;
  late WeatherProvider _weatherProvider;
  late final void Function() _removeListener;

  @override
  void initState() {
    super.initState();
    _weatherProvider = context.read<WeatherProvider>();
    _removeListener = _weatherProvider.addListener(_registerListener);
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  void _registerListener(WeatherState ws) {
    if (ws.status == WeatherStatus.error) {
      errorDialog(context, ws.error.errMsg!);
    }
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingsState>().tempUnit;
    if (tempUnit == TempUnit.fahrenheit) {
      return ((temperature * 9 / 5) + 32).toStringAsFixed(2) + '℉';
    }

    return temperature.toStringAsFixed(2) + '℃';
  }

  Widget _showWeather() {
    final state = context.watch<WeatherState>();
    if (state.status == WeatherStatus.initial) {
      return Center(
        child: Text(
          'Select a city',
          style: const TextStyle(fontSize: 20.0),
        ),
      );
    }

    if (state.status == WeatherStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.status == WeatherStatus.error && state.weather.name == '') {
      return Center(
        child: Text(
          'Select a city',
          style: const TextStyle(fontSize: 20.0),
        ),
      );
    }

    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 6),
        Text(
          state.weather.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              TimeOfDay.fromDateTime(state.weather.lastUpdated).format(context),
              style: const TextStyle(fontSize: 13.0),
            ),
            const SizedBox(width: 10.0),
            Text(
              '(${state.weather.country})',
              style: const TextStyle(fontSize: 10.0),
            ),
          ],
        ),
        const SizedBox(height: 60.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              showTemperature(state.weather.temp),
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20.0),
            Column(
              children: [
                Text(
                  showTemperature(state.weather.tempMax),
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 13.0),
                Text(
                  showTemperature(state.weather.tempMin),
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ],
        ),
        const SizedBox(height: 40.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Spacer(),
            showIcon(state.weather.icon),
            Expanded(
              flex: 3,
              child: formatText(state.weather.description),
            ),
            const Spacer(),
          ],
        )
      ],
    );
  }

  Widget showIcon(String icon) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'http://$kIconHost/img/wn/$icon@4x.png',
      width: 96,
      height: 96,
    );
  }

  Widget formatText(String description) {
    final formattedString = description.titleCase;
    return Text(
      formattedString,
      style: const TextStyle(fontSize: 24.0),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
            onPressed: () async {
              _city = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SearchPage();
                }),
              );
              if (_city != null) {
                context.read<WeatherProvider>().fetchWeather(_city!);
              }
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SettingsPage();
                }),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: _showWeather(),
    );
  }
}
