package com.allison.flutter_track

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
        override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        int fbTime;
        int igtime;
        int scale;
        public int getfbTime(){
            return fbTime;
        }
        public int getigTime(){
            return igTime;
        }
        public int getScale(){
            return scale;
        }

        }
}
