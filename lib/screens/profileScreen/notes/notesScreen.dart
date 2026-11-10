import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jamal_flutter_app/constant/app_assert_icons.dart';
import 'package:jamal_flutter_app/constant/app_colors.dart';
import 'package:jamal_flutter_app/constant/app_const_string.dart';
import 'package:jamal_flutter_app/model/note_model.dart';
import 'package:jamal_flutter_app/screens/profileScreen/notes/controller/notesController.dart';
import 'package:jamal_flutter_app/utils/app_date_utils.dart';
import 'package:jamal_flutter_app/utils/app_size.dart';
import 'package:jamal_flutter_app/utils/gap.dart';
import 'package:jamal_flutter_app/widgers/custom_app_bar/custom_app_bar.dart';
import 'package:jamal_flutter_app/widgers/custom_card/custom_card.dart';
import 'package:jamal_flutter_app/widgers/custom_text/custom_text.dart';
import 'package:jamal_flutter_app/widgers/custombutton/custombutton.dart';
import 'package:jamal_flutter_app/widgers/empty_state/empty_state.dart';

class NotesScreen extends GetView<NotesController> {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: AppConstString.notesTitle),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.create,
        icon: Icon(AppIcons.add, size: AppSize.iconM),
        label: CustomText(
          AppConstString.createNote,
          fontWeight: FontWeight.w700,
          color: AppColors.of(context).onPrimary,
        ),
      ),
      body: Obx(() {
        final notes = controller.notes;
        if (notes.isEmpty) {
          return EmptyState(
            icon: AppIcons.note,
            title: AppConstString.noNotes,
            message: AppConstString.noNotesMessage,
            action: CustomButton(
              label: AppConstString.createNote,
              icon: AppIcons.add,
              fullWidth: false,
              height: 44.h,
              onTap: controller.create,
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.fromLTRB(
              AppSize.pagePadding, AppSize.pagePadding, AppSize.pagePadding, 100.h),
          itemCount: notes.length,
          separatorBuilder: (_, __) => const Gap.v(12),
          itemBuilder: (_, i) => _NoteCard(
            note: notes[i],
            onTap: () => controller.edit(notes[i]),
            onDelete: () => controller.delete(notes[i]),
          ),
        );
      }),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note, required this.onTap, required this.onDelete});

  final NoteModel note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final p = AppColors.of(context);
    final hasTitle = note.title.isNotEmpty;
    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 6.w, 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  hasTitle ? note.title : AppConstString.untitledNote,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  maxLines: 1,
                  color: hasTitle ? p.textPrimary : p.textHint,
                ),
                const Gap.v(6),
                CustomText(
                  note.content,
                  fontSize: 13,
                  color: p.textSecondary,
                  maxLines: 3,
                  height: 1.45,
                ),
                const Gap.v(10),
                CustomText(
                  AppDateUtils.formatDateTime(note.updatedAt),
                  fontSize: 11.5,
                  color: p.textHint,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(AppIcons.delete, size: AppSize.iconM, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
