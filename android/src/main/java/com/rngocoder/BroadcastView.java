package com.rngocoder;

import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.wowza.gocoder.sdk.api.WowzaGoCoder;
import com.wowza.gocoder.sdk.api.devices.WZCameraView;
import com.wowza.gocoder.sdk.api.status.WZState;
import com.wowza.gocoder.sdk.api.status.WZStatus;
import com.wowza.gocoder.sdk.api.status.WZStatusCallback;


/**
 * Created by hugonagano on 11/7/16.
 */

public class BroadcastView extends FrameLayout implements LifecycleEventListener {
    public enum Events {
        EVENT_BROADCAST_START("onBroadcastStart"),
        EVENT_BROADCAST_STATUS_CHANGE("onBroadcastStatusChange"),
        EVENT_BROADCAST_FAIL("onBroadcastFail"),
        EVENT_BROADCAST_EVENT("onBroadcastEventReceive"),
        EVENT_BROADCAST_ERROR("onBroadcastErrorReceive"),
        EVENT_BROADCAST_VIDEO_ENCODED("onBroadcastVideoEncoded"),
        EVENT_BROADCAST_STOP("onBroadcastStop");

        private final String mName;

        Events(final String name) {
            mName = name;
        }

        @Override
        public String toString() {
            return mName;
        }
    }
    private WZCameraView cameraView;
    private ThemedReactContext localContext;
    private String sdkLicenseKey;
    private String hostAddress;
    private String applicationName;
    private String broadcastName;
    private String username;
    private String password;
    private RCTEventEmitter mEventEmitter;
    private boolean broadcasting = false;
    private boolean flashOn = false;
    private boolean frontCamera = false;
    private boolean muted = false;
    private int sizePreset;
    private WowzaGoCoder goCoder;

    public BroadcastView(ThemedReactContext context){
        super(context);


        localContext = context;
        mEventEmitter = localContext.getJSModule(RCTEventEmitter.class);
        cameraView = new WZCameraView(context);
        localContext.addLifecycleEventListener(this);
        cameraView.setLayoutParams(new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        cameraView.getCamera().setTorchOn(false);
        this.addView(cameraView);
    }

    @Override
    public void onHostDestroy() {
        if(this.cameraView != null) {
            this.stopCamera();
        }
    }

    @Override
    public void onHostPause() {
        if(this.cameraView != null){
            this.cameraView.stopPreview();
        }
    }

    @Override
    public void onHostResume() {
        if(goCoder == null && cameraView != null) {
            goCoder = BroadcastManager.initBroadcast(localContext, getHostAddress(), getApplicationName(), getBroadcastName(), getSdkLicenseKey(), getUsername(), getPassword(), getSizePreset(), cameraView);

        }
        if(cameraView != null){
            cameraView.startPreview();
        }

    }



    public void setCameraType(Integer cameraType) {
        this.cameraView.setCamera(cameraType);
    }

    public void setFlash(boolean flag) {
        this.cameraView.getCamera().setTorchOn(flag);
    }

    public void stopCamera() {
        this.cameraView.stopPreview();
        this.cameraView = null;
        this.goCoder = null;
    }


    public String getSdkLicenseKey() {
        return sdkLicenseKey;
    }

    public void setSdkLicenseKey(String sdkLicenseKey) {
        this.sdkLicenseKey = sdkLicenseKey;
    }

    public String getHostAddress() {
        return hostAddress;
    }

    public void setHostAddress(String hostAddress) {
        this.hostAddress = hostAddress;
    }

    public String getApplicationName() {
        return applicationName;
    }

    public void setApplicationName(String applicationName) {
        this.applicationName = applicationName;
    }

    public String getBroadcastName() {
        return broadcastName;
    }

    public void setBroadcastName(String broadcastName) {
        this.broadcastName = broadcastName;

        if (goCoder != null) {
            BroadcastManager.changeStreamName(goCoder, this.broadcastName);
        }
    }

    public int getSizePreset() {
        return sizePreset;
    }

    public void setSizePreset(int sizePreset) {
        this.sizePreset = sizePreset;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isBroadcasting() {
        return broadcasting;
    }
    

    public void setBroadcasting(boolean broadcasting) {
        if(goCoder == null){
            return;
        }
        if(!this.isBroadcasting()){
            BroadcastManager.startBroadcast(goCoder, new WZStatusCallback(){
                @Override
                public void onWZStatus(WZStatus wzStatus) {
                    if(wzStatus.getState() == WZState.RUNNING){
                        WritableMap event = Arguments.createMap();
                        WritableMap broadcast = Arguments.createMap();
                        broadcast.putString("host", getHostAddress());
                        broadcast.putString("broadcastName", getBroadcastName());
                        event.putMap("event", broadcast);
                        mEventEmitter.receiveEvent(getId(), Events.EVENT_BROADCAST_START.toString(), event);
                    }
                }

                @Override
                public void onWZError(WZStatus wzStatus) {
                    if(wzStatus.getLastError() != null){
                        WritableMap error = Arguments.createMap();
                        error.putString("error", wzStatus.getLastError().toString());
                        mEventEmitter.receiveEvent(getId(), Events.EVENT_BROADCAST_FAIL.toString(), error);
                    }
                }
            });
        }
        else{
            BroadcastManager.stopBroadcast(goCoder, new WZStatusCallback() {
                @Override
                public void onWZStatus(WZStatus wzStatus) {
                    if(wzStatus.getState() == WZState.IDLE){
                        WritableMap event = Arguments.createMap();
                        WritableMap broadcast = Arguments.createMap();
                        broadcast.putString("host", getHostAddress());
                        broadcast.putString("broadcastName", getBroadcastName());
                        broadcast.putString("status", "stopped");
                        event.putMap("event", broadcast);
                        mEventEmitter.receiveEvent(getId(), Events.EVENT_BROADCAST_STOP.toString(), event);
                    }
                }

                @Override
                public void onWZError(WZStatus wzStatus) {
                    if(wzStatus.getLastError() != null){
                        WritableMap error = Arguments.createMap();
                        error.putString("error", wzStatus.getLastError().toString());
                        mEventEmitter.receiveEvent(getId(), Events.EVENT_BROADCAST_FAIL.toString(), error);
                    }
                }
            });
        }
        this.broadcasting = broadcasting;
    }

    public boolean isFlashOn() {
        return flashOn;
    }

    public void setFlashOn(boolean flashOn) {
        if(goCoder != null) {
            BroadcastManager.turnFlash(goCoder, flashOn);
            this.flashOn = flashOn;
        }
    }

    public boolean isFrontCamera() {
        return frontCamera;
    }

    public void setFrontCamera(boolean frontCamera) {
        if(goCoder != null) {
            BroadcastManager.invertCamera(goCoder);
            this.frontCamera = frontCamera;
        }
    }

    public boolean isMuted() {
        return muted;
    }

    public void setMuted(boolean muted) {
        if(goCoder != null) {
            BroadcastManager.mute(goCoder, muted);
            this.muted = muted;
        }
    }
}
