import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/repositories/banners/get-banners.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';

class HomeAdSection extends StatefulWidget {
  const HomeAdSection({super.key});

  @override
  State<HomeAdSection> createState() => _HomeAdSectionState();
}

class _HomeAdSectionState extends State<HomeAdSection> {
  late PageController pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: BannersRepository.allBannersPagination(context, 1),
      builder: (context, snapshot) {
        // Show shimmer while loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const BannerShimmer();
        }
        
        // Show shimmer on error (graceful degradation)
        if (snapshot.hasError || snapshot.data == null) {
          return const SizedBox.shrink();
        }
        
        final data = snapshot.data!.getAllProducts;
        
        // Return empty if no banners
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }
        
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 99.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: PageView.builder(
                  controller: pageController,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final bannerData = data[index];
                    final imageUrl = "${ApiEndpoints.productUrl}/${bannerData.banner}";
                    
                    return CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const BannerShimmer(),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: const Center(
                          child: Icon(Icons.image_not_supported, color: greyColor),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (data.length > 1)
              Positioned(
                bottom: 10,
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: data.length,
                  effect: JumpingDotEffect(
                    dotHeight: 7.h,
                    dotWidth: 7.w,
                    activeDotColor: primaryColor,
                    dotColor: primaryColor.withOpacity(0.3),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
