package com.rngocoder;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.wowza.gocoder.sdk.api.status.WZState;
import com.wowza.gocoder.sdk.api.status.WZStatus;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

import android.os.Handler;

/**
 * Created by hugonagano on 11/8/16.
 */

public class RCTBroadcastModule extends ReactContextBaseJavaModule {
    private Handler handler;
    private Runnable runnable;
    private Integer seconds = 0;
    private ReactContext reactContext;

    @Override
    public String getName() {
        return "BroadcastModule";
    }
    public RCTBroadcastModule(ReactApplicationContext context){
        super(context);
        this.reactContext = context;
    }

    public static String getStatusString(WZStatus status){
        switch (status.getState()){
            case WZState.IDLE:
                return "idle";
            case WZState.PAUSED:
                return "paused";
            case WZState.READY:
                return "ready";
            case WZState.RUNNING:
                return "running";
            case WZState.STARTING:
                return "starting";

        }
        return "";
    }

    @ReactMethod
    public void startTimer(final int interval, final int timeout){
        this.seconds = 0;
        handler = new Handler();
        runnable = new Runnable() {
            @Override
            public void run() {
                seconds++;
                Date d = new Date(seconds* 1000L);
                SimpleDateFormat df = new SimpleDateFormat("HH:mm:ss"); // HH for 0-23
                df.setTimeZone(TimeZone.getTimeZone("GMT"));
                String time = df.format(d);
                sendCurrentTime(reactContext, "broadcastTimer", time);
                if(seconds < timeout){
                    handler.postDelayed(runnable, interval*1000);
                }
                else{
                    stopTimer();
                }
            }
        };
        handler.post(runnable);
    }

    @ReactMethod
    public void stopTimer(){
        if(handler != null) {
            handler.removeCallbacks(runnable);
        }
    }

    private void sendCurrentTime(ReactContext reactContext, String eventName, String time){
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, time);
    }
}
