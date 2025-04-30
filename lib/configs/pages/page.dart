import 'package:get/get.dart';
import 'package:nugroho_javacode/configs/routes/route.dart';
import 'package:nugroho_javacode/features/detail_menu/bindings/detail_menu_binding.dart';
import 'package:nugroho_javacode/features/detail_order/bindings/detail_order_binding.dart';
import 'package:nugroho_javacode/features/detail_promo/bindings/detail_promo_binding.dart';
import 'package:nugroho_javacode/features/forgot_password/bindings/forgot_password_binding.dart';
import 'package:nugroho_javacode/features/forgot_password/view/ui/forgot_password_screen.dart';
import 'package:nugroho_javacode/features/home/bindings/home_binding.dart';
import 'package:nugroho_javacode/features/no_connection/bindings/no_connection_binding.dart';
import 'package:nugroho_javacode/features/no_connection/view/ui/no_connection_screen.dart';
import 'package:nugroho_javacode/features/sign_in/bindings/sign_in_binding.dart';
import 'package:nugroho_javacode/features/splash/bindings/splash_binding.dart';
import 'package:nugroho_javacode/features/splash/view/ui/splash_screen.dart';
import 'package:nugroho_javacode/features/voucher/bindings/voucher_binding.dart';

import '../../features/cart/bindings/cart_binding.dart';
import '../../features/cart/view/ui/cart_screen.dart';
import '../../features/chat_review/bindings/chat_review_binding.dart';
import '../../features/chat_review/view/ui/chat_review_screen.dart';
import '../../features/compass/bindings/compass_binding.dart';
import '../../features/compass/view/ui/compass_screen.dart';
import '../../features/detail_menu/view/ui/detail_menu_screen.dart';
import '../../features/detail_order/view/ui/detail_order_screen.dart';
import '../../features/detail_promo/view/ui/detail_promo_screen.dart';
import '../../features/forgot_password/bindings/otp_binding.dart';
import '../../features/forgot_password/view/ui/otp_screen.dart';
import '../../features/home/view/ui/home_screen.dart';
import '../../features/music_player/bindings/music_player_binding.dart';
import '../../features/music_player/view/ui/music_player_screen.dart';
import '../../features/pdf_viewer/bindings/pdf_viewer_binding.dart';
import '../../features/pdf_viewer/view/ui/pdf_viewer_screen.dart';
import '../../features/review/bindings/review_binding.dart';
import '../../features/review/sub_features/add_review/view/ui/add_review_screen.dart';
import '../../features/review/view/ui/review_screen.dart';
import '../../features/sign_in/view/ui/sign_in_screen.dart';
import '../../features/video_player/bindings/video_player_binding.dart';
import '../../features/video_player/view/ui/video_player_screen.dart';
import '../../features/voucher/sub_features/detail/view/ui/detail_voucher_screen.dart';
import '../../features/voucher/view/ui/voucher_screen.dart';

abstract class Pages {
  static final pages = [
    GetPage(
        name: Routes.splashRoute,
        page: () => SplashScreen(),
        binding: SplashBinding()),
    GetPage(
        name: Routes.signInRoute,
        page: () => SignInScreen(),
        binding: SignInBinding()),
    GetPage(
        name: Routes.forgotPasswordRoute,
        page: () => ForgotPasswordScreen(),
        binding: ForgotPasswordBinding()),
    GetPage(
        name: Routes.otpRoute,
        page: () => const OtpScreen(),
        binding: OtpBinding()),
    GetPage(
        name: Routes.homeRoute,
        page: () => HomeScreen(),
        binding: HomeBinding()),
    GetPage(
        name: Routes.detailMenuRoute,
        page: () => const DetailMenuScreen(),
        binding: DetailMenuBinding()),
    GetPage(
        name: Routes.detailOrderRoute,
        page: () => DetailOrderScreen(),
        binding: DetailOrderBinding()),
    GetPage(
        name: Routes.detailPromoRoute,
        page: () => const DetailPromoScreen(),
        binding: DetailPromoBinding()),
    GetPage(
        name: Routes.cartRoute,
        page: () => CartScreen(),
        binding: CartBinding()),
    GetPage(
        name: Routes.noConnectionRoute,
        page: () => NoConnectionScreen(),
        binding: NoConnectionBinding()),
    GetPage(
        name: Routes.compassRoute,
        page: () => CompassScreen(),
        binding: CompassBinding()),
    GetPage(
        name: Routes.musicPlayerRoute,
        page: () => MusicPlayerScreen(),
        binding: MusicPlayerBinding()),
    GetPage(
        name: Routes.videoPlayerRoute,
        page: () => VideoPlayerScreen(),
        binding: VideoPlayerBinding()),
    GetPage(
        name: Routes.pdfViewerRoute,
        page: () => PdfViewerScreen(),
        binding: PdfViewerBinding()),
    GetPage(
        name: Routes.reviewRoute,
        page: () => ReviewScreen(),
        binding: ReviewBinding()),
    GetPage(
      name: Routes.reviewAddReviewRoute,
      page: () => AddReviewScreen(),
      // binding: AddReviewBinding()
    ),
    GetPage(
        name: Routes.chatReviewRoute,
        page: () => ChatReviewScreen(),
        binding: ChatReviewBinding()),
    GetPage(
        name: Routes.voucherRoute,
        page: () => VoucherScreen(),
        binding: VoucherBinding()),
    GetPage(
      name: Routes.voucherDetailRoute,
      page: () => DetailVoucherScreen(),
      // binding: DetailBinding()
    ),
  ];
}
