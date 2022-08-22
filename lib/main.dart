import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_provider/pages/home_page.dart';
import 'package:open_weather_provider/providers/providers.dart';
import 'package:open_weather_provider/providers/weather/weather_provider.dart';
import 'package:open_weather_provider/repositories/weather_repository.dart';
import 'package:open_weather_provider/services/weather_api_services.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WeatherRepository>(
          create: (context) => WeatherRepository(
            weatherApiServices: WeatherApiServices(
              httpClient: http.Client(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => WeatherProvider(
            weatherRepository: context.read<WeatherRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => TempSettingsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Weather',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
