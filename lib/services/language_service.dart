import 'dart:ui';

class LanguageService {
  static String getSystemLanguage() {
    String code = PlatformDispatcher.instance.locale.languageCode;
    
    List<String> supported = ['es', 'en', 'ca']; 
    
    return supported.contains(code) ? code : 'es';
  }
}