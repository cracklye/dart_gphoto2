import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:dart_gphoto2/src/generated/libgphoto2_bindings.dart';
import 'package:dart_gphoto2/src/gphoto2_config.dart';
import 'package:dart_gphoto2/src/model/gphoto_camera.dart';
import 'package:ffi/ffi.dart';

/// FFI bindings for libgphoto2 would go here.
/// You'd need to generate these using `ffi` and possibly `ffigen`.
//https://github.com/angryelectron/libgphoto2-jna/blob/master/src/com/angryelectron/gphoto2/GPhoto2.java
//https://github.com/angryelectron/libgphoto2-jna/blob/master/src/com/angryelectron/gphoto2/GPhoto2.java
//https://github.com/gphoto/libgphoto2/blob/master/examples/sample-tether.c


class GPhoto2 {
  late DynamicLibrary gphoto2;
  late Pointer<GPContext> context;
  Pointer<Pointer<Camera>>? camera;
  late LibGPhoto2 _instance;
  String? error;
  String? message;
  bool _waitForCaptureEvent = false;

  GPhoto2([String pathToDll= 'libgphoto2.so']) {
    ///home/rock/.local/include/Gphoto2
    ////home/rock/.local/lib/l
    
    gphoto2 = DynamicLibrary.open(pathToDll);

    // context = gp_context_new();
    _instance = LibGPhoto2(gphoto2);
    context = _instance.gp_context_new();
    Pointer<Pointer<Void>> handle = calloc();

    //Pointer<NativeFunction<UnsignedInt Function(Pointer<_GPContext>, Pointer<Void>)>> func,

    //  _instance.gp_context_set_cancel_func(context, Pointer.fromFunction(handleCancel), handle.value);
    //  _instance.gp_context_set_message_func(context, func, handle.value);

    // Set error and message callbacks here using FFI.
  }
  //https://groups.google.com/a/dartlang.org/g/misc/c/-w0zIbk8YhM?pli=1

  // UnsignedInt handleCancel(Pointer<GPContext> context, Pointer<Void> val){

  // }

  Future<void> close() async {
    if (camera != null) {
      calloc.free(camera!);
    }
    calloc.free(context);
  }

  void test() {
    using((Arena arena) {
      final p = arena<Uint32>();
      // Use the memory allocated to `p`.
    });
    // Memory freed
  }

  /// *
  /// Wait for camera to generate a capture event before returning. Default
  /// behavior is not to wait (wait = false).
  /// <p>
  /// After a 'capture', some cameras will return immediately but before the
  /// image has been generated. Enable waitForCaptureEvent() to ensure the
  /// image is ready.</p>
  /// <p>
  /// Other cameras block internally until the image is ready, and therefore
  /// don't generate capture events. These devices will timeout if
  /// waitForCaptureEvent() is enabled.</p>
  ///
  /// @param wait When true, capture methods will block until the camera
  /// returns a Capture or Timeout event.
  void waitForCaptureEvent(bool wait) {
    _waitForCaptureEvent = wait;
  }

  ///
  /// Enumerate all cameras currently attached.  Will fail unless all attached
  /// cameras are closed().
  ///
  /// @return A list of Camera objects.
  /// @

