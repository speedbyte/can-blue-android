package com.example.projectwork;

import java.util.Locale;

import API.ADK.API_ADK;
import API.ADK.ConstantList;
import API.ADK.MessageStructure;
import API.ADK.ReturnCode;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBarActivity;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

public class StartStopActivity extends ActionBarActivity {

	
	private TextView textview = null;
	private MessageStructure demoTxMsg = new MessageStructure();
	private ReturnCode returnCode = null;
	
	
	/**
	 * The {@link android.support.v4.view.PagerAdapter} that will provide
	 * fragments for each of the sections. We use a {@link FragmentPagerAdapter}
	 * derivative, which will keep every loaded fragment in memory. If this
	 * becomes too memory intensive, it may be best to switch to a
	 * {@link android.support.v4.app.FragmentStatePagerAdapter}.
	 */
	SectionsPagerAdapter mSectionsPagerAdapter;

	/**
	 * The {@link ViewPager} that will host the section contents.
	 */
	ViewPager mViewPager;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_start_stop);

		// Create the adapter that will return a fragment for each of the three
		// primary sections of the activity.
		mSectionsPagerAdapter = new SectionsPagerAdapter(
				getSupportFragmentManager());

		// Set up the ViewPager with the sections adapter.
		mViewPager = (ViewPager) findViewById(R.id.pager);
		mViewPager.setAdapter(mSectionsPagerAdapter);

	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {

		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.start_stop, menu);
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
	 * A {@link FragmentPagerAdapter} that returns a fragment corresponding to
	 * one of the sections/tabs/pages.
	 */
	public class SectionsPagerAdapter extends FragmentPagerAdapter {

		public SectionsPagerAdapter(FragmentManager fm) {
			super(fm);
		}

		@Override
		public Fragment getItem(int position) {
			// getItem is called to instantiate the fragment for the given page.
			// Return a PlaceholderFragment (defined as a static inner class
			// below).
			return PlaceholderFragment.newInstance(position + 1);
		}

		@Override
		public int getCount() {
			// Show 3 total pages.
			return 3;
		}

		@Override
		public CharSequence getPageTitle(int position) {
			Locale l = Locale.getDefault();
			switch (position) {
			case 0:
				return getString(R.string.title_section1).toUpperCase(l);
			case 1:
				return getString(R.string.title_section2).toUpperCase(l);
			case 2:
				return getString(R.string.title_section3).toUpperCase(l);
			}
			return null;
		}
	}

	/**
	 * A placeholder fragment containing a simple view.
	 */
	public static class PlaceholderFragment extends Fragment {
		/**
		 * The fragment argument representing the section number for this
		 * fragment.
		 */
		private static final String ARG_SECTION_NUMBER = "section_number";

		/**
		 * Returns a new instance of this fragment for the given section number.
		 */
		public static PlaceholderFragment newInstance(int sectionNumber) {
			PlaceholderFragment fragment = new PlaceholderFragment();
			Bundle args = new Bundle();
			args.putInt(ARG_SECTION_NUMBER, sectionNumber);
			fragment.setArguments(args);
			return fragment;
		}

		public PlaceholderFragment() {
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container,
				Bundle savedInstanceState) {
			View rootView = inflater.inflate(R.layout.fragment_start_stop,
					container, false);
			return rootView;
		}
	}
	
	public void startClick(View view)
	{

		textview = (TextView) findViewById(R.id.textView1);
		
		if(MainActivity.demoController != null)
		{
	        textview.setText("Transmit Start Message...\n");        
	        demoTxMsg.frameFormat = ConstantList.STANDARD_FRAME;
	        demoTxMsg.frameType = ConstantList.DATA_FRAME;
	        demoTxMsg.dataLength = (byte) 8;
	        demoTxMsg.messageID = 0x123;
	              
	        /* set the data of the CAN Message */
	        demoTxMsg.data[0] = 0x01;
	        demoTxMsg.data[1] = 0x00;
	        demoTxMsg.data[2] = 0x00;
	        demoTxMsg.data[3] = 0x00;
	        demoTxMsg.data[4] = 0x00;
	        demoTxMsg.data[5] = 0x00;
	        demoTxMsg.data[6] = 0x00;
	        demoTxMsg.data[7] = 0x00;
	        
	        
	        returnCode = MainActivity.demoController.transmitMessage(demoTxMsg, ConstantList.BINARY_FORMAT);
	        if (returnCode == ReturnCode.SUCCESS){
	            textview.append("OK (SFF; ID=0x123; Data=01 00 00 00 00 00 00 00)\n");
	        }
	        else {
	        	textview.append("Failed\n");
	        	return;
	        }
		}
		else
		{
			textview.setText("No Controller has been initialized!");
		}
	}

	
	public void stopClick(View view)
	{

		textview = (TextView) findViewById(R.id.textView1);
		
		if(MainActivity.demoController != null)
		{
	        textview.setText("Transmit STOP Message...\n");        
	        demoTxMsg.frameFormat = ConstantList.STANDARD_FRAME;
	        demoTxMsg.frameType = ConstantList.DATA_FRAME;
	        demoTxMsg.dataLength = (byte) 8;
	        demoTxMsg.messageID = 0x111;
	              
	        /* set the data of the CAN Message */
	        demoTxMsg.data[0] = 0x00;
	        demoTxMsg.data[1] = 0x00;
	        demoTxMsg.data[2] = 0x00;
	        demoTxMsg.data[3] = 0x00;
	        demoTxMsg.data[4] = 0x00;
	        demoTxMsg.data[5] = 0x00;
	        demoTxMsg.data[6] = 0x00;
	        demoTxMsg.data[7] = 0x00;
	        
	        
	        returnCode = MainActivity.demoController.transmitMessage(demoTxMsg, ConstantList.BINARY_FORMAT);
	        if (returnCode == ReturnCode.SUCCESS){
	            textview.append("OK (SFF; ID=0x123; Data=00 00 00 00 00 00 00 00)\n");
	        }
	        else {
	        	textview.append("Failed\n");
	        	return;
	        }
		}
		else
		{
			textview.setText("No Controller has been initialized!");
		}
	}
	
    
}
