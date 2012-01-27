package com.phonegap.pash;

import android.app.Activity;
import android.os.Bundle;
import com.phonegap.*;

import android.view.WindowManager;
import android.view.KeyEvent;

import android.util.Log;

public class PASH extends DroidGap
{
	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		// hide the status bar
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
												WindowManager.LayoutParams.FLAG_FULLSCREEN |
												WindowManager.LayoutParams.FLAG_FORCE_NOT_FULLSCREEN);

		super.setIntegerProperty("splashscreen", R.drawable.splash);

		super.loadUrl("file:///android_asset/www/index.html#/home", 1000);

	}

	@Override
	public void init() {
		super.init();
		this.appView.setBackgroundColor(0);
		this.appView.setBackgroundResource(R.drawable.splash);
	}

	@Override
	public void onBackPressed() {
		Log.d("pash", "on back pressed");
		return;
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		Log.d("pash", "on onKeyDown");
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			Log.d("pash", "on KEYCODE_BACK");

			//preventing default implementation previous to android.os.Build.VERSION_CODES.ECLAIR

			return true;

		}

		return super.onKeyDown(keyCode, event);
	}


}