  /// List cameras (stub, actual FFI implementation needed)
  Future<List<GPhotoCamera>> listCameras() async {
    // Implement FFI calls to enumerate cameras.
    /*
         * This is an rather absurd amount of code for what it actually
         * accomplishes in the end.         
         */
    int rc;

    if (camera != null) {
      throw Exception("Can't list cameras while devices are open.");
    }

    /*
         * Create and load an Abilities List.
         */

    // Error.CheckError(gp_camera_new(out native)); // Placeholder for error checking
    // handle = native;
    Pointer<Pointer<CameraAbilitiesList>> refAbilitiesList = calloc();

    // List<CameraAbilitiesList> refAbilitiesList = List<CameraAbilitiesList>();

    rc = _instance.gp_abilities_list_new(refAbilitiesList);
    if (rc != GP_OK) {
      throw Exception("gp_abilities_list_new failed with code $rc ");
    }

    Pointer<CameraAbilitiesList> cameraAbilitiesList = refAbilitiesList[0];
    rc = _instance.gp_abilities_list_load(cameraAbilitiesList, context);
    if (rc != GP_OK) {
      throw Exception("gp_abilities_list_load failed with code $rc");
    }

    /*
         * Create and load a Ports List.
         */
    Pointer<Pointer<GPPortInfoList>> refPortList = calloc();

    rc = _instance.gp_port_info_list_new(refPortList);
    if (rc != GP_OK) {
      throw Exception("gp_port_info_list_new failed with code $rc");
    }

    Pointer<GPPortInfoList> portInfoList = refPortList[0];
    rc = _instance.gp_port_info_list_load(portInfoList);
    if (rc != GP_OK) {
      throw Exception("gp_port_info_list_load failed with code $rc");
    }

    /*
         * Create and load a Cameras List from the Ports and Abilities lists.
         */
    Pointer<Pointer<CameraList>> refCameraList = calloc();
    rc = _instance.gp_list_new(refCameraList);
    if (rc != GP_OK) {
      throw Exception("gp_list_new failed with code $rc");
    }

    Pointer<CameraList> cameraList = refCameraList[0];
    rc = _instance.gp_abilities_list_detect(
      cameraAbilitiesList,
      portInfoList,
      cameraList,
      context,
    );
    if (rc != GP_OK) {
      throw Exception("gp_abilities_list_detect failed with code $rc");
    }

    /*
         * Convert the Cameras List into a list of Camera objects
         */
    List<GPhotoCamera> cList = [];

    int size = _instance.gp_list_count(cameraList);
    Pointer<Pointer<Char>> model = calloc();
    Pointer<Pointer<Char>> port = calloc();
    print("Size=$size");

    for (int i = 0; i < size; i++) {
      /*
             * Get Model
             */
      rc = _instance.gp_list_get_name(cameraList, i, model);
      if (rc != GP_OK) {
        throw Exception("gp_list_get_name failed with code $rc");
      }

      /*
             * Get Port
             */
      rc = _instance.gp_list_get_value(cameraList, i, port);
      if (rc != GP_OK) {
        throw Exception("gp_list_get_value failed with code $rc");
      }

      /*
             * Create new Camera Object
             */
      Pointer<Pointer<Camera>> refCamera = calloc();
      _instance.gp_camera_new(refCamera);
      // Camera c = Camera(refCamera.getValue());
      //TODO need to get the latest values
      /*
             * Get List of Abilities for this Model, then associate the 
             * Abilities with a Camera
             */
      Pointer<CameraAbilities> cameraAbilities = calloc();

      // CameraAbilities.ByValue cameraAbilities = new CameraAbilities.ByValue();
      int modelIndex = _instance.gp_abilities_list_lookup_model(
        cameraAbilitiesList,
        model[0],
      );
      _instance.gp_abilities_list_get_abilities(
        cameraAbilitiesList,
        modelIndex,
        cameraAbilities,
      );
      _instance.gp_camera_set_abilities(refCamera.value, cameraAbilities.ref);

      /*
             * Do the same for the Port.  TODO: verify return codes.
             */
      // GPPortInfo.ByValue portInfo = new GPPortInfo.ByValue();
      Pointer<GPPortInfo> portInfo = calloc();

      _instance.gp_port_info_list_lookup_path(portInfoList, port[0]);
      _instance.gp_port_info_list_get_info(portInfoList, i, portInfo);
      _instance.gp_camera_set_port_info(refCamera.value, portInfo.value);

      /*
             * Finally, add this Camera to the List
             */
      cList.add(GPhotoCamera());
    }
    print("Got list");
    /*
         * Whew!  That was a lot of work just to enumerate some cameras!
         */
    return cList;
  }

  /// Open camera connection (single camera). If multiple cameras are connected
  /// only the first detected camera is used.
  ///
  /// @ If camera cannot be opened.
  // /// Open first camera
  Future<void> open() async {
    camera = calloc();

    int result1 = _instance.gp_camera_new(camera!);
    if (result1 != GP_OK) throw Exception(error);

    int result = _instance.gp_camera_init(camera!.value, context);
    if (result != GP_OK) throw Exception(error);
    // throw UnimplementedError('FFI bindings required');
  }

  /// Open specific camera
  Future<void> openCamera(Pointer<Pointer<Camera>> cameraPtr) async {
    camera = cameraPtr;
    int rc = _instance.gp_camera_init(camera!.value, context);
    if (rc != GP_OK) throw Exception('gp_camera_init failed');
  }

  /// Close camera
  void destroy() {
    _instance.gp_camera_exit(camera!.value, context);
    _instance.gp_context_unref(context);
    _instance.gp_camera_unref(camera!.value);
  }

  /// Capture image (stub)
  Future<String> capture() async {
    CameraFilePath path = captureImage();
    return convertCArrayToString(path.name);
  }
    /**
     * Take a picture and save it to disk. Currently images can only be saved
     * into the current working directory.
     *
     * @param delete True if image should be removed from camera after saving.
     * @return a File object which points to the saved image.
     * @ If image cannot be captured or saved.
     */
  /// Capture and download image (stub)
  Future<File> captureAndDownload(bool delete) async {
    CameraFilePath path = captureImage();
    return saveImage(path, delete);
  }

