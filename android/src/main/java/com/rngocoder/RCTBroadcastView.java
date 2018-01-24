package com.rngocoder;

import android.view.View;

import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;

import java.util.Map;

import javax.annotation.Nullable;

/**
 * Created by hugonagano on 11/7/16.
 */


public class RCTBroadcastView extends ViewGroupManager<BroadcastView>  {
    private BroadcastView cameraView;

    private static final String PROP_HOST_ADDRESS = "hostAddress";
    private static final String PROP_BROADCAST_NAME = "broadcastName";
    private static final String PROP_APPLICATION_NAME = "applicationName";
    private static final String PROP_SDK_LICENSE = "sdkLicenseKey";
    private static final String PROP_SIZE_PRESET = "sizePreset";
    private static final String PROP_VIDEO_ORIENTATION = "videoOrientation";
    private static final String PROP_USERNAME = "username";
    private static final String PROP_PASSWORD = "password";
    private static final String PROP_BROADCASTING = "broadcasting";
    private static final String PROP_FLASH = "flashOn";
    private static final String PROP_CAMERA = "frontCamera";
    private static final String PROP_MUTED = "muted";
    private static final String PROP_IN_BACKGROUND_MODE = "backgroundMode";


    @Override
    public String getName() {
        return "RNBroadcastView";
    }
    @Override
    protected BroadcastView createViewInstance(ThemedReactContext reactContext) {

        cameraView = new BroadcastView(reactContext);

        return cameraView;
    }


    @Override
    @Nullable
    public Map getExportedCustomDirectEventTypeConstants() {
        MapBuilder.Builder builder = MapBuilder.builder();
        for (BroadcastView.Events event : BroadcastView.Events.values()) {
            builder.put(event.toString(), MapBuilder.of("registrationName", event.toString()));
        }
        return builder.build();
    }



    @Override
    public void addView(BroadcastView  parent, View child, int index) {
        parent.addView(child, index + 1);   // index 0 for camera preview reserved
    }

    @ReactProp(name = PROP_HOST_ADDRESS)
    public void setHostAddress(BroadcastView view, String hostAddress){
        view.setHostAddress(hostAddress);
    }
    @ReactProp(name = PROP_SDK_LICENSE)
    public void setSdkLicenseKey(BroadcastView view, String sdkLicenseKey){
        view.setSdkLicenseKey(sdkLicenseKey);
    }
    @ReactProp(name = PROP_APPLICATION_NAME)
    public void setApplicationName(BroadcastView view, String applicationName){
        view.setApplicationName(applicationName);
    }
    @ReactProp(name = PROP_BROADCAST_NAME)
    public void setBroadcastName(BroadcastView view, String broadcastName){
        view.setBroadcastName(broadcastName);
    }
    @ReactProp(name = PROP_SIZE_PRESET, defaultInt = 3)
    public void setSizePreset(BroadcastView view, int sizePreset){
        view.setSizePreset(sizePreset);
    }
    @ReactProp(name = PROP_VIDEO_ORIENTATION)
    public void setVideoOrientation(BroadcastView view, String videoOrientation){
        view.setVideoOrientation(videoOrientation);
    }
    @ReactProp(name = PROP_USERNAME)
    public void setUsername(BroadcastView view, String username){
        view.setUsername(username);
    }
    @ReactProp(name = PROP_PASSWORD)
    public void setPassword(BroadcastView view, String password){
        view.setPassword(password);
    }
    @ReactProp(name = PROP_BROADCASTING)
    public void setBroadcating(BroadcastView view, boolean broadcasting){
        view.setBroadcasting(broadcasting);
    }
    @ReactProp(name = PROP_FLASH)
    public void setFlash(BroadcastView view, boolean flashOn){
        view.setFlashOn(flashOn);
    }
    @ReactProp(name = PROP_CAMERA)
    public void setCamera(BroadcastView view, boolean frontCamera){
        view.setFrontCamera(frontCamera);
    }
    @ReactProp(name = PROP_MUTED)
    public void setMuted(BroadcastView view, boolean muted){
        view.setMuted(muted);
    }

    @ReactProp(name = PROP_IN_BACKGROUND_MODE)
    public void setBackgroundMode(BroadcastView view, boolean background){

    }


}

