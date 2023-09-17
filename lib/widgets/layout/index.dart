import 'package:flutter/material.dart';

/// 用于在[CustomMultiChildLayout]中添加child
///
/// addTopPadding/addBottomPadding/addLeftPadding/addRightPadding 用于在原有的padding上添加padding
void addIfNonNull(
  BuildContext context,
  List<LayoutId> children,
  Widget? child,
  Object childId, {
  required bool removeLeftPadding,
  required bool removeTopPadding,
  required bool removeRightPadding,
  required bool removeBottomPadding,
  bool removeBottomInset = false,
  bool maintainBottomViewPadding = false,
  double addTopPadding = 0,
  double addBottomPadding = 0,
  double addLeftPadding = 0,
  double addRightPadding = 0,
}) {
  MediaQueryData data = MediaQuery.of(context).removePadding(
    removeLeft: removeLeftPadding,
    removeTop: removeTopPadding,
    removeRight: removeRightPadding,
    removeBottom: removeBottomPadding,
  );
  if (removeBottomInset) {
    data = data.removeViewInsets(removeBottom: true);
  }
  if (maintainBottomViewPadding && data.viewInsets.bottom != 0.0) {
    data = data.copyWith(
      padding: data.padding.copyWith(bottom: data.viewPadding.bottom),
    );
  }
  data = data.copyWith(
      padding: data.padding.copyWith(
    bottom: data.padding.bottom + addBottomPadding,
    top: data.padding.top + addTopPadding,
    left: data.padding.left + addLeftPadding,
    right: data.padding.right + addRightPadding,
  ));

  if (child != null) {
    children.add(
      LayoutId(
        id: childId,
        child: MediaQuery(data: data, child: child),
      ),
    );
  }
}