    /// Don't take a picture, rather wait for camera to capture an image, then
    /// download. Call in a loop to create a tethered-shooting mode.
    ///
    /// @param timeout Time to wait before aborting (in milliseconds).
    /// @param delete If true, image is deleted from camera after downloading.
    /// @return A File which points to the new image on disk.
    /// @ on camera error
    /// @throws InterruptedException when timeout is reached.
    File captureTethered(int timeout, bool delete)  {
        int rc;
        // IntBuffer eventType = IntBuffer.allocate(1);
        // CameraFilePath path = CameraFilePath();
        // PointerByReference ref = new PointerByReference(path.getPointer());
Pointer<CameraFilePath> path = calloc();
Pointer<Pointer<Void>> ref = calloc();
Pointer<UnsignedInt> eventType = calloc();
        /*
         * need to loop, othewise GP_EVENT_UNKNOWN is almost always returned
         */
        while (true) {
            rc = _instance.gp_camera_wait_for_event(camera!.value, timeout, eventType, ref, context);
            if (rc != GP_OK) {
                throw Exception("Wait for Event failed with code $rc" );
            }
            if (CameraEventType.fromValue(eventType.value) == CameraEventType.GP_EVENT_FILE_ADDED) {
                return saveImage(path.ref, delete);
            } else if (CameraEventType.fromValue(eventType.value) == CameraEventType.GP_EVENT_TIMEOUT) {
                throw Exception("Timeout occured waiting for GP_EVENT_FILE_ADDED.");
            }
        }
    }

  /// Fire the shutter, then download all images on the camera. Useful when
  /// using burstmode, which may capture multiple images for one captureImage()
  /// call.
  ///
  /// @param delete If true, *all* images on the camera should be removed after
  /// saving.
  /// @return An List of File objects representing the saved images.
  /// @ if images cannot be captured or saved.
     List<File> burstAndDownload(bool delete)  {
        return saveImages(captureImage(), delete);
    }

    /// Change a single camera setting. If updating several parameters at once,
    /// it may be more efficient to use {@link
    /// com.angryelectron.gphoto2.GPhoto2Config#getParameter(java.lang.String)}.
    ///
    /// @param param The name of the parameter to set.
    /// @param value The value of the parameter.
    /// @
     void setConfig(String param, String value)  {
        GPhoto2Config config =  GPhoto2Config(this);
        config.readConfig();
        config.setParameter(param, value);
        config.writeConfig();
    }

    /// Read a single camera setting. If reading several parameters at once it
    /// may be more efficient to use
    /// {@link com.angryelectron.gphoto2.GPhoto2Config#getParameter(java.lang.String)}.
    ///
    /// @param param Parameter to be read.
    /// @return Value of the parameter. Date values are returned as unix-time
    /// strings.
    /// @ if the parameter cannot be read.
     String getConfig(String param)  {
        GPhoto2Config config =  GPhoto2Config(this);
        config.readConfig();
        String value = config.getParameter(param);
        return value;
    }

  // /// Internal: wait for event (stub)
  // Future<void> waitForEvent(int timeout, int event) async {
  //   throw UnimplementedError('FFI bindings required');
  // }
    /// Wait (block) until the specified event is received or a timeout occurs.
    ///
    /// @param timeout Timeout value, in milliseconds
    /// @param event expected CameraEventType
    /// @ if Timeout occurs or camera is unreachable.
    void waitForEvent(int timeout, CameraEventType event)  {
        // IntBuffer i = IntBuffer.allocate(1);
        // int i=0;
        // PointerByReference data = new PointerByReference();
        int rc;

 Pointer<UnsignedInt> eventtype = calloc();
  Pointer<Pointer<Void>> data = calloc();
  

        /*
         * need to loop, othewise GP_EVENT_UNKNOWN is almost always returned
         */
        while (true) {
            rc = _instance.gp_camera_wait_for_event(camera!.value, timeout, eventtype, data, context);
            if (rc != GP_OK) {
                throw Exception("Wait for Event failed with code $rc" );
            }
            if (CameraEventType.fromValue(eventtype.value) == event) {
                return;
            } else if (CameraEventType.fromValue(eventtype.value)== CameraEventType.GP_EVENT_TIMEOUT) {
                throw Exception("Timeout occured waiting for event $event" );
            }
        }
    }
  /// Capture an Image.
  ///
  /// @return CameraFilePath which references the captured image.
  /// @ If image cannot be captured.
  CameraFilePath captureImage() {
    Pointer<CameraFilePath> cameraFilePath = calloc();

    int result = _instance.gp_camera_capture(
      camera!.value,
      CameraCaptureType.GP_CAPTURE_IMAGE,
      cameraFilePath,
      context,
    );

    if (result != GP_OK) {
      throw Exception("$error($result)");
    }

    if (_waitForCaptureEvent) {
      waitForEvent(5000, CameraEventType.GP_EVENT_CAPTURE_COMPLETE);
    }
    return cameraFilePath.ref;
  }
//   final ffi.Pointer<ffi.UnsignedChar> ptr = ...;  // for binary data, unsigned char is recommended.
// final Uint8List binaryData = ptr.cast<ffi.Uint8>().asTypedList();
  // Private helper function to convert a C-style array to a Dart string
  String convertCArrayToString(Array<Char> cArray) {
    final dartString = <int>[];
    for (var i = 0; i < 256; i++) {
      final char = cArray[i];
      if (char == 0) break;
      dartString.add(char);
    }
    return String.fromCharCodes(dartString);
  
}


