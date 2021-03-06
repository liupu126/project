package com.braden.mytest;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
//import android.support.v7.app.AppCompatActivity;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import com.braden.mytest.anr.ANRActivity;
import com.braden.mytest.crash.CrashActivity;
import com.braden.mytest.oeminfo.OeminfoActivity;
import com.braden.mytest.cts.CtsActivity;
import com.braden.mytest.utils.TestUtils;

import java.io.File;

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
        //TestUtils.testForAll();

        // TestUtils.testResolveContentProvider();

        //TestUtils.testInstallApp(this);

        //TestUtils.testForArray();

        //TestUtils.testPhoneCrashIssue(this);

        //TestUtils.testPhoneCrashIssue2(this);

        // TestUtils.deleteFiles(new File("/storage/0000-0000"));
        // TestUtils.deleteFiles(new File("/storage/emulated/0"));

        TestUtils.testBreakpoints();
    }

}
