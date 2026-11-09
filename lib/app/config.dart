import 'package:flutter/foundation.dart';

const String kAppName = 'MedCal';

/// Must equal the `+N` build number in pubspec.yaml.
const int kAppBuild = 1;
const String kAppVersion = '1.0.0';

const String kWebBase = 'https://tools.homilabs.org/medicalcalc';
const String kPrivacyUrl = '$kWebBase/privacy.html';
const String kTermsUrl = '$kWebBase/terms.html';
const String kContactEmail = 'homilabs.smc@gmail.com';

/// AdMob banner "Home banner" (app ca-app-pub-2087846699268567~1518498085).
/// Debug and profile builds use Google's test adaptive banner.
const String _kLiveBannerId = 'ca-app-pub-2087846699268567/7044101590';
const String _kTestBannerId = 'ca-app-pub-3940256099942544/9214589741';
const String kBannerAdUnitId = kReleaseMode ? _kLiveBannerId : _kTestBannerId;
