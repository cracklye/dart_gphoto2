import 'dart:io';

import 'package:dart_gphoto2/dart_gphoto2.dart';
import 'package:dart_gphoto2/src/gphoto2_2.dart';
import 'package:test/test.dart';

void main() {
  String path = "/root/.local/lib/libgphoto2.so";

  group('A group of tests', () {
    final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.isAwesome, isTrue);
    });
    test('Camera Test', () async {
      // gphoto.
      GPhoto2 gp = GPhoto2();
      var lst = await gp.listCameras();

      print("Returned list $lst");

      await gp.close();
    });
    test('Captiure', () async {
      GPhoto2 camera = GPhoto2();
      try {
        camera.open();

        camera.capture();
      } finally {
        camera.close();
      }
    });
    test('capture with wait', () async {
      GPhoto2 camera = GPhoto2();
      try {
        camera.open();
        camera.waitForCaptureEvent(true);
        camera.capture();
      } finally {
        camera.close();
      }
    });
    test('capture and download', () async {
      GPhoto2 camera = GPhoto2();
      try {
        camera.open();
        var image = await camera.captureAndDownload(true);
        print("Have iamge ${image.absolute} exists: ${image.existsSync()}");
        assert(image.existsSync(), true);
        image.deleteSync();
      } finally {
        camera.close();
      }
    });
    test('Capture and Download With Wait', () async {
      GPhoto2 camera = GPhoto2();
      try {
        camera.open();
        camera.waitForCaptureEvent(true);
        var image = await camera.captureAndDownload(true);
        print("Have iamge ${image.absolute}");
        assert(image.existsSync(), true);
        image.deleteSync();
      } finally {
        camera.close();
      }
    });
    test('Burst and downlod', () async {
      GPhoto2 camera = GPhoto2();
      try {
        camera.open();
        camera.setConfig("burstnumber", "5");
        var images = camera.burstAndDownload(true);
        for (File image in images) {
          print("Have iamge ${image.absolute}");
          assert(image.existsSync(), true);
          image.deleteSync();
        }
        camera.setConfig("burstnumber", "1");
      } finally {
        camera.close();
      }
    });
    test('Test Config', () async {
      GPhoto2 camera = GPhoto2();

      /**
         * This parameter was chosen as it is likely that all cameras
         * support it.
         */
      String parameter = "isoauto";
      try {
        camera.open();
        String v = camera.getConfig(parameter);
        camera.setConfig(parameter, "Off");
        assert(camera.getConfig(parameter) == ("Off"), true);
        camera.setConfig(parameter, "On");
        assert(camera.getConfig(parameter) == ("On"), true);
        camera.setConfig(parameter, v);
        assert(camera.getConfig(parameter) == (v), true);
      } finally {
        camera.close();
      }
    });
    test('Camera List', () async {
      GPhoto2 camera = GPhoto2();
      var cameras = await camera.listCameras();
      assert(cameras.isEmpty, false);
    });

    test('List While Open', () async {
      GPhoto2 camera = GPhoto2();
      try {
        camera.open();
      } catch (ex) {
        fail("GPhoto2.open() threw exception.");
      }

      try {
        var cameras = camera.listCameras();
      } finally {
        camera.close();
      }
    });
  });
}
