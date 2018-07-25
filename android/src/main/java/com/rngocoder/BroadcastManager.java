package com.rngocoder;

import android.content.Context;
import com.wowza.gocoder.sdk.api.WowzaGoCoder;
import com.wowza.gocoder.sdk.api.broadcast.WZBroadcast;
import com.wowza.gocoder.sdk.api.broadcast.WZBroadcastConfig;
import com.wowza.gocoder.sdk.api.configuration.WZMediaConfig;
import com.wowza.gocoder.sdk.api.devices.WZAudioDevice;
import com.wowza.gocoder.sdk.api.devices.WZCameraView;
import com.wowza.gocoder.sdk.api.errors.WZStreamingError;
import com.wowza.gocoder.sdk.api.logging.WZLog;


import com.wowza.gocoder.sdk.api.status.WZStatusCallback;


public class BroadcastManager {
    public static WZBroadcastConfig initBroadcast(Context localContext, String hostAddress, String applicationName, String broadcastName, String sdkLicenseKey, String username, String password,int sizePreset, String videoOrientation, WZCameraView cameraView, WZAudioDevice audioDevice){
        WowzaGoCoder.init(localContext, sdkLicenseKey);
        WZBroadcastConfig broadcastConfig = new WZBroadcastConfig();
        broadcastConfig.setOrientationBehavior(getOrientationBehavior(videoOrientation));
        broadcastConfig.setVideoFramerate(12);

        WZMediaConfig mediaConfig = getSizePresetWithInt(sizePreset);
        broadcastConfig.setVideoSourceConfig(mediaConfig);

        broadcastConfig.setVideoBroadcaster(cameraView);
        broadcastConfig.setAudioBroadcaster(audioDevice);
        broadcastConfig.setAudioBitRate(22400);

        broadcastConfig.setHostAddress(hostAddress);
        broadcastConfig.setUsername(username);
        broadcastConfig.setPassword(password);
        broadcastConfig.setApplicationName(applicationName);
        broadcastConfig.setStreamName(broadcastName);

        return broadcastConfig;
    }

    public static void startBroadcast(WZBroadcast broadcast, WZBroadcastConfig broadcastConfig, WZStatusCallback callback) {
        if (!broadcast.getStatus().isRunning()) {
            // Validate the current broadcast config
            WZStreamingError configValidationError = broadcastConfig.validateForBroadcast();
            if (configValidationError != null) {
                WZLog.error(configValidationError);
            } else {
                // Start the live stream
                broadcast.startBroadcast(broadcastConfig, callback);
            }
        }
    }
    public static void stopBroadcast(WZBroadcast broadcast, WZStatusCallback callback){
        if (broadcast.getStatus().isRunning()) {
            // Stop the live stream
            broadcast.endBroadcast(callback);
        }
    }
    public static void invertCamera(WZCameraView cameraView) {
        cameraView.switchCamera();
    }

    public static void turnFlash(WZCameraView cameraView, boolean on) {
        cameraView.getCamera().setTorchOn(on);

    }

    public static void mute(WZAudioDevice audioDevice, boolean muted){
        audioDevice.setMuted(muted);
    }

    public static void changeStreamName(WZBroadcastConfig broadcastConfig, String broadcastName){
        broadcastConfig.setStreamName(broadcastName);
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

    private static int getOrientationBehavior(String orientation) {
        switch (orientation) {
            case "landscape":
                return WZMediaConfig.ALWAYS_LANDSCAPE;
            case "portrait":
                return WZMediaConfig.ALWAYS_PORTRAIT;
            default:
                return WZMediaConfig.SAME_AS_SOURCE;
        }
    }
}
