import 'package:ekskul/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const CustomWidget.rectangular(
      {Key? key, this.width = double.infinity, required this.height})
      : shapeBorder = const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        super(key: key);

  const CustomWidget.circular(
      {Key? key,
      this.width = double.infinity,
      required this.height,
      this.shapeBorder = const CircleBorder()})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: bone,
        highlightColor: Colors.white.withOpacity(.8),
        period: const Duration(seconds: 2),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Colors.black,
            shape: shapeBorder,
          ),
        ),
      );
}
