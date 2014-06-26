package com.example.projectwork;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.ActionBarActivity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import API.ADK.*;

public class MainActivity extends ActionBarActivity {

	private TextView textview = null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		if (savedInstanceState == null) {
			getSupportFragmentManager().beginTransaction()
					.add(R.id.container, new PlaceholderFragment()).commit();
		}
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {

		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}

	/**
	 * A placeholder fragment containing a simple view.
	 */
	public static class PlaceholderFragment extends Fragment {

		public PlaceholderFragment() {
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
				Bundle savedInstanceState) {
			View rootView = inflater.inflate(R.layout.fragment_main, container,
					false);
			return rootView;
		}
	}

	/**
	 * Called when the user clicks the Connect button
	 */
	public void connectButton(View view) {

		textview = (TextView) findViewById(R.id.textView1);
		textview.setText("Create ADK object...\t\t\t\t\t\t\t");
		API_ADK ADK = API_ADK.createAPI_ADKObject();
		if (ADK != null) {
			textview.append("OK (V" + ADK.getADKVersion() + ")\n");
		} else {
			textview.append("Failed\n");
			return;
		}

		textview.append("Initialize ADK object...\t\t\t\t\t\t");
		ReturnCode returnCode = ADK.initializeADK();
		if (returnCode == ReturnCode.SUCCESS) {
			textview.append("OK\n");
		} else {
			textview.append("Failed\n");
			return;
		}

	}

}
