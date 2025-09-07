import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

class FirebaseProvider {
  FirebaseProvider._();

  static final FirebaseProvider _instance = FirebaseProvider._();

  static FirebaseProvider get instance => _instance;

  late final FirebaseAnalytics analytics;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    analytics = FirebaseAnalytics.instance;
    FlutterError.onError = (FlutterErrorDetails details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  FirebaseAnalyticsObserver getObserver() {
    return FirebaseAnalyticsObserver(analytics: analytics);
  }

  void log({required String name, Map<String, Object>? parameters}) {
    try {
      analytics.logEvent(
        name: name,
        parameters: parameters,
      );
      if (kDebugMode) print(name);
    } catch (error) {
      if (kDebugMode) print(error);
    }
  }
}
