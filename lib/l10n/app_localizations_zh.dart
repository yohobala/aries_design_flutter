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
  String get confirm_button => '确定';

  @override
  String get cancel_button => '取消';
}
