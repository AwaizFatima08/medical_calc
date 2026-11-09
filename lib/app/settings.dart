import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../calc/catalog.dart';

enum LabUnits { conventional, si }

enum BmiStandard { asian, international }

/// Everything the app remembers. Stored on the phone only (design §5).
class AppSettings {
  const AppSettings({
    this.mode,
    this.doctorDeclared = false,
    this.labUnits = LabUnits.conventional,
    this.bmiStandard = BmiStandard.asian,
    this.favourites = const [],
    this.recents = const [],
  });

  final ToolMode? mode;
  final bool doctorDeclared;
  final LabUnits labUnits;
  final BmiStandard bmiStandard;
  final List<String> favourites;
  final List<String> recents;

  static const int maxRecents = 5;

  AppSettings copyWith({
    ToolMode? mode,
    bool? doctorDeclared,
    LabUnits? labUnits,
    BmiStandard? bmiStandard,
    List<String>? favourites,
    List<String>? recents,
  }) => AppSettings(
    mode: mode ?? this.mode,
    doctorDeclared: doctorDeclared ?? this.doctorDeclared,
    labUnits: labUnits ?? this.labUnits,
    bmiStandard: bmiStandard ?? this.bmiStandard,
    favourites: favourites ?? this.favourites,
    recents: recents ?? this.recents,
  );
}

/// Overridden in main() with the loaded instance.
final sharedPrefsProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPrefsProvider not overridden'),
);

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

class SettingsNotifier extends Notifier<AppSettings> {
  static const _kMode = 'mode';
  static const _kDeclared = 'doctor_declared';
  static const _kUnits = 'lab_units';
  static const _kBmi = 'bmi_standard';
  static const _kFav = 'favourites';
  static const _kRecent = 'recents';

  SharedPreferences get _prefs => ref.read(sharedPrefsProvider);

  @override
  AppSettings build() {
    final p = ref.read(sharedPrefsProvider);
    T? byName<T extends Enum>(List<T> values, String? name) {
      for (final v in values) {
        if (v.name == name) return v;
      }
      return null;
    }

    return AppSettings(
      mode: byName(ToolMode.values, p.getString(_kMode)),
      doctorDeclared: p.getBool(_kDeclared) ?? false,
      labUnits:
          byName(LabUnits.values, p.getString(_kUnits)) ??
          LabUnits.conventional,
      bmiStandard:
          byName(BmiStandard.values, p.getString(_kBmi)) ?? BmiStandard.asian,
      favourites: p.getStringList(_kFav) ?? const [],
      recents: p.getStringList(_kRecent) ?? const [],
    );
  }

  /// Doctor mode needs the one-time declaration first.
  Future<void> chooseDoctor() async {
    state = state.copyWith(mode: ToolMode.doctor, doctorDeclared: true);
    await _prefs.setBool(_kDeclared, true);
    await _prefs.setString(_kMode, ToolMode.doctor.name);
  }

  Future<void> choosePublic() async {
    state = state.copyWith(mode: ToolMode.public);
    await _prefs.setString(_kMode, ToolMode.public.name);
  }

  Future<void> setLabUnits(LabUnits units) async {
    state = state.copyWith(labUnits: units);
    await _prefs.setString(_kUnits, units.name);
  }

  Future<void> setBmiStandard(BmiStandard standard) async {
    state = state.copyWith(bmiStandard: standard);
    await _prefs.setString(_kBmi, standard.name);
  }

  Future<void> toggleFavourite(String toolId) async {
    final favs = [...state.favourites];
    favs.contains(toolId) ? favs.remove(toolId) : favs.add(toolId);
    state = state.copyWith(favourites: favs);
    await _prefs.setStringList(_kFav, favs);
  }

  Future<void> recordUse(String toolId) async {
    final recents = [
      toolId,
      ...state.recents.where((id) => id != toolId),
    ].take(AppSettings.maxRecents).toList();
    state = state.copyWith(recents: recents);
    await _prefs.setStringList(_kRecent, recents);
  }

  Future<void> clearHistory() async {
    state = state.copyWith(favourites: const [], recents: const []);
    await _prefs.remove(_kFav);
    await _prefs.remove(_kRecent);
  }
}
