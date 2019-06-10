package com.braden.mytest.oeminfo;

import android.app.Activity;
//import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import com.braden.mytest.R;
import com.braden.oeminfo.OemInfo;
import com.braden.oeminfo.util.Util;

public class OeminfoActivity extends Activity
    implements View.OnClickListener {
    public static final String TAG = "OeminfoActivity";

    private Button mButtBinderTimeout = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_oeminfo);

        mButtBinderTimeout = (Button) findViewById(R.id.button_oeminfo_binder_timeout);
        mButtBinderTimeout.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();

        if (R.id.button_oeminfo_binder_timeout == id)
        {
            doCallBinderThroughJni();
        }
    }

    public void doCallBinderThroughJni()
    {
        Log.d(TAG, "doCallBinderThroughJni");
        byte[] bytes = OemInfo.getElem("PRODUCTLINE", "FactoryFlag");
        String str = Util.byteToString(bytes);
        Log.d(TAG, "str = " + str);
    }
}
