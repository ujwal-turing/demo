package com.zuelligdemo.demo.kt

import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks as welc;
import io.flutter.app.FlutterApplication;
import com.webengage.webengage_plugin.WebengageInitializer;
import com.webengage.sdk.android.WebEngageConfig;
import com.webengage.sdk.android.WebEngage;
import com.webengage.sdk.android.WebEngageActivityLifeCycleCallbacks;
import com.webengage.sdk.android.LocationTrackingStrategy;

class Application : FlutterApplication() {
    override
    fun onCreate() {
        //ActivityLifecycleCallback.register(this)//<--- Add this before super.onCreate()
        super.onCreate()

        val webEngageConfig = WebEngageConfig.Builder()
            .setWebEngageKey("76aabd9")
            .setAutoGCMRegistrationFlag(false)
            .setLocationTrackingStrategy(LocationTrackingStrategy.ACCURACY_BEST)
            .setDebugMode(true) // only in development mode
            .build()
        WebengageInitializer.initialize(this, webEngageConfig)
    }
}