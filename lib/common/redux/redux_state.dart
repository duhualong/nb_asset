import 'package:flutter/material.dart';
import 'redux.dart';

/// 全局 Redux store 对象，保存 State 数据
class ReduxState {
  /// 主题数据
  ThemeData themeData;

  /// 构造方法
  ReduxState({
    this.themeData,
  });
}

ReduxState appReducer(ReduxState state, action) {
  return ReduxState(
    themeData: themeDataReducer(state.themeData, action),
  );
}
