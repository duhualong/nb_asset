# nbassetentry

小帮手，支持 iOS、Android 平台，主要功能NB设备扫码录入，NB设备选测，下发参数，调光，召测参数。采用 Google 的移动 UI 框架 [Flutter](https://flutter.io) 作为跨平台框架。Flutter 使用 [Dart](https://www.dartlang.org) 作为开发语言。

## 编译运行流程

1. 配置 Flutter 开发环境，参考 [安装 Flutter](https://flutterchina.club/get-started/install/) 和 [配置编辑器](https://flutterchina.club/get-started/editor/#androidsstudio)。
2. clone 代码，执行`$ flutter package get`安装外部包。
3. 执行`$ flutter run`。

## 外部包
编辑根目录下的 pubspec.yaml 文件， 外部包可在 [pub.dartlang.org](https://pub.dartlang.org/flutter/) 查找。

| 外部包 | 功能 | 
| ------ | ------ |
| [amap_location_fluttify](https://github.com/fluttify-project/amap_location_fluttify) | 高德地图定位 |
| [barcode_scan](https://github.com/mintware-de/flutter_barcode_reader) | 扫码 |
| [common_utils](https://github.com/Sky24n/common_utils) | 常用工具类库 |
| [flustars](https://github.com/Sky24n/flustars) | 常用工具类库 |
| [connectivity](https://github.com/flutter/plugins/tree/master/packages/connectivity) | 网络连接 |
| [cupertino_icons](https://github.com/flutter/cupertino_icons) | iOS 风格图标 |
| [device_info](https://github.com/flutter/plugins/tree/master/packages/device_info) | 版本信息 |
| [dio](https://github.com/flutterchina/dio) | 网络框架 |
| [dotted_border](https://github.com/ajilo297/Flutter-Dotted-Border) | 虚线边界 |
| [event_bus](https://github.com/marcojakob/dart-event-bus) | 事件传递 |
| [fluttertoast](https://github.com/PonnamKarthik/FlutterToast) | Toast |
| [flutter_cache_manager](https://github.com/renefloor/flutter_cache_manager) | 缓存管理 |
| [flutter_xlider](https://github.com/Ali-Azmoud/flutter_xlider) | 进度条 |
| [permission_handler](https://github.com/Baseflow/flutter-permission-handler) | 权限申请 |
| [image_picker](https://github.com/flutter/plugins/tree/master/packages/image_picker) | 本地图片 |
| [json_annotation](https://github.com/dart-lang/json_serializable) | JSON 模板 |
| [jpush_flutter](https://github.com/jpush/jpush-flutter-plugin) | 极光推送 |
| [package_info](https://github.com/flutter/plugins/tree/master/packages/package_info) | 包名信息 |
| [path_provider](https://github.com/flutter/plugins/tree/master/packages/path_provider) | 本地路径 |
| [photo_view](https://github.com/renancaraujo/photo_view) | 图片预览 |
| [shared_preferences](https://github.com/flutter/plugins/tree/master/packages/shared_preferences) | 偏好配置 |

## 常用命令

* 创建一个新的项目。
`$ flutter create <output directory>`

* 使用 Swift 和 JAVA 创建一个新的项目。
`$ flutter create -i swift -a java <output directory>`

* 运行项目。
`$ flutter run`

* 安装外部包。
`$ flutter package get`

* 升级 Flutter 版本。
`$ flutter upgrade`

* 诊断项目环境。
`$ flutter doctor`

* 外部包 json_serializable 生成模板文件。
`$ flutter packages pub run build_runner build`

* 外部包 json_serializable 会持续监听并生成模板文件。
`$ flutter packages pub run build_runner watch`

