import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

/// Callers can lookup localized strings with an instance of AriLocalizations
/// returned by `AriLocalizations.of(context)`.
///
/// Applications need to include `AriLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AriLocalizations.localizationsDelegates,
///   supportedLocales: AriLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AriLocalizations.supportedLocales
/// property.
abstract class AriLocalizations {
  AriLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AriLocalizations? of(BuildContext context) {
    return Localizations.of<AriLocalizations>(context, AriLocalizations);
  }

  static const LocalizationsDelegate<AriLocalizations> delegate = _AriLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// 用于定位服务未开启弹窗的标题，介绍需要开启定位服务
  ///
  /// In zh, this message translates to:
  /// **'请打开定位服务'**
  String get locatio_services_failed_title;

  /// 用于定位服务未开启弹窗的内容，主要是讲开启定位后能获得功能
  ///
  /// In zh, this message translates to:
  /// **'打开定位服务后，您将获得导航服务。'**
  String get locatio_services_failed_content;

  /// 用于定位服务未开启弹窗的打开按钮
  ///
  /// In zh, this message translates to:
  /// **'在设置中打开'**
  String get location_server_failed_open;

  /// 用于定位服务未开启弹窗取消按钮
  ///
  /// In zh, this message translates to:
  /// **'下次再说'**
  String get location_server_failed_cancel;

  /// 确定按钮
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get confirm_button;

  /// 取消按钮
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel_button;
}

class _AriLocalizationsDelegate extends LocalizationsDelegate<AriLocalizations> {
  const _AriLocalizationsDelegate();

  @override
  Future<AriLocalizations> load(Locale locale) {
    return SynchronousFuture<AriLocalizations>(lookupAriLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AriLocalizationsDelegate old) => false;
}

AriLocalizations lookupAriLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AriLocalizationsEn();
    case 'zh': return AriLocalizationsZh();
  }

  throw FlutterError(
    'AriLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
