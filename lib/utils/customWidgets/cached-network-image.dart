
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sugudeni/utils/constants/colors.dart';

class MyCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? height;
  final double? width;
  final double? leftMargin;
  final double? rightMargin;
  final double? radius;

  const MyCachedNetworkImage({
    super.key, required this.imageUrl,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.leftMargin,
    this.rightMargin, this.radius


  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: leftMargin??0,right: rightMargin??0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius??10),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: fit,
          height:height??100.h,
          width:width?? 100.w,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: height ?? 100.h,
              width: width ?? 100.w,
              color: Colors.grey[300],
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: height ?? 100.h,
            width: width ?? 100.w,
            color: Colors.grey[200],
            child: Icon(Icons.image_not_supported, color: textSecondaryColor, size: 24.sp),
          ),
        ),
      ),
    );
  }
}