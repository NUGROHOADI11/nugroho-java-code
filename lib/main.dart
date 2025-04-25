import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:nugroho_javacode/configs/localizations/localization_string.dart';
import 'package:nugroho_javacode/configs/routes/route.dart';
import 'package:nugroho_javacode/shared/bindings/global_bindings/global_binding.dart';

import 'configs/pages/page.dart';
import 'configs/themes/theme.dart';
import 'features/cart/models/cart_model.dart';
import 'utils/services/hive_service.dart';
import 'utils/services/sentry_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CartItemModelAdapter());
  await Get.putAsync(() async {
    final service = LocalStorageService();
    return await service.init();
  });
  await Hive.openBox("venturo");
  await Hive.openBox<CartItemModel>('cart');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://265c9bdf1182f420c41a9e0571f8e0e1@o4508951422500864.ingest.us.sentry.io/4508951425056768';
      options.tracesSampleRate = 1.0;
      options.beforeSend = filterSentryErrorBeforeSend as BeforeSendCallback?;
    },
    appRunner: () => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final String? language = LocalStorageService.getLanguagePreference();

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: 'Initial Screen',
      screenClass: 'Trainee',
    );
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Venturo Core',
          debugShowCheckedModeBanner: false,
          // locale: Get.deviceLocale,
          translations: LocalizationString(),
          locale: language != null ? Locale(language!) : Get.deviceLocale,
          fallbackLocale: const Locale('en', 'US'),
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('id', 'ID'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: Routes.splashRoute,
          initialBinding: GlobalBinding(),
          theme: themeLight,
          defaultTransition: Transition.native,
          getPages: Pages.pages,
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
