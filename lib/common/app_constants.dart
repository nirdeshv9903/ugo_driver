import 'dart:io';

import '../db/app_database.dart';
import '../features/language/domain/models/language_listing_model.dart';

class AppConstants {
  static const String title = 'Ugoliv Driver';
  static const String baseUrl = 'https://taxinew.appzetodemo.com/';
  static String firbaseApiKey = (Platform.isAndroid)
      ? "AIzaSyAtIM6YgS0E-kICtG3DWAXa5dqstoelUD0"
      : "ios firebase api key";
  static String firebaseAppId = (Platform.isAndroid)
      ? "1:278233606273:android:53fa8f19c2871e2f150580"
      : "ios firebase app id";
  static String firebasemessagingSenderId =
      (Platform.isAndroid) ? "278233606273" : "ios firebase sender id";
  static String firebaseProjectId =
      (Platform.isAndroid) ? "appzetotaxi" : "ios firebase project id";

  static String mapKey = (Platform.isAndroid)
      ? "AIzaSyC8ajlcg9UzcHWmFjHfNenSynk6VCSlyhU"
      : 'ios map key';
  static const String privacyPolicy = 'your privacy policy url';
  static const String termsCondition = 'your terms and condition url';

  static const String stripPublishKey = '';

  static List<LocaleLanguageList> languageList = [
    LocaleLanguageList(name: 'English', lang: 'en'),
    LocaleLanguageList(name: 'Arabic', lang: 'ar'),
    LocaleLanguageList(name: 'Azerbaijani', lang: 'az'),
    LocaleLanguageList(name: 'French', lang: 'fr'),
    LocaleLanguageList(name: 'Spanish', lang: 'es')
  ];
  static String packageName = 'com.taxidriver.appzeto';
  static String signKey = '';
}

bool showBubbleIcon = false;
bool subscriptionSkip = false;
String choosenLanguage = 'en';
String mapType = '';
bool isAppMapChange = false;

AppDatabase db = AppDatabase();
