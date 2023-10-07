import 'app_localizations.dart';

/// The translations for English (`en`).
class AriLocalizationsEn extends AriLocalizations {
  AriLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get locatio_services_failed_title => 'Enable Location Services for better map use';

  @override
  String get locatio_services_failed_content => 'You well get navigation services When you turn on the location service.';

  @override
  String get location_server_failed_open => 'Turn On in Settings';

  @override
  String get location_server_failed_cancel => 'No Thanks';
}
