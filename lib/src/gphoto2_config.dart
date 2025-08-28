/**
 * GPhoto2Config Copyright 2012 Andrew Bythell, abythell@ieee.org
 *
 * This file is part of libgphoto2-jna.
 *
 * libgphoto2-jna is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * libgphoto2-jna is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * libphoto2-jna. If not, see <http://www.gnu.org/licenses/>.
 */ 

// package com.angryelectron.gphoto2;

// import com.angryelectron.libgphoto2.Camera;
// import com.angryelectron.libgphoto2.Gphoto2Library;
// import com.angryelectron.libgphoto2.Gphoto2Library.CameraWidget;
// import com.angryelectron.libgphoto2.Gphoto2Library.CameraWidgetType;
// import com.angryelectron.libgphoto2.Gphoto2Library.GPContext;
// import com.sun.jna.Memory;
// import com.sun.jna.Pointer;
// import com.sun.jna.ptr.FloatByReference;
// import com.sun.jna.ptr.IntByReference;
// import com.sun.jna.ptr.PointerByReference;
// import java.io.IOException;
// import java.nio.IntBuffer;

import 'dart:ffi';

import 'package:dart_gphoto2/src/generated/libgphoto2_bindings.dart';
import 'package:dart_gphoto2/src/gphoto2_2.dart';
import 'package:ffi/ffi.dart';

/// <p>
/// Read and write camera settings. Use to set or get multiple parameters at once.
/// </p>
/// <p>
/// First call {@link #readConfig()}, then call {@link #getParameter(java.lang.String)}
/// and {@link #setParameter(java.lang.String, java.lang.String)} as many times as needed.  
/// Finish by calling {@link #writeConfig()} to write updated parameters to the camera.
/// </p>
/// <p>
/// This method is more efficient than using {@link com.angryelectron.gphoto2.GPhoto2#setConfig(java.lang.String, java.lang.String)} 
/// and {@link com.angryelectron.gphoto2.GPhoto2#getConfig(java.lang.String)} since the
/// configuration is stored in memory, instead of on the camera.
/// </p>
/// 
class GPhoto2Config {
          
    late LibGPhoto2 gphoto2;
    late Pointer<GPContext> context;
    late Pointer<Camera> camera;    
    late Pointer<CameraWidget> cameraWidget;
    
    /// Constructor.
    /// @param g An open GPhoto2 object.
    GPhoto2Config(GPhoto2 g) {        
        // gphoto2 = g.gphoto2;
        // context = g.context;
        // camera = g.camera;        
    }
    
    /// Verify return codes.  If the return code is not 
    /// GP_OK, an IO Exception is thrown.  Used to verify every libgphoto2 call.
    /// @param msg A message to include with the exception
    /// @param rc The return code to validate.
    /// @ 
    void validateResult(String msg, int rc)  {        
        if (rc != GP_OK) {
            throw Exception( "$msg failed with code $rc" );
        }        
    }
    
    /// Retrieve the CameraWidget for the given parameter.
    /// @param param Name of the parameter
    /// @return CameraWidget object.
    /// @ If parameter is invalid or cannot be retrieved.
    Pointer<CameraWidget> getParameterWidget(String param)  {        
        // Pointer name = new Memory(param.length() + 1);
        // name.setString(0, param);
        // CameraWidget[] childs = new CameraWidget[1];
        // int rc = gphoto2.gp_widget_get_child_by_name(cameraWidget, name, childs);
        // validateResult("gp_widget_get_child_by_name", rc);
        // return childs[0];   
        throw Exception("Unsupported Nor implemented");
    }
        
    /// Retrieve a parameter's value.  The value type depends on the parameter 
    /// type.  This method retrieves the value using the correct type, then
    /// converts it to a string.
    /// @param paramWidget A CameraWidget representing the parameter to be read.
    /// @return A String representing the parameter's value.
    /// @ If the value cannot be read.
    String getParameterValue(Pointer<CameraWidget> paramWidget)  {        
        int rc;
                        
        // // IntBuffer type = IntBuffer.allocate(4);
        // Pointer<UnsignedInt> type = calloc(); 

        // rc = gphoto2.gp_widget_get_type(paramWidget, type);
        // validateResult("gp_widget_get_type", rc);        
        // switch (CameraWidgetType.fromValue(type.value)) {

        //     case CameraWidgetType.GP_WIDGET_MENU:
        //     case CameraWidgetType.GP_WIDGET_TEXT:
        //     case CameraWidgetType.GP_WIDGET_RADIO: 
        //      FloatByReference fValue = new FloatByReference();                               
        //         Pointer<Void> pValue = calloc();

        //         rc = gphoto2.gp_widget_get_value(paramWidget, pValue);
        //         validateResult("gp_widget_get_value", rc);
        //         return pValue.value.getString(0);                
        //     case CameraWidgetType.GP_WIDGET_RANGE:
        //         FloatByReference fValue = new FloatByReference();
        //         rc = gphoto2.gp_widget_get_value(paramWidget, fValue.getPointer());
        //         validateResult("gp_widget_get_value", rc);
        //         Float f = fValue.getValue();
        //         return f.toString();
        //     case CameraWidgetType.GP_WIDGET_DATE:
        //         IntByReference iValue = new IntByReference();
        //         rc = gphoto2.gp_widget_get_value(paramWidget, iValue.getPointer());
        //         validateResult("gp_widget_get_value", rc);
        //         Long l = (long) iValue.getValue() * 1000;                
        //         return l.toString();
        //     case CameraWidgetType.GP_WIDGET_TOGGLE:                             
        //         IntByReference tValue = new IntByReference();
        //         rc = gphoto2.gp_widget_get_value(paramWidget, tValue.getPointer());
        //         validateResult("gp_widget_get_value", rc);
        //         Integer t = tValue.getValue();
        //         return t.toString();
        //     default:
        //         throw new UnsupportedOperationException("Unsupported CameraWidgetType");
        // }        
        throw Exception("Unsupported Nor implemented");
    }
     
