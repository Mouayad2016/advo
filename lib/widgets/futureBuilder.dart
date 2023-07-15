import 'dart:async';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/models/exception.dart';
import 'package:lawyer/widgets/shimmer.dart';
import 'package:lawyer/widgets/snackbar.dart';

class FutureBuilderWidget extends StatelessWidget {
  final Future<dynamic>? future;
  final Function? func;
  final Widget child;
  final Widget? onLowad;
  const FutureBuilderWidget(
      {super.key,
      required this.func,
      required this.child,
      required this.future,
      this.onLowad});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future?.timeout(const Duration(seconds: 5)),
        builder: (context, snapShpt) {
          if (snapShpt.connectionState == ConnectionState.waiting) {
            print("snapShpt waing ");

            return shimmerWidget(onLowad != null ? onLowad! : child);
          } else {
            if (snapShpt.error != null || snapShpt.hasError) {
              return Container(
                child: func != null
                    ? RefreshIndicator(
                        onRefresh: () async {
                          try {
                            await func!();
                          } on TimeoutException catch (e) {
                            print("FutureBuilder");

                            animatedSnackBarHelper(
                                e.message, AnimatedSnackBarType.error, context);
                          } on ErrorException catch (error) {
                            animatedSnackBarHelper(error.cause,
                                AnimatedSnackBarType.error, context);
                          }
                        },
                        child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics()
                                .applyTo(const BouncingScrollPhysics()),
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              padding: const EdgeInsets.all(16),
                              alignment: Alignment.topCenter,
                              // height: double.infinity,
                              // width: double.infinity,
                              child: const Text(
                                "Some thing wnet wrong.",
                              ),
                            )))
                    : Text(
                        "Fel inträffat",
                        style: TextStyle(color: Colors.red),
                      ),
              );
            } else {
              return child;
            }
          }
        });
  }
}
