//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<amap_core_fluttify/AmapCoreFluttifyPlugin.h>)
#import <amap_core_fluttify/AmapCoreFluttifyPlugin.h>
#else
@import amap_core_fluttify;
#endif

#if __has_include(<amap_location_fluttify/AmapLocationFluttifyPlugin.h>)
#import <amap_location_fluttify/AmapLocationFluttifyPlugin.h>
#else
@import amap_location_fluttify;
#endif

#if __has_include(<connectivity/FLTConnectivityPlugin.h>)
#import <connectivity/FLTConnectivityPlugin.h>
#else
@import connectivity;
#endif

#if __has_include(<core_location_fluttify/CoreLocationFluttifyPlugin.h>)
#import <core_location_fluttify/CoreLocationFluttifyPlugin.h>
#else
@import core_location_fluttify;
#endif

#if __has_include(<flutter_native_image/FlutterNativeImagePlugin.h>)
#import <flutter_native_image/FlutterNativeImagePlugin.h>
#else
@import flutter_native_image;
#endif

#if __has_include(<flutter_statusbarcolor/FlutterStatusbarcolorPlugin.h>)
#import <flutter_statusbarcolor/FlutterStatusbarcolorPlugin.h>
#else
@import flutter_statusbarcolor;
#endif

#if __has_include(<fluttertoast/FluttertoastPlugin.h>)
#import <fluttertoast/FluttertoastPlugin.h>
#else
@import fluttertoast;
#endif

#if __has_include(<foundation_fluttify/FoundationFluttifyPlugin.h>)
#import <foundation_fluttify/FoundationFluttifyPlugin.h>
#else
@import foundation_fluttify;
#endif

#if __has_include(<image_picker/FLTImagePickerPlugin.h>)
#import <image_picker/FLTImagePickerPlugin.h>
#else
@import image_picker;
#endif

#if __has_include(<jpush_flutter/JPushPlugin.h>)
#import <jpush_flutter/JPushPlugin.h>
#else
@import jpush_flutter;
#endif

#if __has_include(<path_provider/FLTPathProviderPlugin.h>)
#import <path_provider/FLTPathProviderPlugin.h>
#else
@import path_provider;
#endif

#if __has_include(<permission_handler/PermissionHandlerPlugin.h>)
#import <permission_handler/PermissionHandlerPlugin.h>
#else
@import permission_handler;
#endif

#if __has_include(<shared_preferences/FLTSharedPreferencesPlugin.h>)
#import <shared_preferences/FLTSharedPreferencesPlugin.h>
#else
@import shared_preferences;
#endif

#if __has_include(<barcode_scan/BarcodeScanPlugin.h>)
#import <barcode_scan/BarcodeScanPlugin.h>
#else
@import barcode_scan;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AmapCoreFluttifyPlugin registerWithRegistrar:[registry registrarForPlugin:@"AmapCoreFluttifyPlugin"]];
  [AmapLocationFluttifyPlugin registerWithRegistrar:[registry registrarForPlugin:@"AmapLocationFluttifyPlugin"]];
  [FLTConnectivityPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTConnectivityPlugin"]];
  [CoreLocationFluttifyPlugin registerWithRegistrar:[registry registrarForPlugin:@"CoreLocationFluttifyPlugin"]];
  [FlutterNativeImagePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterNativeImagePlugin"]];
  [FlutterStatusbarcolorPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterStatusbarcolorPlugin"]];
  [FluttertoastPlugin registerWithRegistrar:[registry registrarForPlugin:@"FluttertoastPlugin"]];
  [FoundationFluttifyPlugin registerWithRegistrar:[registry registrarForPlugin:@"FoundationFluttifyPlugin"]];
  [FLTImagePickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTImagePickerPlugin"]];
  [JPushPlugin registerWithRegistrar:[registry registrarForPlugin:@"JPushPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [BarcodeScanPlugin registerWithRegistrar:[registry registrarForPlugin:@"BarcodeScanPlugin"]];
}

@end
