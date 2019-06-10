package com.braden.mytest;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
//import android.support.v7.app.AppCompatActivity;
import android.content.pm.ProviderInfo;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;

import com.braden.mytest.anr.ANRActivity;
import com.braden.mytest.crash.CrashActivity;
import com.braden.mytest.oeminfo.OeminfoActivity;
import com.braden.mytest.cts.CtsActivity;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.List;
import android.app.ActivityManager;
import android.app.ActivityManager.MemoryInfo;


public class MainActivity extends Activity
        implements View.OnClickListener {
    public static final String TAG = "MainActivity";
    private Context mContext = null;

    // for misc tests, common use
    private Button mButtMisc = null;
    private Button mButtCrash = null;
    private Button mButtANR = null;
    private Button mButtOeminfo = null;
    private Button mButtCts = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mContext = this;

        mButtMisc = (Button) findViewById(R.id.button_misc);
        mButtCrash = (Button) findViewById(R.id.button_crash);
        mButtANR = (Button) findViewById(R.id.button_anr);
        mButtOeminfo = (Button) findViewById(R.id.button_oeminfo);
        mButtCts = (Button) findViewById(R.id.button_cts);

        // setOnClickListener
        mButtMisc.setOnClickListener(this);
        mButtCrash.setOnClickListener(this);
        mButtANR.setOnClickListener(this);
        mButtOeminfo.setOnClickListener(this);
        mButtCts.setOnClickListener(this);
    }

    @Override
    public void onClick(View v)
    {
        int id = v.getId();

        if (R.id.button_misc == id) {
            doMiscTests();
        } else if (R.id.button_crash == id) {
            startActivity(new Intent(this, CrashActivity.class));
        } else if (R.id.button_anr == id) {
            startActivity(new Intent(this, ANRActivity.class));
        } else if (R.id.button_oeminfo == id) {
            startActivity(new Intent(this, OeminfoActivity.class));
        } else if (R.id.button_cts == id) {
            startActivity(new Intent(this, CtsActivity.class));
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    /* for misc tests, common use */
    private void doMiscTests() {
        // for simple tests
        //testForAll();

        // test resolveContentProvider
        testResolveContentProvider();
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

    public void testDnsWorks4() {
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
    public void testDnsWorks6() {
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

    public void testGetInstalledApplications() {
        Log.e(TAG, "testGetInstalledApplications begin");
        List<ApplicationInfo> packages =
                this.getPackageManager().getInstalledApplications(PackageManager.GET_META_DATA);
        Log.e(TAG, "testGetInstalledApplications end");
    }

    private long testGetMinMemory() {
        try {
            MemoryInfo memoryInfo = new MemoryInfo();
            ActivityManager am = (ActivityManager) this.getSystemService(Context.ACTIVITY_SERVICE);
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

    private String testGetScreenLayout() {
        try {
            WindowManager wm = (WindowManager) this.getSystemService(Context.WINDOW_SERVICE);
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

    private void testQueryIntentActivities()
    {
        PackageManager packageManager = this.getPackageManager();
        Intent intent = new Intent("android.intent.action.MAIN");
        intent.addCategory("android.intent.category.LAUNCHER");
        packageManager.queryIntentActivities(intent, 0);
    }


    public void testResolveContentProvider() {
        PackageManager packageManager = mContext.getPackageManager();
        ProviderInfo pi = packageManager.resolveContentProvider("com.cequint.ecid", PackageManager.GET_META_DATA);
        if (pi == null) {
            Log.e(TAG, "liupu: pi=null");
        } else {
            Log.e(TAG, "liupu: " + pi.toString());
        }
    }
}
