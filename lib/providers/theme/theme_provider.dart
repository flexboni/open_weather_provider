import 'package:equatable/equatable.dart';
import 'package:open_weather_provider/constants/constants.dart';
import 'package:open_weather_provider/providers/weather/weather_provider.dart';
import 'package:state_notifier/state_notifier.dart';

part 'theme_state.dart';

class ThemeProvider extends StateNotifier<ThemeState> with LocatorMixin {
  ThemeProvider() : super(ThemeState.initial());

  @override
  void update(Locator watch) {
    if (watch<WeatherProvider>().state.weather.temp > kWarmOrNot) {
      state = state.copyWith(appTheme: AppTheme.light);
    } else {
      state = state.copyWith(appTheme: AppTheme.dark);
    }

    super.update(watch);
  }
}