    /// Set the value of a parameter.  This method will convert the value into the
    /// appropriate widget type.
    /// @param paramWidget A CameraWidget representing the parameter to be set.
    /// @param value The new value for the parameter.
    /// @ If the parameter cannot be set.
    void setParameterValue(Pointer<CameraWidget> paramWidget, String value)  {
      throw Exception("Unsupported Nor implemented");
        // Pointer pValue = null;
        // IntBuffer type = IntBuffer.allocate(4);
        // int rc = gphoto2.gp_widget_get_type(paramWidget, type);
        // validateResult("gp_widget_get_type", rc);
        
        // switch (type.get()) {
        //     case CameraWidgetType.GP_WIDGET_MENU:
        //     case CameraWidgetType.GP_WIDGET_TEXT:
        //     case CameraWidgetType.GP_WIDGET_RADIO:                
        //         //char *
        //         pValue = new Memory(value.length() + 1);
        //         pValue.setString(0, value);
        //         break;
        //     case CameraWidgetType.GP_WIDGET_RANGE:
        //         //floats are 32-bits or 4 bytes
        //         float fValue = Float.parseFloat(value);
        //         pValue = new Memory(4);
        //         pValue.setFloat(0, fValue);
        //         break;
        //     case CameraWidgetType.GP_WIDGET_DATE:
        //     case CameraWidgetType.GP_WIDGET_TOGGLE:             
        //         //ints are 32-bits or 4 bytes
        //         int iValue = Integer.parseInt(value);
        //         pValue = new Memory(4);
        //         pValue.setInt(0, iValue);
        //         break;
        //     default:
        //         throw new UnsupportedOperationException("Unsupported CameraWidgetType");
        // }
        // rc = gphoto2.gp_widget_set_value(paramWidget, pValue);
        // validateResult("gp_widget_set_value", rc);        
    }
    
    /// Read the camera's current configuration.  This must be called before
    /// getting or setting any parameters.
    /// @ If the configuration cannot be read.
     void readConfig()  {
        Pointer<Pointer<CameraWidget>> camWidg = calloc();
        int rc = gphoto2.gp_camera_get_config(camera, camWidg, context);
        validateResult("gp_camera_get_config", rc);
        cameraWidget = camWidg[0];                        
    }
    
    /// Write the current settings to the camera.  This must be called after any 
    /// setParameter() calls to save the new settings to the camera.  It can be
    /// called once after setting multiple parameters.
    /// @ If the settings cannot be written.
     void writeConfig()  {
        int rc = gphoto2.gp_camera_set_config(camera, cameraWidget, context);
        validateResult("gp_camera_set_config", rc);        
    }
        
    /// Set a new value for a parameter.  A list of parameters can be viewed by
    /// running 'gphoto2 --list-config'.  To view a list of valid options for a
    /// parameter, run 'gphoto2 --get-config <parameter>'.  Note that "Choices" are
    /// numbered, with the value appearing last (ie. when setting "evstep", 
    /// use "1/3" for "Choice: 0 1/3", not "0").  Strings are case sensitive.
    /// @param param The parameter to set.  If getting parameters via --list-config,
    /// do not specify the entire path (ie. use 'iso', not '/main/imgsettings/iso').
    /// @param value The value to set.
    /// @ If the parameter cannot be set.
     void setParameter(String param, String value)  {        
        var paramWidget = getParameterWidget(param);
        setParameterValue(paramWidget, value);                        
    }
    
    /// Get the value of a parameter. A list of parameters can be viewed by
    /// running 'gphoto2 --list-config'. 
    /// @param param The parameter to retrieve.
    /// @return The value of the parameter, as a string.
    /// @ If the parameter cannot be read.
    String getParameter(String param)  {
        var paramWidget = getParameterWidget(param);
        return getParameterValue(paramWidget);        
    }
}