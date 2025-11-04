import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Badminton Score'**
  String get appTitle;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @teamAName.
  ///
  /// In en, this message translates to:
  /// **'Team A name'**
  String get teamAName;

  /// No description provided for @teamBName.
  ///
  /// In en, this message translates to:
  /// **'Team B name'**
  String get teamBName;

  /// No description provided for @startMatch.
  ///
  /// In en, this message translates to:
  /// **'Start Match'**
  String get startMatch;

  /// No description provided for @endSetTitle.
  ///
  /// In en, this message translates to:
  /// **'End Set?'**
  String get endSetTitle;

  /// No description provided for @endSetContent.
  ///
  /// In en, this message translates to:
  /// **'Confirm set result: {teamA} {scoreA} : {scoreB} {teamB}'**
  String endSetContent(
    Object scoreA,
    Object scoreB,
    Object teamA,
    Object teamB,
  );

  /// No description provided for @keepup.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get keepup;

  /// No description provided for @endSet.
  ///
  /// In en, this message translates to:
  /// **'End Set'**
  String get endSet;

  /// No description provided for @resetSet.
  ///
  /// In en, this message translates to:
  /// **'Reset Set'**
  String get resetSet;

  /// No description provided for @endMatch.
  ///
  /// In en, this message translates to:
  /// **'End Match'**
  String get endMatch;

  /// No description provided for @noMatchesYet.
  ///
  /// In en, this message translates to:
  /// **'No matches yet'**
  String get noMatchesYet;

  /// No description provided for @setLabel.
  ///
  /// In en, this message translates to:
  /// **'Set {index}'**
  String setLabel(Object index);

  /// No description provided for @swipeHint.
  ///
  /// In en, this message translates to:
  /// **'Swipe ↑ to add • Swipe ↓ to subtract'**
  String get swipeHint;

  /// No description provided for @vsFormat.
  ///
  /// In en, this message translates to:
  /// **'{teamA} vs {teamB}'**
  String vsFormat(Object teamA, Object teamB);

  /// No description provided for @setsCount.
  ///
  /// In en, this message translates to:
  /// **'Sets: {count}'**
  String setsCount(Object count);

  /// No description provided for @resultSets.
  ///
  /// In en, this message translates to:
  /// **'Result: {a} - {b}'**
  String resultSets(Object a, Object b);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
