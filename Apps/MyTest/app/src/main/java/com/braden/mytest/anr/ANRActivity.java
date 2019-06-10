package com.braden.mytest.anr;

//import android.support.v7.app.AppCompatActivity;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import com.braden.mytest.R;

public class ANRActivity extends Activity
    implements View.OnClickListener{
    private static final String TAG = ANRActivity.class.getSimpleName();
    private Context mContext = null;
    private Button mButtClick = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_anr);

        mButtClick = (Button)findViewById(R.id.button_anr_click);
        mButtClick.setOnClickListener(this);

        mContext = this;
    }

    @Override
    protected void onResume()
    {
        super.onResume();
    }

    @Override
    public void onClick(View v)
    {
        int id = v.getId();

        if (R.id.button_anr_click == id)
        {
            doANRByLoop();
        }
    }

    public void doANRByLoop()
    {
        int loop = 1000*1000*1000;
        for (int i=0; i<=loop; i++)
        {
            try {
                Thread.sleep(1);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

}
