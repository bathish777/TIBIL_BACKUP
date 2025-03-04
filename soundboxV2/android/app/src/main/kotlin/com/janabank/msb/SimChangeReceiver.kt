package com.janabank.msb

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.TelephonyManager

class SimChangeReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent != null && context != null) {
            val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            val simState = if (telephonyManager.simState == TelephonyManager.SIM_STATE_ABSENT) "SIM_REMOVED" else "SIM_CHANGED"

            // Use the MethodChannel from the MainActivity
            MainActivity.methodChannel?.invokeMethod("simStateChange", simState)
        }
    }
}
