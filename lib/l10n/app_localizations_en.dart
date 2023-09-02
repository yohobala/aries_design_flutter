// ignore_for_file: non_constant_identifier_names

import 'app_localizations.dart';

/// The translations for English (`en`).
class AriLocalizationsEn extends AriLocalizations {
  AriLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get locatio_services_failed_title =>
      'Enable Location Services for better map use';

  @override
  String get locatio_services_failed_content =>
      'You well get navigation services When you turn on the location service.';

  @override
  String get location_server_failed_open => 'Turn On in Settings';

  @override
  String get location_server_failed_cancel => 'No Thanks';

  @override
  String get ariRouteItem_hasNavigation_failed =>
      'When \'hasNavigation\' is true, \'navigationConfig\' and \'icon\' must be set.';

  @override
  String ariRouteItem_name_duplicate(String name) {
    return 'he route \'name\' $name already exists, please replace \'name\' to ensure uniqueness.';
  }
}
