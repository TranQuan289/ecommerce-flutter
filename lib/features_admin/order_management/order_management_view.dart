import 'package:ecommerce_flutter/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderManagementView extends HookWidget {
  const OrderManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorUtils.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: ColorUtils.primaryBackgroundColor,
        title: Text(
          'Order Management',
          style: TextStyle(
            color: ColorUtils.primaryColor,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
