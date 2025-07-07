package com.onyx.hotspotmanager

import android.app.Application
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class HotspotApplication : Application() {
    
    override fun onCreate() {
        super.onCreate()
    }
}
