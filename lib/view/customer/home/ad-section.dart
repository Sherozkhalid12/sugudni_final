import 'dart:async';

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
  Timer? _autoScrollTimer;
  Future? _bannersFuture;
  List? _cachedBanners;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    pageController.addListener(_onPageChanged);

    // Cache the future to prevent re-fetching on rebuilds
    _bannersFuture = BannersRepository.allBannersPagination(context, 1);
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    pageController.removeListener(_onPageChanged);
    pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HomeAdSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Restart auto-scrolling if data changed
    _autoScrollTimer?.cancel();
  }

  void _startAutoScroll(int itemCount) {
    if (itemCount <= 1) return;

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      final nextPage = (currentPage + 1) % itemCount;
      pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
  }

  void _onPageChanged() {
    if (!mounted) return;

    final newPage = pageController.page?.round() ?? 0;
    if (newPage != currentPage) {
      setState(() {
        currentPage = newPage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _bannersFuture,
      builder: (context, snapshot) {
        // Show shimmer while loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const BannerShimmer();
        }
        
        // Show shimmer on error (graceful degradation)
        if (snapshot.hasError || snapshot.data == null) {
          return const SizedBox.shrink();
        }

        // Cache the data to prevent re-processing
        if (_cachedBanners == null) {
          _cachedBanners = snapshot.data!.getAllProducts;
        }

        final data = _cachedBanners!;

        // Return empty if no banners
        if (data.isEmpty) {
          return const SizedBox.shrink();
        }

        // Start auto-scrolling if not already started
        if (_autoScrollTimer == null && data.length > 1) {
          _startAutoScroll(data.length);
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
                child: GestureDetector(
                  onTapDown: (_) => _stopAutoScroll(),
                  onTapUp: (_) {
                    if (data.length > 1) {
                      _startAutoScroll(data.length);
                    }
                  },
                  onHorizontalDragStart: (_) => _stopAutoScroll(),
                  onHorizontalDragEnd: (_) {
                    if (data.length > 1) {
                      _startAutoScroll(data.length);
                    }
                  },
                  child: PageView.builder(
                    controller: pageController,
                    physics: const BouncingScrollPhysics(),
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
                  onDotClicked: (index) {
                    pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
