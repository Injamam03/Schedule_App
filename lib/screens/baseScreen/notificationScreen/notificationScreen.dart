import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/screens/baseScreen/notificationScreen/controller/notificationController.dart';
import 'package:jamal_flutter_app/services/notification_feed_service.dart';
import 'package:jamal_flutter_app/utils/app_date_utils.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_app_bar/custom_app_bar.dart';
import 'package:jamal_flutter_app/widgers/custom_card/custom_card.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';
import 'package:jamal_flutter_app/widgers/empty_state/empty_state.dart';

class NotificationScreen extends GetView<NotificationsController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppConstString.notificationsTitle),
      body: Obx(() {
        final items = controller.items;
        final now = controller.now;
        if (items.isEmpty) {
          return EmptyState(
            icon: AppIcons.notificationOutlined,
            title: AppConstString.noNotifications,
            message: AppConstString.noNotificationsMessage,
          );
        }
        return ListView.separated(
          padding: EdgeInsets.all(AppSize.pagePadding),
          itemCount: items.length,
          separatorBuilder: (_, _) => const Gap.v(12),
          itemBuilder: (_, i) => _NotificationTile(
            item: items[i],
            isNew: controller.isNew(items[i]),
            now: now,
            onTap: () => controller.open(items[i]),
          ),
        );
      }),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.item,
    required this.isNew,
    required this.now,
    required this.onTap,
  });

  final AppNotificationItem item;
  final bool isNew;
  final DateTime now;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final (IconData icon, Color color) = switch (item.kind) {
      NotificationKind.reminder => (AppIcons.upcoming, p.primary),
      NotificationKind.start => (AppIcons.active, AppColors.success),
      NotificationKind.missed => (AppIcons.missed, AppColors.error),
    };

    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.all(14.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppSize.radiusS),
            ),
            child: Icon(icon, size: AppSize.iconM, color: color),
          ),
          const Gap.h(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        item.title,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        maxLines: 1,
                      ),
                    ),
                    if (isNew)
                      Container(
                        width: 9.w,
                        height: 9.w,
                        decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle),
                      ),
                  ],
                ),
                const Gap.v(4),
                CustomText(item.body, fontSize: 13, color: p.textSecondary, height: 1.4),
                const Gap.v(6),
                CustomText(
                  AppDateUtils.relative(item.time, now),
                  fontSize: 11.5,
                  color: p.textHint,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
