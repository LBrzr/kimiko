import 'package:flutter/cupertino.dart';

class KimikoPersistentDelegate extends SliverPersistentHeaderDelegate {
  final double max, min;
  final Widget child;

  const KimikoPersistentDelegate({
    double? max,
    required this.min,
    required this.child,
  }) : max = max ?? min;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => max;

  @override
  double get minExtent => min;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
