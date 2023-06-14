import 'package:animated_snack_bar/animated_snack_bar.dart';

dynamic animatedSnackBarHelper(
    String? error, AnimatedSnackBarType type, context) {
  return AnimatedSnackBar.material(
          error ?? "Ett fel uppstod, vänligen Försök igen senare.",
          duration: const Duration(seconds: 4),
          type: type,
          mobileSnackBarPosition: MobileSnackBarPosition
              .bottom, // Position of snackbar on mobile devices
          desktopSnackBarPosition: DesktopSnackBarPosition
              .topRight, // Position of snackbar on desktop devices
          snackBarStrategy: RemoveSnackBarStrategy())
      .show(context);
}

dynamic removeAnimatedSnacKBar(error, AnimatedSnackBarType type, context) {
  // a = AnimatedSnackBar()
  return AnimatedSnackBar.material(error,
          duration: const Duration(seconds: 4),
          type: type,
          mobileSnackBarPosition: MobileSnackBarPosition
              .bottom, // Position of snackbar on mobile devices
          desktopSnackBarPosition: DesktopSnackBarPosition
              .topRight, // Position of snackbar on desktop devices
          snackBarStrategy: RemoveSnackBarStrategy())
      .remove();
}
