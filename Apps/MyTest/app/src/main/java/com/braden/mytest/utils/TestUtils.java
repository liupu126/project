package com.braden.mytest.utils;

import android.Manifest;
import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.WindowManager;
import 	android.support.v4.content.FileProvider;
import java.io.File;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.List;

public class TestUtils {
    public static final String TAG = TestUtils.class.getSimpleName();

    private static TestUtils mTestUtils = null;
    private static Context mContext = null;

    private TestUtils() {};
    private TestUtils(Context context) {
        mContext = context;
    };

    public static TestUtils getInstance(Context context) {
        if (mTestUtils != null) {
            return mTestUtils;
        }
        return new TestUtils(context);
    }

    public void testForAll()
    {
        // dns
        new Thread(new Runnable() {
            @Override
            public void run() {
                testDnsWorks4();
                testDnsWorks6();
            }
        }).start();

        // installed applications
        testGetInstalledApplications();

        //
        Log.e(TAG, "getMinMemory=" + testGetMinMemory());
        Log.e(TAG, "getScreenLayout=" + testGetScreenLayout());

        //
        testQueryIntentActivities();
    }

    public static void testDnsWorks4() {
        InetAddress addrs[] = {};
        try {
            addrs = InetAddress.getAllByName("www.google.com");
        } catch (UnknownHostException e) {}
        // assertTrue("[RERUN] DNS could not resolve www.google.com. Check internet connection", addrs.length != 0);
        if (addrs.length != 0) {
            // Toast.makeText(mContext, "ipv4 OK", Toast.LENGTH_SHORT).show();
            Log.e(TAG, "liupu ipv4 OK");
        }else {
            //Toast.makeText(mContext, "ipv4 FAIL", Toast.LENGTH_SHORT).show();
            Log.e(TAG, "liupu ipv4 FAIL");
        }
    }

    public static void testDnsWorks6() {
        InetAddress addrs[] = {};
        addrs = new InetAddress[0];
        try {
            addrs = InetAddress.getAllByName("ipv6.google.com");
        } catch (UnknownHostException e) {}
        // assertTrue("[RERUN] DNS could not resolve ipv6.google.com, check the network supports IPv6", addrs.length != 0);
        if (addrs.length != 0) {
            //Toast.makeText(mContext, "ipv6 OK", Toast.LENGTH_SHORT).show();
            Log.e(TAG, "liupu ipv6 OK");
        }else {
            //Toast.makeText(mContext, "ipv6 FAIL", Toast.LENGTH_SHORT).show();
            Log.e(TAG, "liupu ipv6 FAIL");
        }
    }

    public static void testGetInstalledApplications() {
        Log.e(TAG, "testGetInstalledApplications begin");
        List<ApplicationInfo> packages =
                mContext.getPackageManager().getInstalledApplications(PackageManager.GET_META_DATA);
        Log.e(TAG, "testGetInstalledApplications end");
    }

    public static long testGetMinMemory() {
        try {
            ActivityManager.MemoryInfo memoryInfo = new ActivityManager.MemoryInfo();
            ActivityManager am = (ActivityManager) mContext.getSystemService(Context.ACTIVITY_SERVICE);
            am.getMemoryInfo(memoryInfo);

            if (memoryInfo.totalMem <= 536870912) {
                Log.e(TAG, "MEMORY_POST_BOOT_512_KEY");
                return memoryInfo.totalMem;
            }
            Log.e(TAG, "MEMORY_POST_BOOT_1GB_KEY");
            return memoryInfo.totalMem;
        }
        catch (Exception e)
        {
            Log.e(TAG, "getMinMemory Exception");
            e.printStackTrace();
        }
        return -1;
    }

    public static  String testGetScreenLayout() {
        try {
            WindowManager wm = (WindowManager) mContext.getSystemService(Context.WINDOW_SERVICE);
            DisplayMetrics metrics = new DisplayMetrics();
            wm.getDefaultDisplay().getMetrics(metrics);
            long shortSide = (long) Math.min(metrics.heightPixels, metrics.widthPixels);
            long longSide = (long) Math.max(metrics.heightPixels, metrics.widthPixels);
            Log.e(TAG, "shortSide=" + shortSide + " longSide=" + longSide);
            if (shortSide <= 480 && longSide <= 640) {
                return "vga";
            }
            if (shortSide <= 480 && longSide <= 854) {
                return "wvga";
            }
            if (shortSide > 540 || longSide > 960) {
                return "hd";
            }
            return "qhd";
        }
        catch (Exception e)
        {
            Log.e(TAG, "getScreenLayout Exception");
            e.printStackTrace();
        }
        return null;
    }

    public static void testQueryIntentActivities()
    {
        PackageManager packageManager = mContext.getPackageManager();
        Intent intent = new Intent("android.intent.action.MAIN");
        intent.addCategory("android.intent.category.LAUNCHER");
        packageManager.queryIntentActivities(intent, 0);
    }


    public static void testResolveContentProvider() {
        PackageManager packageManager = mContext.getPackageManager();
        ProviderInfo pi = packageManager.resolveContentProvider("com.cequint.ecid", PackageManager.GET_META_DATA);
        if (pi == null) {
            Log.e(TAG, "liupu: pi=null");
        } else {
            Log.e(TAG, "liupu: " + pi.toString());
        }
    }

    public static void testInstallApp(Context context) {
        Log.d(TAG, "enter testInstallApp");
        if (context instanceof Activity &&
                ContextCompat.checkSelfPermission(context,Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            Log.d(TAG, "request permission: android.permission.READ_EXTERNAL_STORAGE");
            ActivityCompat.requestPermissions((Activity) context, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, 1);
            return;
        }
        Log.d(TAG, "install apk");

        String filePath= Environment.getExternalStorageDirectory() + "/test.apk";
        File file = new File(filePath);
        Log.d(TAG, "filePath = " + filePath);

        Intent installIntent =new Intent(Intent.ACTION_VIEW);
        installIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            Uri apkUri = FileProvider.getUriForFile(context, "com.braden.mytest.fileprovider", file);
            installIntent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            installIntent.setDataAndType(apkUri, "application/vnd.android.package-archive");
        } else {
            installIntent.setDataAndType(Uri.fromFile(file), "application/vnd.android.package-archive");
        }
        context.startActivity(installIntent);
    }
}
