package com.rngocoder;

import android.content.Context;
import com.wowza.gocoder.sdk.api.WowzaGoCoder;
import com.wowza.gocoder.sdk.api.configuration.WZMediaConfig;
import com.wowza.gocoder.sdk.api.configuration.WowzaConfig;
import com.wowza.gocoder.sdk.api.devices.WZCameraView;
import com.wowza.gocoder.sdk.api.errors.WZStreamingError;
import com.wowza.gocoder.sdk.api.logging.WZLog;


import com.wowza.gocoder.sdk.api.status.WZStatusCallback;


public class BroadcastManager {
    public static WowzaGoCoder initBroadcast(Context localContext, String hostAddress, String applicationName, String broadcastName, String sdkLicenseKey, String username, String password,int sizePreset,WZCameraView cameraView){
        WowzaGoCoder mGoCoder = WowzaGoCoder.init(localContext, sdkLicenseKey);
        WowzaConfig broadcastConfig = new WowzaConfig();
        // Update the active config to the defaults for 720p video

        broadcastConfig.setAudioBitRate(22400);
        broadcastConfig.setVideoFramerate(12);
        broadcastConfig.set(getSizePresetWithInt(sizePreset));

        // Set the address for the Wowza Streaming Engine server or Wowza Cloud
        broadcastConfig.setHostAddress(hostAddress);
        broadcastConfig.setUsername(username);
        broadcastConfig.setPassword(password);
        broadcastConfig.setApplicationName(applicationName);
        // Set the name of the stream
        broadcastConfig.setStreamName(broadcastName);

        // Update the active config
        mGoCoder.setConfig(broadcastConfig);
        mGoCoder.setCameraView(cameraView);
        return mGoCoder;

    }
    public static void startBroadcast(WowzaGoCoder mGoCoder, WZStatusCallback callback){
        if (!mGoCoder.isStreaming()) {
            // Validate the current broadcast config
            WZStreamingError configValidationError = mGoCoder.getConfig().validateForBroadcast();
            if (configValidationError != null) {
                WZLog.error(configValidationError);
            } else {
                // Start the live stream
                mGoCoder.startStreaming(callback);
            }
        }
    }
    public static void stopBroadcast(WowzaGoCoder mGoCoder, WZStatusCallback callback){
        if (mGoCoder.isStreaming()) {
            // Stop the live strea
            mGoCoder.endStreaming(callback);
        }
    }
    public static void invertCamera(WowzaGoCoder mGoCoder){
        mGoCoder.getCameraView().switchCamera();
    }
    public static void turnFlash(WowzaGoCoder mGoCoder, boolean on){
        mGoCoder.getCameraView().getCamera().setTorchOn(on);
    }
    public static void mute(WowzaGoCoder mGoCoder, boolean muted){
        if(!muted) {
            mGoCoder.muteAudio();
        }
        else{
            mGoCoder.unmuteAudio();
        }
    }
    public static void changeStreamName(WowzaGoCoder mGoCoder, String broadcastName){
        WowzaConfig broadcastConfig = mGoCoder.getConfig();
        broadcastConfig.setStreamName(broadcastName);
        mGoCoder.setConfig(broadcastConfig);
    }

    private static WZMediaConfig getSizePresetWithInt(int sizePreset){
        switch (sizePreset){
            case 0: //FRAME_SIZE_176x144
                return WZMediaConfig.FRAME_SIZE_176x144;
            case 1: //FRAME_SIZE_320x240
                return WZMediaConfig.FRAME_SIZE_320x240;
            case 2: //FRAME_SIZE_352x288
                return WZMediaConfig.FRAME_SIZE_352x288;
            case 3: //FRAME_SIZE_640x480
                return WZMediaConfig.FRAME_SIZE_640x480;
            case 4: //FRAME_SIZE_960x540
                return WZMediaConfig.FRAME_SIZE_960x540;
            case 5: //FRAME_SIZE_1280x720
                return WZMediaConfig.FRAME_SIZE_1280x720;
            case 6: //FRAME_SIZE_1440x1080
                return WZMediaConfig.FRAME_SIZE_1440x1080;
            case 7: //FRAME_SIZE_1920x1080
                return WZMediaConfig.FRAME_SIZE_1920x1080;
            case 8: //FRAME_SIZE_3840x2160
                return  WZMediaConfig.FRAME_SIZE_3840x2160;
            default:
                return WZMediaConfig.FRAME_SIZE_640x480;
        }
    }
}