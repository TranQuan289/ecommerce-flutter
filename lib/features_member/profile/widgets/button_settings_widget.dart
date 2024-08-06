import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ButtonSettingsWidget extends StatelessWidget {
  final Widget? icon;
  final String? title;
  final Function()? onPressed;

  const ButtonSettingsWidget({
    super.key,
    this.icon,
    this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => Colors.transparent,
        ),
        shadowColor: WidgetStateProperty.resolveWith(
          (states) => Colors.transparent,
        ),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => ColorUtils.blueDartLightColor,
        ),
        elevation: WidgetStateProperty.resolveWith<double>(
          (states) => 0,
        ),
        shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
          (states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(right: 25),
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorUtils.primaryColor,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: icon,
            ),
            Text(
              title ?? '',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ColorUtils.primaryColor,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
