import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sugudeni/models/activity/ActivityResponseModel.dart';
import 'package:sugudeni/providers/notification-provider.dart';
import 'package:sugudeni/utils/constants/app-assets.dart';
import 'package:sugudeni/utils/constants/colors.dart';
import 'package:sugudeni/utils/customWidgets/app-bar-title-widget.dart';
import 'package:sugudeni/utils/customWidgets/my-text.dart';
import 'package:sugudeni/utils/customWidgets/round-button.dart';
import 'package:sugudeni/utils/customWidgets/shimmer-widgets.dart';
import 'package:sugudeni/utils/customWidgets/symetric-padding.dart';
import 'package:sugudeni/utils/extensions/sizebox.dart';
import 'package:sugudeni/utils/global-functions.dart';

import '../../l10n/app_localizations.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications(context);
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('hh:mm a').format(date);
  }

  Map<String, List<Activity>> _groupActivitiesByDate(List<Activity> activities) {
    final Map<String, List<Activity>> grouped = {};
    
    for (var activity in activities) {
      final dateKey = _formatDate(activity.createdAt);
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(activity);
    }
    
    return grouped;
  }

  IconData _getActivityIcon(String? type) {
    switch (type?.toLowerCase()) {
      case 'order':
        return Icons.shopping_bag_outlined;
      case 'payment':
        return Icons.payment_outlined;
      case 'delivery':
        return Icons.local_shipping_outlined;
      case 'product':
        return Icons.inventory_2_outlined;
      case 'review':
        return Icons.star_outline;
      case 'message':
        return Icons.message_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getActivityIconColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'order':
        return primaryColor;
      case 'payment':
        return Colors.green;
      case 'delivery':
        return Colors.blue;
      case 'product':
        return Colors.orange;
      case 'review':
        return Colors.amber;
      case 'message':
        return Colors.purple;
      default:
        return textPrimaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        toolbarHeight: 80.h,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Material(
                elevation: 2,
                shape: const CircleBorder(),
                child: Container(
                  height: 44.h,
                  width: 44.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withOpacity(0.15),
                    border: Border.all(color: whiteColor, width: 5),
                  ),
                  child: Center(
                    child: Image.asset(
                      AppAssets.arrowBack,
                      scale: 3,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            AppBarTitleWidget(
              title: AppLocalizations.of(context)!.notifications,
            ),
            const Spacer(),
          ],
        ),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          return RefreshIndicator(
            onRefresh: () => notificationProvider.loadNotifications(context),
            child: notificationProvider.isLoading
                ? ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        child: const ListItemShimmer(height: 80),
                      );
                    },
                  )
                : notificationProvider.notifications.isEmpty
                    ? _buildEmptyState()
                    : (() {
                        final groupedActivities = _groupActivitiesByDate(notificationProvider.notifications);
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                          itemCount: groupedActivities.length,
                          itemBuilder: (context, index) {
                            final dateKey = groupedActivities.keys.elementAt(index);
                            final dateActivities = groupedActivities[dateKey]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Date header
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
                                  child: MyText(
                                    text: dateKey,
                                    size: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimaryColor.withOpacity(0.6),
                                  ),
                                ),
                                // Activities for this date
                                ...dateActivities.map((activity) => _buildActivityItem(activity, notificationProvider)),
                              ],
                            );
                          },
                        );
                      })(),
          );
        },
      ),
    );
  }

  Widget _buildActivityItem(Activity activity, NotificationProvider notificationProvider) {
    final isRead = activity.isRead ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Mark as read when tapped
            if (!isRead) {
              notificationProvider.markAsRead(activity.id);
            }
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: _getActivityIconColor(activity.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    _getActivityIcon(activity.type),
                    color: _getActivityIconColor(activity.type),
                    size: 24.sp,
                  ),
                ),
                12.width,
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      if (activity.title != null && activity.title!.isNotEmpty)
                        MyText(
                          text: activity.title!,
                          size: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isRead ? textPrimaryColor : blackColor,
                          maxLine: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (activity.title != null && activity.title!.isNotEmpty) 4.height,
                      // Description
                      if (activity.description != null && activity.description!.isNotEmpty)
                        MyText(
                          text: activity.description!,
                          size: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: textPrimaryColor.withOpacity(0.7),
                          maxLine: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      8.height,
                      // Time
                      MyText(
                        text: _formatTime(activity.createdAt),
                        size: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: textPrimaryColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
                // Unread indicator
                if (!isRead)
                  Container(
                    width: 8.w,
                    height: 8.h,
                    margin: EdgeInsets.only(left: 8.w),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_outlined,
                size: 64.sp,
                color: textPrimaryColor.withOpacity(0.3),
              ),
            ),
            24.height,
            MyText(
              text: 'No Notifications',
              size: 18.sp,
              fontWeight: FontWeight.w600,
              color: textPrimaryColor,
            ),
            12.height,
            MyText(
              text: 'You don\'t have any notifications yet. We\'ll notify you when something important happens.',
              size: 14.sp,
              fontWeight: FontWeight.w400,
              color: textPrimaryColor.withOpacity(0.6),
              textAlignment: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

