package com.example.projectwork;

import java.util.ArrayList;

import android.content.Intent;
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
	private API_ADK.Device demoDevice = null;
	public static API_ADK.Device.Controller demoController = null;

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
		

		textview = null;
		demoDevice = null;
		demoController = null;

		textview = (TextView) findViewById(R.id.textView1);
		textview.setText("Create ADK object...");
		
		
		API_ADK ADK = API_ADK.createAPI_ADKObject();
		if (ADK != null) {
			textview.append("OK (V" + ADK.getADKVersion() + ")\n");
		} else {
			textview.append("Failed\n");
			return;
		}

		textview.append("Initialize ADK object...");
		ReturnCode returnCode = ADK.initializeADK();
    	ArrayList<String> deviceList = new ArrayList<String>();
    	
		if (returnCode == ReturnCode.SUCCESS) {
			textview.append("OK\n");
		} else {
			textview.append("Failed\n");
			if(ADK.deinitializeADK() == ReturnCode.SUCCESS)
			{
				textview.append("Deinitialize Successful\n");
			}
			else
			{
				textview.append("Deinitialize Failed\n");
			}
			return;
		}
		
		textview.append("Search for paired CANblue devices...");
        ADK.searchAvailableDevice(API_ADK.intDeviceList);
        for (int i=0; i<API_ADK.intDeviceList.numberOfDevice; i++) {
        	deviceList.add(API_ADK.intDeviceList.deviceName[i]);
        }
        if (API_ADK.intDeviceList.numberOfDevice > 0) {
        	textview.append("OK (");
        	for (int i=0; i<API_ADK.intDeviceList.numberOfDevice; i++) {
        		textview.append(API_ADK.intDeviceList.deviceName[i]);
             	if (i<API_ADK.intDeviceList.numberOfDevice-1) {textview.append(", ");}
             	else { textview.append("\n");}
             }
        }
        else {
        	textview.append("Failed (no paired CANblue devices found)\n");
        	if(ADK.deinitializeADK() == ReturnCode.SUCCESS)
			{
				textview.append("Deinitialize Successful\n");
			}
			else
			{
				textview.append("Deinitialize Failed\n");
			}
        	return;
        }
        
        textview.append("Create device object...");
        demoDevice = ADK.createDeviceObject((byte)0);
        if (demoDevice != null) {
        	textview.append("OK (" + API_ADK.intDeviceList.deviceName[0] + ")\n");
        }
        else {
        	textview.append("Failed");
        	if(ADK.deinitializeADK() == ReturnCode.SUCCESS)
			{
				textview.append("Deinitialize Successful\n");
			}
			else
			{
				textview.append("Deinitialize Failed\n");
			}
        	return;
        }
        
        textview.append("Connect to CANblue device...");
        returnCode = demoDevice.connectDevice();
        if (returnCode == ReturnCode.SUCCESS){
        	textview.append("OK (Bluetooth connection established)\n");
        }
        else {
        	textview.append("Failed\n");
        	if(ADK.deinitializeADK() == ReturnCode.SUCCESS)
			{
				textview.append("Deinitialize Successful\n");
			}
			else
			{
				textview.append("Deinitialize Failed\n");
			}
        	return;
        }
        
        textview.append("Read device information...");
        DeviceInformation deviceInformation = new DeviceInformation();
        returnCode = demoDevice.readDeviceInformation(deviceInformation);
        if (returnCode == ReturnCode.SUCCESS){
        	textview.append("OK (" + deviceInformation.firmwareVersion + ")\n");
        }
        else {
        	textview.append("Failed\n");
        	if(ADK.deinitializeADK() == ReturnCode.SUCCESS)
			{
				textview.append("Deinitialize Successful\n");
			}
			else
			{
				textview.append("Deinitialize Failed\n");
			}
        	return;
        }
        
        textview.append("\nCreate CAN controller object...");
        demoController = demoDevice.createControllerObject((byte)0);
        if (demoController != null) {
        	textview.append("OK\n");
        }
        else {
        	textview.append("Failed\n");
        	if(ADK.deinitializeADK() == ReturnCode.SUCCESS)
			{
				textview.append("Deinitialize Successful\n");
			}
			else
			{
				textview.append("Deinitialize Failed\n");
			}
        	return;
        }
        
        textview.append("Initialize CAN controller...");
        returnCode = demoController.initializeController(1000, ConstantList.SOFTWARE_FILTER);
        if (returnCode == ReturnCode.SUCCESS){
        	textview.append("OK (1000 KBit/s)\n");
        }
        else {
        	textview.append("Failed\n");
        	if(ADK.deinitializeADK() == ReturnCode.SUCCESS)
			{
				textview.append("Deinitialize Successful\n");
			}
			else
			{
				textview.append("Deinitialize Failed\n");
			}
        	return;
        }
        
        textview.append("Start CAN controller...");
        returnCode = demoController.startController();
        if (returnCode == ReturnCode.SUCCESS){
        	textview.append("OK\n");
        }
        else {
        	textview.append("Failed\n");
        	if(ADK.deinitializeADK() == ReturnCode.SUCCESS)
			{
				textview.append("Deinitialize Successful\n");
			}
			else
			{
				textview.append("Deinitialize Failed\n");
			}
        	return;
        }

	}
	
	public void txButton(View view)
	{
		Intent intent = new Intent(this, StartStopActivity.class);
		startActivity(intent);
	}	
	
	public void rxButton(View view)
	{
		Intent intent = new Intent(this, RxActivity.class);
		startActivity(intent);
	}	
	

	
	

}
