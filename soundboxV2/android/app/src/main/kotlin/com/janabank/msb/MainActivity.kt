package com.janabank.msb

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.Manifest
import android.annotation.SuppressLint
import android.annotation.TargetApi
import android.content.Context
import android.content.pm.PackageManager
import android.devicelock.DeviceId
import android.telephony.SubscriptionManager
import androidx.core.content.ContextCompat
import android.telephony.SmsManager
import android.telephony.SubscriptionInfo
import android.widget.Toast
import android.os.Build
import android.os.Bundle
import android.telephony.TelephonyManager
import java.util.Base64

class MainActivity: FlutterActivity() {
    private val CHANNEL = "sb.sms.sim/smschannel"
    private val CHANNEL2 = "com.janabank.soundbox/sim_change"

    companion object {
        var methodChannel: MethodChannel? = null
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize the MethodChannel safely
        val messenger = flutterEngine?.dartExecutor?.binaryMessenger
        if (messenger != null) {
            methodChannel = MethodChannel(messenger, CHANNEL2)

            methodChannel?.setMethodCallHandler { call, result ->
                when (call.method) {
                    "simStateChange" -> {
                        val simState = call.argument<String>("state")
                        result.success(simState)
                    }
                    else -> result.notImplemented()
                }
            }
        } else {
            // Handle the case where messenger is null
            // Do nothing

        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSMS") {
                val devId = call.argument<String?>("device_id")
                val rmVmn   = call.argument<String?>("rm_vmn")
                val simSlot = call.argument<Int?>("simSlot")
                val msg = call.argument<String>("msg")

                if (devId != null && simSlot != null && rmVmn != null && msg != null) {
                    val phoneStatePermission =
                        ContextCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE)

                    if (phoneStatePermission == PackageManager.PERMISSION_GRANTED) {
                        val smsStatus = sendSMS(devId, simSlot, rmVmn, msg)

                        result.success(smsStatus)
                    } else {
                        //println("Permission not granted")
                        result.error("PERMISSION_DENIED", "Permission not granted", null)
                    }
                } else {
                    result.error("INVALID_ARGUMENT", "Invalid argument(s) provided", null)
                }
            } else if (call.method == "getSimInfo") {

                val simSlot = call.argument<Int?>("simSlot")

                if (simSlot != null) {
                    val phoneStatePermission =
                        ContextCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE)

                    if (phoneStatePermission == PackageManager.PERMISSION_GRANTED) {
                        val simInfo = getSimInfo(simSlot)

                        result.success(simInfo)
                    } else {
                        //println("Permission not granted")
                        result.error("PERMISSION_DENIED", "Permission not granted", null)
                    }
                } else {
                    result.error("INVALID_ARGUMENT", "Invalid argument(s) provided", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP_MR1)
    @SuppressLint("MissingPermission")
    private fun getSimInfo(simSlot: Int): Any {

        val subscriptionManager =
            getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager

        var subscriptionInfos: List<SubscriptionInfo>? = null

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                subscriptionInfos = subscriptionManager.activeSubscriptionInfoList
            }
        } catch (e: Exception) {
            return mapOf<String, Any?>(
                "status" to false,
                "error" to e,
                "subscription_id" to null
            )
        }

        var subscriptionId: Int? = null;

        if (subscriptionInfos != null) {

            for(subs in subscriptionInfos) {
                if(subs.simSlotIndex == simSlot) {
                    subscriptionId = subs.subscriptionId;
                }
            }


            if ( subscriptionId == null || simSlot < 0 || simSlot > subscriptionInfos.size) {

                //Toast.makeText(this, "Invalid SIM slot in get sim", Toast.LENGTH_SHORT).show()

                return mapOf<String, Any?>(
                    "status" to false,
                    "error" to "Invalid sim slot",
                    "subscription_id" to null
                )
            }

            try {
                val smsManager: SmsManager = SmsManager.getSmsManagerForSubscriptionId(subscriptionId)

                //Toast.makeText(this, "Got sim info successfully", Toast.LENGTH_SHORT).show()

                return mapOf<String, Any?>(
                    "status" to true,
                    "error" to null,
                    "subscription_id" to subscriptionId
                )

            } catch (e: Exception) {
                // Toast.makeText(this, "Failed to get sim info", Toast.LENGTH_SHORT).show()

                return mapOf<String, Any?>(
                    "status" to false,
                    "error" to e,
                    "subscription_id" to null
                )
            }
        }

        return mapOf<String, Any?>(
            "status" to false,
            "error" to "subscription info is empty",
            "subscription_id" to null
        )
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP_MR1)
    @SuppressLint("MissingPermission")
    private fun sendSMS(devId:  String, simSlot: Int, rmVmn: String, msg: String): Any {

        val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

        val subscriptionManager =
            getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE) as SubscriptionManager

        var subscriptionInfos: List<SubscriptionInfo>? = null

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                subscriptionInfos = subscriptionManager.activeSubscriptionInfoList
            }
        } catch (e: Exception) {
            return mapOf<String, Any?>(
                "send_status" to false,
                "subscription_id" to null,
                "error" to e,
                "encoded_msg" to null
            )
        }

        var subscriptionId: Int? = null;

        if (subscriptionInfos != null) {

            for(subs in subscriptionInfos) {
                if(subs.simSlotIndex == simSlot) {
                    subscriptionId = subs.subscriptionId;
                }
            }

            if (subscriptionId == null || simSlot < 0 || simSlot > subscriptionInfos.size) {
                //  Toast.makeText(this, "Invalid SIM slot", Toast.LENGTH_SHORT).show()
                return mapOf<String, Any?>(
                    "send_status" to false,
                    "subscription_id" to null,
                    "error" to "Invalid sim slot",
                    "encoded_msg" to null
                )
            }

            try {


                val smsManager: SmsManager = SmsManager.getSmsManagerForSubscriptionId(subscriptionId)

                //   var simNumber:String? = null;

                //   if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                //       simNumber = subscriptionInfos[simSlot].iccId;
                //       println("Sim ICCID: $simNumber")
                //   }

                // val curTime: Long = System.currentTimeMillis()
                // val encodedMsg = encodeStringToBase64("$devId,$simNumber,$curTime")

                smsManager.sendTextMessage(rmVmn, null, msg, null, null)

                //  Toast.makeText(this, "SMS sent successfully", Toast.LENGTH_SHORT).show()

                return mapOf<String, Any?>(
                    "send_status" to true,
                    "subscription_id" to subscriptionId,
                    "error" to null,
                    "encoded_msg" to msg
                )

            } catch (e: Exception) {
                //   Toast.makeText(this, "Failed to send SMS", Toast.LENGTH_SHORT).show()

                return mapOf<String, Any?>(
                    "send_status" to false,
                    "subscription_id" to null,
                    "error" to e,
                    "encoded_msg" to null
                )
            }
        }

        return mapOf<String, Any?>(
            "send_status" to false,
            "subscription_id" to null,
            "error" to "subscription info is empty",
            "encoded_msg" to null
        )
    }

    @TargetApi(Build.VERSION_CODES.O)
    fun encodeStringToBase64(input: String): String {
        val encoder = Base64.getEncoder()
        return encoder.encodeToString(input.toByteArray())
    }
}