package com.soundbox.app;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.telephony.SmsManager;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import java.util.List;

@CapacitorPlugin(name = "SimBindPlugin")
public class SimBindPlugin extends Plugin {

    @PluginMethod()
    public void getSimInfo(PluginCall call) {
        Context context = getContext();
        SubscriptionManager subscriptionManager = (SubscriptionManager) context.getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE);

        if (subscriptionManager == null) {
            call.reject("SubscriptionManager is not available.");
            return;
        }

        List<SubscriptionInfo> subscriptionInfoList = subscriptionManager.getActiveSubscriptionInfoList();
        if (subscriptionInfoList == null || subscriptionInfoList.isEmpty()) {
            call.reject("No SIM cards found.");
            return;
        }

        JSArray simCards = new JSArray();
        for (SubscriptionInfo info : subscriptionInfoList) {
            JSObject sim = new JSObject();
            sim.put("carrierName", info.getCarrierName() != null ? info.getCarrierName().toString() : "Unknown");
            sim.put("simSlotIndex", info.getSimSlotIndex());
            sim.put("subscriptionId", info.getSubscriptionId());
            simCards.put(sim);
        }

        JSObject result = new JSObject();
        result.put("cards", simCards);
        call.resolve(result);
    }

    @PluginMethod()
    public void sendSMS(PluginCall call) {
        String vmnNumber = call.getString("vmnNumber");
        String message = call.getString("message");
        int simSlot = call.getInt("simSlot", -1 );
        
        if (vmnNumber == null || message == null || simSlot < 0) {
            call.reject("Invalid arguments provided.");
            return;
        }

        if (ContextCompat.checkSelfPermission(getContext(), Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED) {
            call.reject("SMS permission not granted.");
            return;
        }

        SubscriptionManager subscriptionManager = (SubscriptionManager) getContext().getSystemService(Context.TELEPHONY_SUBSCRIPTION_SERVICE);

        if (subscriptionManager == null) {
            call.reject("SubscriptionManager is not available.");
            return;
        }

        List<SubscriptionInfo> subscriptionInfoList = subscriptionManager.getActiveSubscriptionInfoList();
        if (subscriptionInfoList == null) {
            call.reject("No active subscriptions available.");
            return;
        }

        Integer subscriptionId = null;
        for (SubscriptionInfo info : subscriptionInfoList) {
            if (info.getSimSlotIndex() == simSlot) {
                subscriptionId = info.getSubscriptionId();
                break;
            }
        }

        if (subscriptionId == null) {
            call.reject("Subscription ID not found for the given SIM slot.");
            return;
        }

        try {
            if (ContextCompat.checkSelfPermission(getContext(), Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(getActivity(), new String[]{Manifest.permission.SEND_SMS}, 1);
                call.reject("SMS permission not granted.");
                return;
            }

            SmsManager smsManager = SmsManager.getSmsManagerForSubscriptionId(subscriptionId);
            smsManager.sendTextMessage(vmnNumber, null, message, null, null);

            JSObject result = new JSObject();
            result.put("status", "SMS sent successfully.");
            call.resolve(result);
        } catch (Exception e) {
            call.reject("Failed to send SMS: " + e.getMessage());
        }
    }
}
