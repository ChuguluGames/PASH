package com.phonegap.plugins.downloader;

import java.net.URL;
import java.net.MalformedURLException;

import java.io.InputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import android.content.Context;
import android.os.StatFs;
import android.os.Environment;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;
import com.phonegap.api.PluginResult.Status;

public class Downloader extends Plugin {

/*
download image
save it
get url

check space
get image size
*/
	private static final String TAG = "Downloader";
	private static final String CMD_DOWNLOAD_PACK = "downloadPack";

	@Override
	public PluginResult execute(String action, JSONArray args, String callbackId) {

		Log.d(TAG, "Plugin Called");

		PluginResult result = null;

		if (action.equals(CMD_DOWNLOAD_PACK)) {
			Log.d(TAG, "Execute downloadPack");
			return this.downloadPack(1);

		} else {
			Log.e(TAG, "Invalid action : " + action + " passed");
			result = new PluginResult(Status.INVALID_ACTION);
		}

		return result;

	}

	private PluginResult downloadPack(int packID) {
		JSONObject response = new JSONObject();

		JSONObject image = new JSONObject();
		try {
			image.put("url", "http://static.skynetblogs.be/media/77706/dyn004_original_353_449_jpeg_2630690_3efd8d11723aaa3f7ba2f2712d59e33f.jpg");
			image.put("name", "1.jpg");
		} catch (JSONException e) {

		}

		String path = this.downloadImage(image);
		Log.d(TAG, path);

		try {
			response.put("path", path);
		} catch (JSONException e) {

		}

		return new PluginResult(PluginResult.Status.OK, response);
	}

	private String downloadImage(JSONObject image) {
		URL url = null;
		InputStream input = null;
		FileOutputStream output = null;
		Context c = this.ctx;

		long bytesAvailable = this.remainingLocalStorage(c);
		String imageUrl = null;
		String imageName = null;

		try {
			imageUrl = (String) image.getString("url");
			imageName = (String) image.getString("name");
		} catch (JSONException e) {

		}

		try {
		  url = new URL(imageUrl);
		} catch(MalformedURLException nameOfTheException){
			// Log.d(TAG, nameOfTheException);
		}

		try {
			input = url.openConnection().getInputStream();
			output = c.openFileOutput(imageName, c.MODE_PRIVATE);

			int read;
			byte[] data = new byte[1024];
			while ((read = input.read(data)) != -1)
				output.write(data, 0, read);

			if (output != null)
				output.close();
			if (input != null)
				input.close();

			// get the full path of the image
			String filesDirPath = c.getFilesDir().getAbsolutePath();
			Log.d(TAG, filesDirPath);

			return filesDirPath + "/" + imageName;

		} catch (IOException exception) {
			// Log.d(TAG, exception);

		}

		return "";
	}

	public static long remainingLocalStorage(Context c) {
		StatFs stat = new StatFs(Environment.getDataDirectory().getPath());
		stat.restat(Environment.getDataDirectory().getPath());
		long bytesAvailable = (long)stat.getBlockSize() *(long)stat.getAvailableBlocks();
		return bytesAvailable;
	}

}