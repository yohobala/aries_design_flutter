// ignore_for_file: non_constant_identifier_names

import 'app_localizations.dart';

/// The translations for Chinese (`zh`).
class AriLocalizationsZh extends AriLocalizations {
  AriLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get locatio_services_failed_title => '请打开定位服务';

  @override
  String get locatio_services_failed_content => '打开定位服务后，您将获得导航服务。';

  @override
  String get location_server_failed_open => '在设置中打开';

  @override
  String get location_server_failed_cancel => '下次再说';

  @override
  String get ariRouteItem_hasNavigation_failed =>
      '当hasNavigation为true时,navigationConfig和icon必须设置';

  @override
  String ariRouteItem_name_duplicate(String name) {
    return '路由\'name\'$name已经存在，请更换\'name\'，保证唯一';
  }
}
