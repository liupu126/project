package com.braden.mytest;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.util.Log;

public class TestReceiver extends BroadcastReceiver {
    private static final String TAG = TestReceiver.class.getSimpleName();
    private static final String ACTION_BOOT = Intent.ACTION_BOOT_COMPLETED;
    private static final String ACTION_TEST_PHONE_CRASH = "com.braden.mytest.intent.ACTION_TEST_PHONE_CRASH";
    // ACTION_TEST_PHONE_CRASH count
    private static int sCount = 0;

    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        Log.e(TAG, "liupu: " + action);

        if (ACTION_BOOT.equals(action)) {
            // test resolveContentProvider
            PackageManager packageManager = context.getPackageManager();
            ProviderInfo pi = packageManager.resolveContentProvider("com.cequint.ecid", PackageManager.GET_META_DATA);
            if (pi == null) {
                Log.e(TAG, "liupu: pi=null");
            } else {
                Log.e(TAG, "liupu: " + pi.toString());
            }
        } else if (ACTION_TEST_PHONE_CRASH.equals(action)) {
            Log.e(TAG, "liupu: " + this + " ACTION_TEST_PHONE_CRASH sCount=" + (++sCount));
        }
    }
}
