package ixxat.adk.demo;

import java.util.ArrayList;
import API.ADK.API_ADK;
import API.ADK.ConstantList;
import API.ADK.DeviceInformation;
import API.ADK.MessageStructure;
import API.ADK.ReturnCode;
import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.widget.*;

public class Demo_ADKActivity extends Activity {
	private API_ADK ADK = null;
	private API_ADK.Device demoDevice = null;
	private API_ADK.Device.Controller demoController = null;
	private API_ADK.Device.MessageChannel rxChannel = null;
	
	private TextView tv = null; 
	private String tvOutput = "";
   
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
    	RxThread rxThread = new RxThread();
    	MessageStructure demoTxMsg = new MessageStructure();
    	   
    	ReturnCode returnCode = null;
    	ArrayList<String> deviceList = new ArrayList<String>();
    	
        super.onCreate(savedInstanceState);
        tv = new TextView(this);        
        print("CANblue Demo Application (tested with Android V3.2)\n\n");
        print("This application demonstrates the usage of the CANblue ADK.\n");
        print("It establishs a Bluetooth connection to the first paired CANblue device, \n");
        print("initializes the CAN controller and transmits a CAN message. \n");
        print("After that a receive thread with a configured filter list will be started.\n");
        print("The receive thread prints every received CAN message, which passes the filter.\n\n");
        print("The CANblue has to be paired on the used Android device and as remote device \n");
        print("a CAN interface (1000 KBit/s) has to be connected to the CANblue via CAN.\n\n");
        
        print("Create ADK object...\t\t\t\t\t\t\t");
        ADK = API_ADK.createAPI_ADKObject();
        if (ADK != null){
        	print("OK (V" + ADK.getADKVersion() + ")\n");
        }
        else {
        	print("Failed\n");
        	return;
        }
        
        print("Initialize ADK object...\t\t\t\t\t\t");
        returnCode = ADK.initializeADK();
        if (returnCode == ReturnCode.SUCCESS){
            print("OK\n");
        }
        else {
        	print("Failed\n");
        	return;
        }
        
        print("Search for paired CANblue devices...\t\t");
        ADK.searchAvailableDevice(API_ADK.intDeviceList);
        for (int i=0; i<API_ADK.intDeviceList.numberOfDevice; i++) {
        	deviceList.add(API_ADK.intDeviceList.deviceName[i]);
        }
        if (API_ADK.intDeviceList.numberOfDevice > 0) {
        	print("OK (");
        	for (int i=0; i<API_ADK.intDeviceList.numberOfDevice; i++) {
             	print(API_ADK.intDeviceList.deviceName[i]);
             	if (i<API_ADK.intDeviceList.numberOfDevice-1) {print(", ");}
             	else { print("\n");}
             }
        }
        else {
        	print("Failed (no paired CANblue devices found)\n");
        	return;
        }
        
        print("Create device object...\t\t\t\t\t\t");
        demoDevice = ADK.createDeviceObject((byte)0);
        if (demoDevice != null) {
        	 print("OK (" + API_ADK.intDeviceList.deviceName[0] + ")\n");
        }
        else {
        	print("Failed");
        }
        
        print("Connect to CANblue device...\t\t\t\t");
        returnCode = demoDevice.connectDevice();
        if (returnCode == ReturnCode.SUCCESS){
            print("OK (Bluetooth connection established)\n");
        }
        else {
        	print("Failed\n");
        	return;
        }
        
        print("Read device information...\t\t\t\t\t");
        DeviceInformation deviceInformation = new DeviceInformation();
        returnCode = demoDevice.readDeviceInformation(deviceInformation);
        if (returnCode == ReturnCode.SUCCESS){
        	print("OK (" + deviceInformation.firmwareVersion + ")\n");
        }
        else {
        	print("Failed\n");
        	return;
        }
        
        print("\nCreate CAN controller object...\t\t\t\t");
        demoController = demoDevice.createControllerObject((byte)0);
        if (demoController != null) {
        	print("OK\n");
        }
        else {
        	print("Failed\n");
        	return;
        }
        
