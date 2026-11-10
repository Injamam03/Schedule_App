import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/screens/profileScreen/savedPhotos/controller/savedPhotosController.dart';
import 'package:jamal_flutter_app/utils/app_date_utils.dart';
import 'package:jamal_flutter_app/utils/app_files.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';

/// Full-screen swipeable viewer with pinch-to-zoom and delete.
class PhotoViewerScreen extends StatefulWidget {
  const PhotoViewerScreen({super.key});

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  final SavedPhotosController _controller = Get.find<SavedPhotosController>();
  late final PageController _pageController;
  late int _index;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    _index = args is int ? args : 0;
    _pageController = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final photos = _controller.photos;
    if (photos.isEmpty) return;
    final current = photos[_index.clamp(0, photos.length - 1)];
    final deleted = await _controller.delete(current);
    if (deleted && _controller.photos.isEmpty) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy4,
      body: Obx(() {
        final photos = _controller.photos;
        if (photos.isEmpty) return const Gap.h(0);
        final safeIndex = _index.clamp(0, photos.length - 1);
        return Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: photos.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (_, i) => InteractiveViewer(
                minScale: 1,
                maxScale: 5,
                child: Center(
                  child: Image.file(
                    AppFiles.photo(photos[i].fileName),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      AppIcons.image,
                      size: 64.w,
                      color: AppColors.secondary5,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppColors.navy4.withValues(alpha: 0.6),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: Get.back,
                          icon: Icon(AppIcons.arrowBack,
                              size: AppSize.iconS, color: AppColors.white),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              CustomText(
                                AppConstString.photoPosition(safeIndex + 1, photos.length),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                              CustomText(
                                AppDateUtils.formatDateTime(photos[safeIndex].createdAt),
                                fontSize: 11.5,
                                color: AppColors.primary3,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _delete,
                          icon: Icon(AppIcons.delete,
                              size: AppSize.iconM, color: AppColors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
