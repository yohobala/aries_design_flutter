class AriMapSort {
  AriMapSort({
    this.order = 1,
    this.selected = false,
    this.originalIndex = 0,
  });

  /// 排序的位置
  int order;

  /// 是否被选择
  bool selected;

  /// 原始顺序,按插入到列表的顺序
  int originalIndex;
}
