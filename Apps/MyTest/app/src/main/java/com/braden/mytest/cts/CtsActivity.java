package com.braden.mytest.cts;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.res.Resources;
//import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.inputmethod.InputMethodInfo;
import android.view.inputmethod.InputMethodManager;
import android.view.inputmethod.InputMethodSubtype;
import android.widget.Button;

import com.braden.mytest.R;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class CtsActivity extends Activity
        implements View.OnClickListener {
    public static final String TAG = "CtsActivity";

    private Context mContext = null;

    private Button mButtTestInputMethodSubtypesOfSystemImes = null;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_cts);

        mContext = this;

        mButtTestInputMethodSubtypesOfSystemImes = (Button) findViewById(R.id.button_testInputMethodSubtypesOfSystemImes);
        mButtTestInputMethodSubtypesOfSystemImes.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();

        if (R.id.button_testInputMethodSubtypesOfSystemImes == id)
        {
            testInputMethodSubtypesOfSystemImes();
        }
    }

    public void testInputMethodSubtypesOfSystemImes() {
        if (!mContext.getPackageManager().hasSystemFeature(
                PackageManager.FEATURE_INPUT_METHODS)) {
            return;
        }

        final InputMethodManager imm = mContext.getSystemService(InputMethodManager.class);
        final List<InputMethodInfo> imis = imm.getInputMethodList();
        final ArrayList<String> localeList = new ArrayList<>(Arrays.asList(
                Resources.getSystem().getAssets().getLocales()));
        for(int i=0; i<localeList.size(); i++)
        {
            Log.e(TAG, "localeList:"+ localeList.get(i));
        }
        boolean foundEnabledSystemImeSubtypeWithValidLanguage = false;
        for (InputMethodInfo imi : imis) {
            if ((imi.getServiceInfo().applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM) == 0) {
                continue;
            }
            final int subtypeCount = imi.getSubtypeCount();
            Log.e(TAG, "InputMethodInfo:" + imi.getServiceInfo().toString());
            Log.e(TAG, "InputMethodInfo:" + imi.getServiceInfo().applicationInfo.className);
            // System IME must have one subtype at least.
            // assertTrue(subtypeCount > 0);
            if (subtypeCount <= 0)
            {
                Log.e(TAG, "System IME must have one subtype at least.");
                continue;
            }

            if (foundEnabledSystemImeSubtypeWithValidLanguage) {
                continue;
            }
            final List<InputMethodSubtype> enabledSubtypes =
                    imm.getEnabledInputMethodSubtypeList(imi, true);
            for(int i=0; i<enabledSubtypes.size(); i++)
            {
                Log.e(TAG, "enabledSubtypes:"+ enabledSubtypes.get(i).getLocale());
            }

            SUBTYPE_LOOP:
            for (InputMethodSubtype subtype : enabledSubtypes) {
                final String subtypeLocale = subtype.getLocale();
                Log.e(TAG, "SUBTYPE_LOOP:"+ subtypeLocale);
                if (subtypeLocale.length() < 2) {
                    Log.e(TAG, "SUBTYPE_LOOP:continue");
                    continue;
                }
                // TODO: Detect language more strictly.
                final String subtypeLanguage = subtypeLocale.substring(0, 2);
                for (final String locale : localeList) {
                    if (locale.startsWith(subtypeLanguage)) {
                        foundEnabledSystemImeSubtypeWithValidLanguage = true;
                        break SUBTYPE_LOOP;
                    }
                }
            }
        }

        //assertTrue(foundEnabledSystemImeSubtypeWithValidLanguage);
        if (foundEnabledSystemImeSubtypeWithValidLanguage == false)
        {
            Log.e(TAG, "foundEnabledSystemImeSubtypeWithValidLanguage must be true, actual is false");
        }
        Log.e(TAG, "TAG TAG TAG");
    }
}
