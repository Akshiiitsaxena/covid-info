import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget loaderWidget(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 12),
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200.0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.grey.withOpacity(0.5),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          height: 300,
        ),
      ),
    ),
  );
}
