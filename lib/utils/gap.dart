import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive spacing. Use instead of SizedBox.
///   Gap.v(16)  -> vertical space (height)
///   Gap.h(12)  -> horizontal space (width)
class Gap extends StatelessWidget {
  const Gap.v(this.size, {super.key}) : _vertical = true;
  const Gap.h(this.size, {super.key}) : _vertical = false;

  final double size;
  final bool _vertical;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: _vertical ? size.h : null,
        width: _vertical ? null : size.w,
      );
}
