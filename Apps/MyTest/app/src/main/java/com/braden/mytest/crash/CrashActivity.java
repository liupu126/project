package com.braden.mytest.crash;

//import android.support.v7.app.AppCompatActivity;
import android.app.Activity;
import android.os.Bundle;

import com.braden.mytest.R;

public class CrashActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_crash);
    }

    @Override
    protected void onStart()
    {
        super.onStart();

        doCrashByNullPointer();
    }

    public void doCrashByNullPointer()
    {
        String str = null;
        str.getBytes();
    }
}