   /// Save image to disk in current directory. TODO: allow path and filename to
   /// be specified.
   ///
   /// @param path CameraFilePath object returned by captureImage()
   /// @param delete True if the image should be deleted from the camera
   /// @return a File which points to the new image.
   /// @ If the image cannot be saved.
    File saveImage(CameraFilePath path, bool delete)  {
        String folder =convertCArrayToString(path.folder);
        String name = convertCArrayToString(path.name);
 final namePointer = name.toNativeUtf8().cast<Char>();
 final folderPointer = folder.toNativeUtf8().cast<Char>();
print("Folder=$folder");
print("Name=$name");

        int rc;

//  Pointer<_Camera> camera,
//   Pointer<Char> folder,
//   Pointer<Char> file,
//   CameraFileType type,
//   Pointer<_CameraFile> camera_file,
//   Pointer<_GPContext> context,
        /* initialize a CameraFile object */        
        Pointer<Pointer<CameraFile>> ref = calloc();

        rc = _instance.gp_file_new(ref);
        if (rc != GP_OK) {
            throw Exception("gp_file_new failed with code $rc"  );
        }
        Pointer<Pointer<CameraFile>> cameraFilep = calloc();
        Pointer<CameraFile> cameraFile = cameraFilep.value;


        /* point the CameraFile object at the CameraFilePath */
        rc = _instance.gp_camera_file_get(camera!.value, folderPointer, namePointer, CameraFileType.GP_FILE_TYPE_NORMAL, cameraFile, context);
        if (rc != GP_OK) {
            throw Exception("gp_camera_file_get failed with code $rc" );
        }

        /* save CameraFile to disk */
        rc = _instance.gp_file_save(cameraFile, namePointer);
        _instance.gp_file_free(cameraFile);
        if (rc != GP_OK) {
            throw Exception("gp_file_save failed with code $rc" );
        }

        if (delete) {
            rc = _instance.gp_camera_file_delete(camera!.value, folderPointer, namePointer, context);
            if (rc != GP_OK) {
                throw Exception("gp_camera_file_delete failed with code $rc" );
            }
        }
        return File(name.trim());
    }

  /// Download all images in the given path into the current directory.
  /// Warning: If delete option is enabled, all images on the camera will be
  /// deleted, not just the ones from the most recent capture.
  ///
  /// @param path CameraFilePath to the image on the camera
  /// @param delete True if all images should be removed from camera after
  /// saving
  /// @return List of Files for the downloaded images
  /// @ on error
     List<File> saveImages(CameraFilePath path, bool delete)  {
        List<File> fileList = [];
        String folder = convertCArrayToString(path.folder);
 final folderPointer = folder.toNativeUtf8().cast<Char>();
        /* get a list of files */
        Pointer<Pointer<CameraList>> cameraList = calloc();
        int rc = _instance.gp_list_new(cameraList);

        if (rc != GP_OK) {
            throw Exception("gp_list_new failed with code $rc" );
        }

        Pointer<Pointer<Char>> ref = calloc();

        rc = _instance.gp_camera_folder_list_files(camera!.value, folderPointer, cameraList.value, context);
        if (rc != GP_OK) {
            throw Exception("gp_camera_folder_list_files failed with code $rc"  );
        }

        /* iterate through list, downloading each item */
        int gp_list_count = _instance.gp_list_count(cameraList.value);
        for (int i = 0; i < gp_list_count; i++) {
            rc = _instance.gp_list_get_name(cameraList.value, i, ref);
            if (rc != GP_OK) {
                throw Exception("gp_list_get_name failed with code $rc" );
            }
            // String name = ref.getValue().getString(0);
            // path.name = name.getBytes();
            //TODO need to add back in.
            // String name = convertCArrayToString(ref.value);
            // path.name = name; 

            fileList.add(saveImage(path, delete));
        }
        return fileList;
    }
}
