import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void mockGeolocator() {
  const channel = MethodChannel('flutter.baseflow.com/geolocator');
  
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    if (methodCall.method == 'isLocationServiceEnabled') {
      return true;
    }
    if (methodCall.method == 'checkPermission') {
      return 0; // 0: denied, 1: deniedForever, 2: whileInUse, 3: always
    }
    if (methodCall.method == 'requestPermission') {
      return 0; // denied
    }
    if (methodCall.method == 'getCurrentPosition') {
      return {
        'latitude': 37.5665,
        'longitude': 126.9780,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'accuracy': 15.0,
        'altitude': 0.0,
        'heading': 0.0,
        'speed': 0.0,
        'speed_accuracy': 0.0,
      };
    }
    return null;
  });
}