        print("Initialize CAN controller...\t\t\t\t\t");
        returnCode = demoController.initializeController(1000, ConstantList.SOFTWARE_FILTER);
        if (returnCode == ReturnCode.SUCCESS){
            print("OK (1000 KBit/s)\n");
        }
        else {
        	print("Failed\n");
        	return;
        }
        
        print("Start CAN controller...\t\t\t\t\t\t");
        returnCode = demoController.startController();
        if (returnCode == ReturnCode.SUCCESS){
            print("OK\n");
        }
        else {
        	print("Failed\n");
        	return;
        }
        
        print("Transmit CAN message...\t\t\t\t\t\t");
        demoTxMsg.frameFormat = ConstantList.STANDARD_FRAME;
        demoTxMsg.frameType = ConstantList.DATA_FRAME;
        demoTxMsg.dataLength = (byte) 8;
        demoTxMsg.messageID = 0x64;
        for (int i=0; i<demoTxMsg.dataLength; i++) {
        	demoTxMsg.data[i] = i;	
        }
        returnCode = demoController.transmitMessage(demoTxMsg, ConstantList.BINARY_FORMAT);
        if (returnCode == ReturnCode.SUCCESS){
            print("OK (SFF; ID=64; Data=00 01 02 03 04 05 06 07)\n");
        }
        else {
        	print("Failed\n");
        	return;
        }
        
        print("Stop CAN controller...\t\t\t\t\t\t\t");
        returnCode = demoController.stopController();
        if (returnCode == ReturnCode.SUCCESS){
            print("OK\n");
        }
        else {
        	print("Failed\n");
        	return;
        }
        
        print("\nCreate receive channel...\t\t\t\t\t\t");
        rxChannel = demoDevice.createMessageChannelObject((byte) 0);
        if (rxChannel != null) {
        	print("OK\n");
        }
        else {
        	print("Failed\n");
        	return;
        }
        
        print("Initialize receive channel...\t\t\t\t\t");
        returnCode = rxChannel.initializeMessageChannel();
        if (returnCode == ReturnCode.SUCCESS){
            print("OK\n");
        }
        else {
        	print("Failed\n");
        	return;
        }
        
        print("Add ID to receive filter...\t\t\t\t\t");
        returnCode = rxChannel.addReceiveFilter(API_ADK.STANDARD_FRAME, 0x64, API_ADK.DATA_FRAME);
        if (returnCode == ReturnCode.SUCCESS){
            print("OK (ID=64)\n");
        }
        else {
        	print("Failed\n");
        	return;
        }
        
        print("Enable receive filter...\t\t\t\t\t\t");
        returnCode = rxChannel.setReceiveFilter(API_ADK.STANDARD_FRAME, true);
        if (returnCode == ReturnCode.SUCCESS){
            print("OK\n");
        }
        else {
        	print("Failed\n");
        	return;
        }
        
        print("Start CAN controller...\t\t\t\t\t\t");
        returnCode = demoController.startController();
        if (returnCode == ReturnCode.SUCCESS){
            print("OK\n");
        }
        else {
        	print("Failed\n");
        	return;
        }
        
        print("\nStart receive thread...\t\t\t\t\t\t\t");
        try {
            rxThread.start();
            print("OK\n");
        }
        catch (Exception e){
        	print("Failed\n");
        }
    }

    public void print(String text) {
    	tvOutput = tvOutput + text;
    	tv.setText(tvOutput);
        setContentView(tv);
    }
    
    class RxThread extends Thread {
        Handler myHandler = new Handler();

        final Runnable r = new Runnable() {
          public void run() {
            MessageStructure demoRxMsg = new MessageStructure();
            
            while(rxChannel.receiveMessage(demoRxMsg) == ReturnCode.SUCCESS){
            	String data = "";
                String format = "";
            
                print("Receive CAN message...\t\t\t\t\t\t");
	            if (demoRxMsg.frameFormat == API_ADK.STANDARD_FRAME) {
	            	format = "SFF";   
	            }
	            else {
	            	format = "EFF";
	            }
	            for (byte i=0; i<demoRxMsg.dataLength; i++) {
	              data = data + Integer.toHexString(demoRxMsg.data[i]) + " ";
	            }
	            print("OK (" + format + "; ID=" + Integer.toHexString(demoRxMsg.messageID) +
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