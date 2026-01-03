import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';

/// Professional SpinKit loader widget for consistent loading states
class SpinKitLoader extends StatelessWidget {
  final Color? color;
  final double? size;
  final SpinKitType type;

  const SpinKitLoader({
    super.key,
    this.color,
    this.size,
    this.type = SpinKitType.circle,
  });

  @override
  Widget build(BuildContext context) {
    final loaderColor = color ?? primaryColor;
    final loaderSize = size ?? 40.sp;

    switch (type) {
      case SpinKitType.circle:
        return SpinKitCircle(
          color: loaderColor,
          size: loaderSize,
        );
      case SpinKitType.fadingCircle:
        return SpinKitFadingCircle(
          color: loaderColor,
          size: loaderSize,
        );
      case SpinKitType.pulse:
        return SpinKitPulse(
          color: loaderColor,
          size: loaderSize,
        );
      case SpinKitType.ring:
        return SpinKitRing(
          color: loaderColor,
          size: loaderSize,
        );
      case SpinKitType.doubleBounce:
        return SpinKitDoubleBounce(
          color: loaderColor,
          size: loaderSize,
        );
      case SpinKitType.wave:
        return SpinKitWave(
          color: loaderColor,
          size: loaderSize,
        );
      default:
        return SpinKitCircle(
          color: loaderColor,
          size: loaderSize,
        );
    }
  }
}

/// Full screen centered loader
class FullScreenSpinKitLoader extends StatelessWidget {
  final Color? color;
  final double? size;
  final SpinKitType type;
  final String? message;

  const FullScreenSpinKitLoader({
    super.key,
    this.color,
    this.size,
    this.type = SpinKitType.circle,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitLoader(
            color: color,
            size: size,
            type: type,
          ),
          if (message != null) ...[
            20.height,
            Text(
              message!,
              style: TextStyle(
                fontSize: 14.sp,
                color: textPrimaryColor.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

enum SpinKitType {
  circle,
  fadingCircle,
  pulse,
  ring,
  doubleBounce,
  wave,
}

