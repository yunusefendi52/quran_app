import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHelpers {
  static Widget createShimmer({
    @required Widget child,
  }) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: child);
  }

  static Widget createShimmerLoading({
    @required bool isLoading,
    @required Widget loadingChild,
    @required Widget child,
  }) {
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: loadingChild,
          )
        : child;
  }
}
