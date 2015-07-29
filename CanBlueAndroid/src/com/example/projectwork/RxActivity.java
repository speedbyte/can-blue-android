package com.example.projectwork;

import API.ADK.API_ADK;
import API.ADK.MessageStructure;
import API.ADK.ReturnCode;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBar;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.os.Build;

public class RxActivity extends ActionBarActivity {
	

	RxThread rxThread = new RxThread();
	private API_ADK.Device.MessageChannel rxChannel = null;
	private ReturnCode returnCode = null;
	private API_ADK.Device demoDevice = null;
	private TextView textview = null;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_rx);

		if (savedInstanceState == null) {
			getSupportFragmentManager().beginTransaction()
					.add(R.id.container, new PlaceholderFragment()).commit();
		}
		
		textview = (TextView) findViewById(R.id.textView1);
		textview.setText("\nCreate receive channel...");
        rxChannel = demoDevice.createMessageChannelObject((byte) 0);
        if (rxChannel != null) {
        	textview.append("OK\n");
        }
        else {
        	textview.append("Failed\n");
        	return;
        }
        
        textview.append("Initialize receive channel...\t\t\t\t\t");
        returnCode = rxChannel.initializeMessageChannel();
        if (returnCode == ReturnCode.SUCCESS){
        	textview.append("OK\n");
        }
        else {
        	textview.append("Failed\n");
        	return;
        }
        
        textview.append("Add ID to receive filter...\t\t\t\t\t");
        returnCode = rxChannel.addReceiveFilter(API_ADK.STANDARD_FRAME, 0x64, API_ADK.DATA_FRAME);
        if (returnCode == ReturnCode.SUCCESS){
        	textview.append("OK (ID=64)\n");
        }
        else {
        	textview.append("Failed\n");
        	return;
        }
        
        textview.append("Enable receive filter...\t\t\t\t\t\t");
        returnCode = rxChannel.setReceiveFilter(API_ADK.STANDARD_FRAME, true);
        if (returnCode == ReturnCode.SUCCESS){
        	textview.append("OK\n");
        }
        else {
        	textview.append("Failed\n");
        	return;
        }
        
        textview.append("Start CAN controller...\t\t\t\t\t\t");
        returnCode = MainActivity.demoController.startController();
        if (returnCode == ReturnCode.SUCCESS){
        	textview.append("OK\n");
        }
        else {
        	textview.append("Failed\n");
        	return;
        }
        
        textview.append("\nStart receive thread...\t\t\t\t\t\t\t");
        try {
            rxThread.start();
            textview.append("OK\n");
        }
        catch (Exception e){
        	textview.append("Failed\n");
        }
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {

		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.rx, menu);
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
			View rootView = inflater.inflate(R.layout.fragment_rx, container,
					false);
			return rootView;
		}
	}
	
	class RxThread extends Thread {
        Handler myHandler = new Handler();

        final Runnable r = new Runnable() {
          public void run() {
            MessageStructure demoRxMsg = new MessageStructure();
            
            while(rxChannel.receiveMessage(demoRxMsg) == ReturnCode.SUCCESS){
            	String data = "";
                String format = "";
            
                textview.append("Receive CAN message...\t\t\t\t\t\t");
	            if (demoRxMsg.frameFormat == API_ADK.STANDARD_FRAME) {
	            	format = "SFF";   
	            }
	            else {
	            	format = "EFF";
	            }
	            for (byte i=0; i<demoRxMsg.dataLength; i++) {
	              data = data + Integer.toHexString(demoRxMsg.data[i]) + " ";
	            }
	            textview.append("OK (" + format + "; ID=" + Integer.toHexString(demoRxMsg.messageID) +
	                  " Data=" + data + ")\n");
            }
          }
        };

        public void run() {
          while(true) {
            try {
              Thread.sleep(10);
              myHandler.post(r);
            }
            catch (InterruptedException e) {
              break;
            }
          }
        }
      }

}
