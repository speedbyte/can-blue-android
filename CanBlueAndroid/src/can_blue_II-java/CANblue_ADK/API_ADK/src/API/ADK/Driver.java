package API.ADK;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Array;
import java.lang.reflect.Method;
import java.util.Date;
import java.util.Set;
import java.util.concurrent.Semaphore;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;

// The class of Driver --------------------------------------------------------
/**
 * CANBlue Implementation of the Driver Class. This class should not be used 
 * directly. When using {@link API_ADK}, this class is created automatically and 
 * used internally.
 * @author hroesdiyono
 */
public class Driver implements ConstantList
{
  /** Keep the number of object for this class. */
  private static byte numberOfObject = 0;

  /** Private constructor, can only be called from inside the class. */
  private Driver()
  {
    // Initialize the internal device list.
    intDeviceList = new DeviceList();
  }

  /**
   * Call this method to create this class object.
   * The object can only be created once.
   * When used with {@link API_ADK}, it is created automatically.
   * @return {@link Driver} object or null if the object creation fails.
   */
  public static synchronized Driver createDriverObject()
  {
    if (numberOfObject == 0)
    {
      numberOfObject++;
      return new Driver();
    }
    else
    {
      return null;
    }
  }

  /**
   * Structure contains list of devices, controllers, message channels,
   * including the name, number of each parts, and their connection status.
   * This structure is used internally and should be filled to be able to use 
   * the Driver. Call {@link #listPairedDevice}, then use its parameter and
   * this structure in {@link #checkForSupportedDevice}.
   */
  volatile public static DeviceList intDeviceList;

  /** Local Bluetooth adapter. */
  private BluetoothAdapter drvBTAdapter;

  /** Internal initialization status to make sure the object of this class 
   * has been initialize before using it and could not be used anymore 
   * after deinitializing it. */
  volatile ReturnCode driverStatus = ReturnCode.OBJECT_IS_NOT_INITIALIZED;

  /** The version string of the Driver. */
  private static final String DRIVER_VERSION = "0.0.3";

  /**
   * Return the version of the Driver.
   * @return The string of the Driver version.
   */
  public String getDriverVersion()
  {
    return DRIVER_VERSION;
  }

  /**
   * Initialize objects and variables for Driver class.
   * Call this method only if it is used with the API_ADK. It synchronizes the 
   * content of {@link #intDeviceList} with the one in API_ADK.
   * @return {@link ReturnCode#SUCCESS}.
   */
  public ReturnCode initializeObjects()
  {
    intDeviceList = API_ADK.intDeviceList;
    return ReturnCode.SUCCESS;
  }

  /**
   * Initialize the communication interface. Call this method before calling 
   * any other method. Check whether the Bluetooth is available and turned on.
   * Turn the Bluetooth on automatically if it is turned off.
   * @return {@link ReturnCode#SUCCESS}, 
   *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED}, 
   *         {@link ReturnCode#FAIL_ACCESSING_BLUETOOTH}, 
   *         {@link ReturnCode#BLUETOOTH_NOT_SUPPORTED}, or 
   *         {@link ReturnCode#FAIL_TURNING_BLUETOOTH_ON}.
   */
  public ReturnCode initializeCommunicationInterface()
  {
    if (driverStatus == ReturnCode.OBJECT_IS_INITIALIZED)
    {
    	// It is already initialized.
    	return ReturnCode.SUCCESS;
    }
    else if (driverStatus == ReturnCode.OBJECT_IS_DEINITIALIZED)
    {
    	// It is already deinitialized, can not be used anymore.
    	return driverStatus;
    }

    // Get the local Bluetooth adapter
    try
    {
      drvBTAdapter = BluetoothAdapter.getDefaultAdapter();
    }
    catch (Exception e)
    {
      // Possibly Runtime exception due to accessing the Bluetooth
      // Adapter not from an Activity thread.
      e.printStackTrace();
      return ReturnCode.FAIL_ACCESSING_BLUETOOTH;
    }

    // If the adapter is null, then the Bluetooth is not supported.
    if (drvBTAdapter == null)
    {
      return ReturnCode.BLUETOOTH_NOT_SUPPORTED;
    }

    // Check whether the Bluetooth is turned off, turn it on.
    if (!drvBTAdapter.isEnabled())
    {
      if (drvBTAdapter.enable() != true)
      {
        return ReturnCode.FAIL_TURNING_BLUETOOTH_ON;
      }
      // Wait until the Bluetooth is turned on.
      while (drvBTAdapter.getState() != BluetoothAdapter.STATE_ON);
    }

    // Cancel the discovery process if it is turned on, it slows the Bluetooth,
    // and is not used.
    drvBTAdapter.cancelDiscovery();

    driverStatus = ReturnCode.OBJECT_IS_INITIALIZED;
    return ReturnCode.SUCCESS;
  }

  /**
   * Close the communication interface.
   * Check whether all {@link CANDevice} objects have been deinitialized 
   * and turn the Bluetooth off. This method should be called before 
   * {@link Driver#deinitializeObjects}.
   * @return {@link ReturnCode#SUCCESS}, 
   *         {@link ReturnCode#DEVICE_INSTANCE_STILL_OPEN}, or 
   *         {@link ReturnCode#FAIL_TURNING_BLUETOOTH_OFF}.
   */
  public ReturnCode deinitializeCommunicationInterface()
  {
    if (driverStatus == ReturnCode.OBJECT_IS_DEINITIALIZED)
    {
      // It is already deinitialized.
      return ReturnCode.SUCCESS;
    }
    // Check the status of the device instances, all instances should
    // be in the state of not created.
    for (int i = 0; i < intDeviceList.numberOfController; i++)
    {
      if (intDeviceList.deviceObjectStatus[i] !=
          ConnectionStatus.INSTANCE_NOT_CREATED)
      {
        return ReturnCode.DEVICE_INSTANCE_STILL_OPEN;
      }
    }

    // The Bluetooth object is valid if only the initialization is success.
    if (driverStatus == ReturnCode.OBJECT_IS_INITIALIZED)
    {
	    // Turn the Bluetooth off.
	    if (drvBTAdapter.disable() != true)
	    {
	      return ReturnCode.FAIL_TURNING_BLUETOOTH_OFF;
	    }
	    // Wait the Bluetooth to turn off.
	    while (drvBTAdapter.getState() != BluetoothAdapter.STATE_OFF);
    }

    return ReturnCode.SUCCESS;
  }

  /**
   * Destroy used objects and variables. This method should be called last, 
   * if the object is not used any more.
   * @return {@link ReturnCode#SUCCESS}.
   */
  public ReturnCode deinitializeObjects()
  {
    drvBTAdapter = null;
    if (numberOfObject != 0)
    {
      numberOfObject--;
    }

    driverStatus = ReturnCode.OBJECT_IS_DEINITIALIZED;
    return ReturnCode.SUCCESS;
  }

  /**
   * Return the list of all paired device.
   * @param pairedList Output: List of all paired devices.
   * @return {@link ReturnCode#SUCCESS}, 
   *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
   *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
   *         {@link ReturnCode#DEVICEONLYLIST_OBJECT_NOT_VALID},
   *         {@link ReturnCode#MAXIMUM_BYTE_CAPACITY_REACH}, or 
   *         {@link ReturnCode#NO_PAIRED_DEVICE}.
   */
  public ReturnCode listPairedDevice(DeviceOnlyList pairedList)
  {
    // The Driver should be initialized first.
    if (driverStatus != ReturnCode.OBJECT_IS_INITIALIZED)
    {
      return driverStatus;
    }

    // Check the validity of the parameter.
	  if (pairedList == null)
	  {
		  return ReturnCode.DEVICEONLYLIST_OBJECT_NOT_VALID;
	  }

    // List all paired devices.
    Set<BluetoothDevice> pairedDevices = drvBTAdapter.getBondedDevices();
    if (pairedDevices.size() > MAXIMUM_BYTE_SIZE)
    {
      return ReturnCode.MAXIMUM_BYTE_CAPACITY_REACH;
    }
    if (pairedDevices.size() != 0)
    {
      // The number of paired device is not zero.
      pairedList.numberOfDevice = (byte) pairedDevices.size();
      pairedList.detectionStatus =
          new DetectionMethod[pairedList.numberOfDevice];
      pairedList.deviceMACAddress =
          new String[pairedList.numberOfDevice];
      pairedList.deviceName =
          new String[pairedList.numberOfDevice];
      byte i = 0;
      for (BluetoothDevice device : pairedDevices)
      {
        pairedList.deviceName[i] = device.getName();
        pairedList.deviceMACAddress[i] = device.getAddress();
        pairedList.detectionStatus[i] = DetectionMethod.PAIRED_DEVICE;
        i++;
      }
    }
    else
    {
      pairedList.numberOfDevice = 0;
      return ReturnCode.NO_PAIRED_DEVICE;
    }
    return ReturnCode.SUCCESS;
  }

  /**
   * Remove unsupported device and only return list of supported device and
   * add their number of controllers by comparing from the database table.
   * @param pairedList    Input: List of all paired devices.
   * @param supportedList Output: List of supported devices.
   * @return {@link ReturnCode#SUCCESS}, 
   *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
   *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
   *         {@link ReturnCode#DEVICEONLYLIST_OBJECT_NOT_VALID},
   *         {@link ReturnCode#DEVICELIST_OBJECT_NOT_VALID},
   *         {@link ReturnCode#NO_SUPPORTED_DEVICE}, or 
   *         {@link ReturnCode#MAXIMUM_BYTE_CAPACITY_REACH}.
   */
  public ReturnCode checkForSupportedDevice(DeviceOnlyList pairedList,
      DeviceList supportedList)
  {
    // The Driver should be initialized first.
    if (driverStatus != ReturnCode.OBJECT_IS_INITIALIZED)
    {
      return driverStatus;
    }

    // Check the validity of the parameter.
    if (pairedList == null)
    {
      return ReturnCode.DEVICEONLYLIST_OBJECT_NOT_VALID;
    }
    if (supportedList == null)
    {
      return ReturnCode.DEVICELIST_OBJECT_NOT_VALID;
    }

    int foundIndex = -1;
    byte tempListIndex = 0;
    if (pairedList.numberOfDevice != 0)
    {
      // Initiate the temporary list size with 2 times the size of paired
      // device, in case all the devices are supported and has 2 controllers.
      int listSize = 2 * pairedList.numberOfDevice;
      if (listSize > MAXIMUM_BYTE_SIZE)
      {
        return ReturnCode.MAXIMUM_BYTE_CAPACITY_REACH;
      }

      supportedList.numberOfDevice = 0;
      supportedList.numberOfController = 0;
      supportedList.listIndex = new byte[listSize];
      supportedList.deviceIndex = new byte[listSize];
      supportedList.deviceName = new String[listSize];
      supportedList.deviceType = new DeviceType[listSize];
      supportedList.deviceMACAddress = new String[listSize];
      supportedList.detectionStatus = new DetectionMethod[listSize];
      supportedList.controllerIndex = new byte[listSize];
      supportedList.deviceObjectStatus = new ConnectionStatus[listSize];
      supportedList.controllerObjectStatus = new ConnectionStatus[listSize];
      supportedList.controllerStatus = new ControllerStatus[listSize];
      supportedList.receiveFilterType = new byte[listSize];
      supportedList.numberOfMessageChannel = new byte[listSize];

      for (byte i = 0; i < pairedList.numberOfDevice; i++)
      {
        for (byte j = 0; j < DeviceListInformation.numberOfSupportedDevice;
            j++)
        {
          // Compare the list of paired device with the supported one.
          foundIndex = pairedList.deviceName[i].indexOf(
              DeviceListInformation.deviceName[j]);
          if (foundIndex != -1)
          {
            // Find a supported device.
            // Make the number of line as many as the number of controller;
            for (byte k = 0; k < DeviceListInformation.numberOfController[j];
                k++)
            {
              // Fill the listIndex with the array index.
              supportedList.listIndex[tempListIndex] = tempListIndex;
              // The device index starts from 0.
              supportedList.deviceIndex[tempListIndex] =
                  supportedList.numberOfDevice;
              // Copy the device name.
              supportedList.deviceName[tempListIndex] =
                  pairedList.deviceName[i];
              // Copy the MAC address.
              supportedList.deviceMACAddress[tempListIndex] =
                  pairedList.deviceMACAddress[i];
              // Copy the device type.
              supportedList.deviceType[tempListIndex] =
                  DeviceListInformation.deviceType[j];
              // Copy the detection status.
              supportedList.detectionStatus[tempListIndex] =
                  pairedList.detectionStatus[i];
              // The controller index starts from 0 for each device.
              supportedList.controllerIndex[tempListIndex] = k;
              // Initialize variables. The default filter is Hardware filter.
              supportedList.deviceObjectStatus[tempListIndex] =
                  ConnectionStatus.INSTANCE_NOT_CREATED;
              supportedList.controllerObjectStatus[tempListIndex] =
                  ConnectionStatus.INSTANCE_NOT_CREATED;
              supportedList.controllerStatus[tempListIndex] =
                  ControllerStatus.CONTROLLER_UNKNOWN;
              supportedList.receiveFilterType[tempListIndex] =
                  API_ADK.HARDWARE_FILTER;
              supportedList.numberOfMessageChannel[tempListIndex] = 0;
              // Increase the list index.
              tempListIndex++;
            }
            // Add the number of controller and increase the number
            // of device.
            supportedList.numberOfController +=
                DeviceListInformation.numberOfController[j];
            supportedList.numberOfDevice++;
            break;
          }
        }
      }
      if (supportedList.numberOfDevice == 0){
        return ReturnCode.NO_SUPPORTED_DEVICE;
      }
      return ReturnCode.SUCCESS;
    }
    else {
      return ReturnCode.NO_PAIRED_DEVICE;
    }
  }

  /**
   * Create an object of the CANDevice class.
   * @param inputListIndex Input: The listIndex of {@link Driver#intDeviceList}
   *     value.
   * @return {@link CANDevice} object or null if it is already created.
   */
  public CANDevice createCANDeviceObject(byte inputListIndex)
  {
    // The Driver should be initialized first.
    if (driverStatus != ReturnCode.OBJECT_IS_INITIALIZED)
    {
      return null;
    }

    if (intDeviceList.numberOfController == 0)
    {
      return null; // The list is empty;
    }
    if ((inputListIndex > intDeviceList.numberOfController) || 
    		(inputListIndex < 0))
    {
      return null; // Invalid index.
    }

    // Check whether the object is already created.
    // The object can only be one for each device.
    if (intDeviceList.deviceObjectStatus[inputListIndex] ==
        ConnectionStatus.INSTANCE_NOT_CREATED)
    {
      // In case of a device with more than one controller, check and fill all
      // the same deviceIndex with ConnectionStatus.INSTANCE_CREATED
      for (byte i = 0; i < intDeviceList.numberOfController; i++)
      {
        if (intDeviceList.deviceIndex[i] ==
            intDeviceList.deviceIndex[inputListIndex])
        {
          intDeviceList.deviceObjectStatus[i] = ConnectionStatus.INSTANCE_CREATED;
        }
      }
      return new CANDevice(inputListIndex);
    }
    else
    {
      return null;
    }
  }

// The class of CANDevice -----------------------------------------------------
  /**
   * Subclass CANDevice.
   * All command supported by the CANblue are included here.
   * @author hroesdiyono
   * @see API_ADK.Device
   */
  public class CANDevice
  {
    /**
     * Private constructor, can only be called from inside the class.
     * It initializes internal variables and objects.
     * When used with {@link API_ADK}, it is created automatically at the 
     * creation of {@link API_ADK.Device} object.
     * @param inputListIndex Input: The listIndex of
     *     {@link Driver#intDeviceList} value.
     */
    private CANDevice(byte inputListIndex)
    {
      // Copy the device index and list index.
      deviceIndex = intDeviceList.deviceIndex[inputListIndex];
      listIndex = inputListIndex;
      // Initialize the response buffer.
      respBuffer = new ResponseBuffer();
    }

    /** Internal index. */
    private byte deviceIndex, listIndex;

    /** Internal initialization status to make sure the object of this class 
     * has been initialize before using it and could not be used anymore 
     * after deinitializing it. */
    volatile ReturnCode deviceStatus = ReturnCode.OBJECT_IS_NOT_INITIALIZED;

    /** Bluetooth variable. */
    private BluetoothDevice driverBluetoothDevice;
    private BluetoothSocket driverBluetoothSocket;
    private InputStream driverInputStream;
    private OutputStream driverOutputStream;

    /**
     * Receive thread for receiving a response/message from the
     * input stream of Bluetooth.
     */
    private ReceiveData receiveDataThread;
    /** The status of the receive thread whether it is still running or not. */
    private ReturnCode receiveThreadFlag = ReturnCode.THREAD_STOPPED;

    /**
     * Transmit thread for transmitting bulk message and increase data rate.
     */
    private TransmitBulkMessage transmitThread;
    /** The status of the transmit thread whether it is still running or not. */
    private ReturnCode transmitThreadFlag = ReturnCode.THREAD_STOPPED;

    /** The index of the bulk transmit buffer. */
    private volatile int bulkBufferIndex;
    /** The bulk transmit buffer. */
    private volatile byte[] bulkBuffer = new byte[500];
    /** The semaphore used by the transmit thread and put message method. */
    private Semaphore bulkBufferFlag = new Semaphore(1, false);
    /** The limit of the bulk transmit buffer. */
    private final int bulkBufferFull = 400;

    /** A response buffer for each Device / Bluetooth connection. */
    private volatile ResponseBuffer respBuffer;

    /**
     * Version information flag. The version information is sent by the device 
     * if the version command is sent, which is needed, or at the beginning of 
     * Bluetooth communication if the autostart flag is on, which is not needed 
     * and should be ignored.
     */
    private boolean versionNeeded = false;

    /**
     *  A {@link CANMessage} array, for internal use.
     * This array is used in the filtering process.
     * Currently, there is only one controller for each device, so
     * the CANMessage array is only one dimensional.
     */
    private CANMessage[] intCANMessage;

    /** Global variable for waiting for response counter. */
    private long timeOutCounter;
    /** Global variable for string search. */
    private int foundIndex;
    /** Global variable for a loop. */
    private int index;
    /** Global variable for {@link ReturnCode}. */
    private ReturnCode returnCode;

    /**
     * Initialize the object, open a connection to the device, and start the 
     * internal threads.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#INVALID_MAC_ID},
     *         {@link ReturnCode#UNKNOWN_DEVICE},
     *         {@link ReturnCode#FAIL_GETTING_REMOTE_DEVICE}, 
     *         {@link ReturnCode#FAIL_CREATING_BLUETOOTH_SOCKET},
     *         {@link ReturnCode#FAIL_CLOSING_BLUETOOTH_SOCKET}, 
     *         {@link ReturnCode#FAIL_OPENING_BLUETOOTH_SOCKET}, 
     *         {@link ReturnCode#FAIL_OPENING_INPUTSTREAM}, 
     *         {@link ReturnCode#FAIL_OPENING_OUTPUTSTREAM}, or 
     *         {@link ReturnCode#FAIL_STARTING_RECEIVE_THREAD}.
     */
    public ReturnCode connectDevice()
    {
      if (deviceStatus == ReturnCode.OBJECT_IS_DEINITIALIZED)
      {
      	// It is already deinitialized, can not be used anymore.
      	return deviceStatus;
      }

      // Get the BluetoothDevice object.
      try
      {
        driverBluetoothDevice = drvBTAdapter.getRemoteDevice(
            intDeviceList.deviceMACAddress[listIndex]);
      }
      catch (Exception e)
      {
        e.printStackTrace();
        return ReturnCode.INVALID_MAC_ID;
      }
      if (driverBluetoothDevice == null)
      {
        return ReturnCode.FAIL_GETTING_REMOTE_DEVICE;
      }

      // Make a connection to the BluetoothSocket.
      // There are 2ways of connecting to the device.
      // First by using the default port (UUID).
      // Second by manually defining the port and try to connect to
      // one of the port.

      // The CANblue could connect using either secure
      // and insecure communication mode, but CANblue II could only
      // connect using insecure communication mode, so the insecure
      // communication mode is used.

      // First way, currently not used.
      //try {
      //    driverBluetoothSocket =
      //        driverBluetoothDevice.
      //        createInsecureRfcommSocketToServiceRecord(
      //        MY_UUID_INSECURE);
      //} catch (IOException e) {
      //    return ReturnCode.FAIL_CREATING_BLUETOOTH_SOCKET;
      //}
      //try {
      //    // This is a blocking call and will only return on a
      //    // successful connection or an exception
      //    driverBluetoothSocket.connect();
      //} catch (IOException e) {
      //    // Close the socket
      //    try {
      //        driverBluetoothSocket.close();
      //    } catch (IOException e2) {
      //        return ReturnCode.FAIL_CLOSING_BLUETOOTH_SOCKET;
      //    }
      //    return ReturnCode.FAIL_OPENING_BLUETOOTH_SOCKET;
      //}

      // Second way, try to connect to the port 1-2.
      // Since the CANblue II has 2 ports, the connection should be
      // made to port 2. While the CANblue only has 1 port.
      byte portNumber;
      if (intDeviceList.deviceType[listIndex] == DeviceType.CANBLUE)
      {
        portNumber = 1;
      }
      else if (intDeviceList.deviceType[listIndex] == DeviceType.CANBLUE_II)
      {
    	  portNumber = 2;
      }
      else
      {
        return ReturnCode.UNKNOWN_DEVICE;
      }

      try
      {
        Method insecureMethod = driverBluetoothDevice.getClass().getMethod(
            "createInsecureRfcommSocket", new Class[] { int.class });

        driverBluetoothSocket = (BluetoothSocket) insecureMethod.invoke(
            driverBluetoothDevice, portNumber);
      }
      catch (Exception e)
      {
        e.printStackTrace();
        return ReturnCode.FAIL_CREATING_BLUETOOTH_SOCKET;
      }

      // Try to connect to the Bluetooth device.
      try
      {
        // This is a blocking call and will only return on a
        // successful connection or an exception if failed.
        driverBluetoothSocket.connect();
      }
      catch (Exception e1)
      {
        // Failed to connect to the device.
        e1.printStackTrace();
        // Try to close the socket.
        try
        {
          driverBluetoothSocket.close();
        }
        catch (Exception e2)
        {
          e2.printStackTrace();
          return ReturnCode.FAIL_CLOSING_BLUETOOTH_SOCKET;
        }
        return ReturnCode.FAIL_OPENING_BLUETOOTH_SOCKET;
      }

      // Open input and output stream.
      try
      {
        driverInputStream = driverBluetoothSocket.getInputStream();
      }
      catch (Exception e)
      {
        e.printStackTrace();
        return ReturnCode.FAIL_OPENING_INPUTSTREAM;
      }
      try
      {
        driverOutputStream = driverBluetoothSocket.getOutputStream();
      }
      catch (Exception e)
      {
        e.printStackTrace();
        return ReturnCode.FAIL_OPENING_OUTPUTSTREAM;
      }

      // Reset the response buffer, run the receive thread, and 
      // return immediately. In generic mode, there is no version
      // information line sent.
      respBuffer.resetResponseBuffer();
      // Initialize the receive thread.
      receiveDataThread = new ReceiveData();
      // Initialize the transmit thread.
      transmitThread = new TransmitBulkMessage();
      if (receiveThreadFlag != ReturnCode.THREAD_RUNNING)
      {
        try
        {
          receiveDataThread.start();
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_STARTING_RECEIVE_THREAD;
        }
      }

      // Start the transmit thread.
      if (receiveThreadFlag != ReturnCode.THREAD_RUNNING)
      {
        try
        {
          transmitThread.start();
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_STARTING_TRANSMIT_THREAD;
        }
      }

      deviceStatus = ReturnCode.OBJECT_IS_INITIALIZED;
      return ReturnCode.SUCCESS;
    }

    /**
     * Check whether all {@link CANController} and {@link CANMessage} objects 
     * have been deinitialized, close a connection to the device, and stop 
     * the internal threads.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#CONTROLLER_INSTANCE_STILL_CONNECTED}, 
     *         {@link ReturnCode#MESSAGE_CHANNEL_STILL_OPEN}, or 
     *         {@link ReturnCode#FAIL_CLOSING_BLUETOOTH_SOCKET}.
     */
    public ReturnCode disconnectDevice()
    {
      if (driverStatus == ReturnCode.OBJECT_IS_DEINITIALIZED)
      {
      	// It is already deinitialized.
      	return ReturnCode.SUCCESS;
      }

      // Check the status of the controller and message channel.
      // All instances should be in the state of not created.
      for (byte i = 0; i < intDeviceList.numberOfController; i++)
      {
        // In case the device has more than one controller, check
        // the status of the Controllers and their Message Channel.
        if (intDeviceList.deviceIndex[i] ==
            intDeviceList.deviceIndex[listIndex])
        {
          if (intDeviceList.controllerObjectStatus[i] !=
              ConnectionStatus.INSTANCE_NOT_CREATED )
          {
            return ReturnCode.CONTROLLER_INSTANCE_STILL_CONNECTED;
          }
          if (intDeviceList.numberOfMessageChannel[i] != 0)
          {
            return ReturnCode.MESSAGE_CHANNEL_STILL_OPEN;
          }
        }
      }

      // Stop the receiving and transmitting thread.
      receiveDataThread = null;
      transmitThread = null;
      transmitThreadFlag = ReturnCode.THREAD_STOPPED;
      receiveThreadFlag = ReturnCode.THREAD_STOPPED;

      // Unreference input and output stream.
      driverInputStream = null;
      driverOutputStream = null;

      // The socket is valid, if only it is initialized.
      if (deviceStatus == ReturnCode.OBJECT_IS_INITIALIZED)
      {
	      // Close the Bluetooth socket.
	      try
	      {
	        driverBluetoothSocket.close();
	      }
	      catch (Exception e)
	      {
	        e.printStackTrace();
	        return ReturnCode.FAIL_CLOSING_BLUETOOTH_SOCKET;
	      }
      }

      // Unreference Bluetooth socket and device.
      driverBluetoothSocket = null;
      driverBluetoothDevice = null;

      // Change the status of the device.
      for (int i = 0; i < intDeviceList.numberOfController; i++)
      {
        if (intDeviceList.deviceIndex[i] ==
            intDeviceList.deviceIndex[listIndex])
        {
          intDeviceList.deviceObjectStatus[i] =
              ConnectionStatus.INSTANCE_NOT_CREATED;
        }
      }

      deviceStatus = ReturnCode.OBJECT_IS_DEINITIALIZED;
      return ReturnCode.SUCCESS;
    }

    /**
     * Read the Firmware version of the Device. 
     * @param deviceInformation Output: The information from the device, 
     *     including version, protocol and hardware number information.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode readDeviceVersion(DeviceInformation deviceInformation)
    {
        // Can not be used if the device object is not initialized.
        if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return deviceStatus;
        }

        // Check the validity of the parameter.
        if (deviceInformation == null)
        {
          return ReturnCode.DEVICEINFORMATION_OBJECT_NOT_VALID;
        }
        return readCANblueVersion(deviceInformation);
      }

      /**
       * Read the protocol version of the Device.
       * @param deviceInformation Output: The information from the device, 
       *     including version, protocol and hardware number information.
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#INVALID_RESPONSE}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode readDeviceProtocol(DeviceInformation deviceInformation)
      {
        // Can not be used if the device object is not initialized.
        if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return deviceStatus;
        }

        // Check the validity of the parameter.
        if (deviceInformation == null)
        {
          return ReturnCode.DEVICEINFORMATION_OBJECT_NOT_VALID;
        }
        return readCANblueProtocol(deviceInformation);
      }

      /**
       * Read the hardware number of the Device. 
       * @param deviceInformation Output: The information from the device, 
       *     including version, protocol and hardware number information.
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#FAIL_PARSING_HARDWARE_NUMBER}, 
       *         {@link ReturnCode#UNKNOWN_DEVICE}, 
       *         {@link ReturnCode#NO_VALID_HARDWARE_NUMBER}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode readHardwareNumber(DeviceInformation deviceInformation)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the parameter.
      if (deviceInformation == null)
      {
        return ReturnCode.DEVICEINFORMATION_OBJECT_NOT_VALID;
      }
      return readCANblueHardwareNumber(deviceInformation);
    }

    /**
     * Read the status of the CAN Controller and the status of the internal 
     * transmit and receive thread. Eventhough the return code is not success, 
     * the thread status are valid.
     * If the threads are not running, try to connect to the device again.
     * param flag Output: The status of the controller and threads.
     * return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode readErrorStatus(ErrorBuffer flag)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the parameter.
      if (flag == null)
      {
        return ReturnCode.ERRORBUFFER_OBJECT_NOT_VALID;
      }

      flag.transmitThreadStatus = transmitThreadFlag;
      flag.receiveThreadStatus = receiveThreadFlag;

      ReturnCode returnCode;
      // Since currently there is only 1 CAN controller for each device, 
      // so there is only one status. 
      returnCode = readCANblueControllerInfo(flag.status);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }
      return ReturnCode.SUCCESS;
    }

    // Bluetooth Specific methods ---------------------------------------------
    /**
     * Put data to Bluetooth output stream and a '\n' is automatically added.
     * This method is used to transmit command.
     * @param data Input: String of command.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, or 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH}.
     */
    private ReturnCode writeStringToBluetooth(String data)
    {
      // Check the validity of the input.
      if (data == null)
      {
        return ReturnCode.STRING_NOT_VALID;
      }
      char returnLine = 0xA;
      String sendCommand = data + returnLine;
      byte[] buffer;

      try
      {
        buffer = sendCommand.getBytes();
      }
      catch (Exception e)
      {
        e.printStackTrace();
        return ReturnCode.FAIL_CONVERTING_TO_ARRAY;
      }

      try
      {
        driverOutputStream.write(buffer);
      }
      catch (Exception e)
      {
        e.printStackTrace();
        return ReturnCode.FAIL_WRITING_TO_BLUETOOTH;
      }
      return ReturnCode.SUCCESS;
    }

    /**
     * Put data to Bluetooth output stream and a '\n' is automatically added.
     * The maximum length of the message is 
     * {@value API.ADK.ConstantList#MAXIMUM_MESSAGE_ARRAY_LENGTH}.
     * This method is used to transmit a message.
     * @param data Input: An array of message.
     * @param length  Input: The length of the message array.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#MESSAGE_TOO_LONG}, or 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH}.
     */
    private ReturnCode writeArrayToBluetooth(byte[] data, int length)
    {
      // Check the validity of the input.
      if (data == null)
      {
        return ReturnCode.ARRAY_NOT_VALID;
      }
      if ((length >= MAXIMUM_MESSAGE_ARRAY_LENGTH) || (length < 0))
      {
        return ReturnCode.MESSAGE_TOO_LONG;
      }
      // Add '\n'.
      data[length] = 0xA;
      try
      {
        driverOutputStream.write(data, 0, (length + 1));
      }
      catch (Exception e)
      {
        e.printStackTrace();
        return ReturnCode.FAIL_WRITING_TO_BLUETOOTH;
      }
      return ReturnCode.SUCCESS;
    }

    /**
     * Send a command and wait for a response.
     * In case of multiple line responses, more waiting time is handled by 
     * each calling methods.
     * @param data            Input: String of command (without a '\n').
     * @param waitForResponse Input: Maximum time needed to wait for the 
     *   response (in {@value API.ADK.ConstantList#SLEEP_TIME}ms unit).
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    private ReturnCode sendAndReceiveCommand(String data, int waitForResponse)
    {
      // Check the validity of the input.
      if (data == null)
      {
        return ReturnCode.STRING_NOT_VALID;
      }

      // empty the response buffer.
      respBuffer.resetResponseBuffer();

      returnCode = writeStringToBluetooth(data);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Wait for any response and return immediately.
      // In case of multiple line responses, it is handled by each
      // calling methods.
      timeOutCounter = 0;
      while(respBuffer.responseFlag == false)
      {
        timeOutCounter++;
        if ((timeOutCounter >= waitForResponse) || (timeOutCounter < 0))
        {
          return ReturnCode.WAITING_FOR_RESPONSE_TIMEOUT;
        }
        try
        {
          Thread.sleep(SLEEP_TIME);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.EXCEPTION_SLEEP_THREAD;
        }
      }
      // Check the content of the buffer
      if (respBuffer.bufferIndex == 0)
      {
        return ReturnCode.NO_RESPONSE;
      }
      return ReturnCode.SUCCESS;
    }

    /**
     * The transmit thread for transmitting bulk CAN message. This thread is 
     * used internally. It is started automatically after successfully 
     * connecting to the device in {@link Driver.CANDevice#connectDevice()}.
     * @author hroesdiyono
     */
    private class TransmitBulkMessage extends Thread
    {
      /** Run the thread. */
      public void run()
      {
        Date timeValue;
        long timeStamp1, timeStamp2, timeDifference;

        transmitThreadFlag = ReturnCode.THREAD_RUNNING;

        timeValue = new Date();
        timeStamp1 = timeValue.getTime();
        while(true)
        {
          try
          {
            Thread.sleep(0, 500000);
          }
          catch (InterruptedException e2)
          {
            e2.printStackTrace();
            break;
          }
          timeValue = new Date();
          timeStamp2 = timeValue.getTime();
          timeDifference = timeStamp2 - timeStamp1;
          if ((bulkBufferIndex >= bulkBufferFull) || (timeDifference >= 5))
          {
            if(bulkBufferIndex == 0)
            {
            }
            else
            {
              try
              {
                bulkBufferFlag.acquire();
              }
              catch (InterruptedException e1)
              {
                e1.printStackTrace();
                break;
              }
              try
              {
                driverOutputStream.write(bulkBuffer, 0, bulkBufferIndex);
              }
              catch (IOException e)
              {
                e.printStackTrace();
                break;
              }
              bulkBufferIndex = 0;
              try
              {
                bulkBufferFlag.release();
              }
              catch (Exception e)
              {
                e.printStackTrace();
                break;
              }
            }
            timeValue = new Date();
            timeStamp1 = timeValue.getTime();
          }
        }
        transmitThreadFlag = ReturnCode.THREAD_STOPPED;
      }
    }

    /**
     * The receive thread for receiving all Bluetooth data. This thread is 
     * used internally. It is started automatically after successfully 
     * connecting to the device in {@link Driver.CANDevice#connectDevice()}.
     * @author hroesdiyono
     */
    private class ReceiveData extends Thread
    {
      /** Run the thread. */
      public void run()
      {
        byte[] buffer = new byte[BYTE_BUFFER_LENGTH];
        int i, length, offset;
        String tempString = null;
        MessageStructure tempMessage = new MessageStructure();
        tempMessage.data = new int[8];
        int tempMessageID, tempData;
        byte tempFrameFormat;
        byte tempFrameType;
        byte tempMessageLength;

        // Keep listening to the InputStream while connected
        offset = 0;
        receiveThreadFlag = ReturnCode.THREAD_RUNNING;
        while (true)
        {
          // Reset the length and try to read from the InputStream.
          length = 0;
          try
          {
            // If there is unparsed data, do not overwrite it.
            // The length of the unparsed data is the offset.
            length = driverInputStream.read(buffer, offset,
                (BYTE_BUFFER_LENGTH - offset));
          }
          catch (Exception e)
          {
            // Error reading from the InputStream.
            // The connection is lost or the Bluetooth buffer is overflowed.
            e.printStackTrace();
            // stop the receive thread.
            break;
          }

          if (length <= 0)
          {
              continue;  // No data.
          }

          if (offset != 0)
          {
            // The returned length does not include the offset, add it.
            length = length + offset;
            // Reset the offset.
            offset = 0;
          }

          i = 0;
          while (i < length)
          {
            // Check if the beginning of the buffer is a response or an error.
            if ((buffer[i] == (byte) 'I') || (buffer[i] == (byte) 'E'))
            {
              int startIndex = i;

              while((i < length) && (buffer[i] != 13) && (buffer[i] != 10))
              {
                // Increment i until end of the buffer or find "\n" or "\r".
                i++;
              }

              if ((i >= length) && (buffer[i-1] != 13) && (buffer[i-1] != 10))
              {
                // At the end of the buffer, "\n" or "\r" is not found, it is
                // an incomplete response. Set the offset and copy the remaining
                // data to the beginning of the buffer.
                offset = i - startIndex;
                for (int l = 0; l < offset; l++)
                {
                  buffer[l] = buffer[startIndex + l];
                }
                break;
              }

              // The length of the current response or error.
              int indexLength = i - startIndex;

              // Some automatic error response sent by the CANblue should be
              // ignored. Use "CAN_INFO" command to read the status of the 
              // controller. "E 8X XX..", check the first and third characters.
              if ((buffer[startIndex] == 'E')
                  && (buffer[startIndex + 2] == '8'))
              {
                // Do nothing.
              }
              else if ((versionNeeded == false) && (buffer[startIndex] == 'I') 
                  && (buffer[startIndex + 2] == 'C') &&
                  (buffer[startIndex + 3] == 'A') &&
                  (buffer[startIndex + 4] == 'N') &&
                  (buffer[startIndex + 5] == 'b')){
                  // "I CANblue Generic - Bridge v1.901".
                  // The device information is currently not needed, throw them.
                  versionNeeded = false;
              }
              else
              {
                // Response information or other error messages.
                if (respBuffer.bufferIndex >= respBuffer.bufferLength)
                {
                  // If the buffer is full, ignore the rest of the response.
                  continue;
                }
                tempString = ASCIIArrayToString(buffer, startIndex,
                    indexLength);
                if (tempString == null)
                {
                  continue;  // Invalid data.
                }
                // Fill the buffer, increase the index, and set the flag.
                respBuffer.buffer[respBuffer.bufferIndex] = tempString;
                respBuffer.bufferIndex++;
                respBuffer.responseFlag = true;
              }
            }
            // Check if the beginning of the buffer is a message.
            else if (buffer[i] == (byte) 'M')
            {
              // Store the current time.
              Date globalDate = new Date();

              int startIndex = i;
              while((i < length) && (buffer[i] != 13) && (buffer[i] != 10))
              {
                // Increment i until end of the buffer or find "\n" or "\r".
                i++;
              }

              if ((i >= length) && (buffer[i-1] != 13) && (buffer[i-1] != 10))
              {
                // At the end of the buffer, "\n" or "\r" is not found, it is
                // an incomplete message. Set the offset and copy the remaining
                // data to the beginning of the buffer.
                offset = i - startIndex;
                for (int l = 0; l < offset; l++)
                {
                  buffer[l] = buffer[startIndex + l];
                }
                continue;
              }

              // The length of the current message.
              int indexLength = i - startIndex;

              // Parse the message and put it into temporary buffer.
              // Time stamp.
              tempMessage.timeStamp = globalDate.getTime();
              // Frame format.
              if (buffer[startIndex + 2] == 'E')
              {
                tempMessage.frameFormat = EXTENDED_FRAME;
              }
              else if (buffer[startIndex + 2] == 'S')
              {
                tempMessage.frameFormat = STANDARD_FRAME;
              }
              else
              {
                continue;  // Invalid message.
              }

              // Data length. Check if the data length is between 0-8.
              if ((buffer[startIndex + 4] < '0')
                  || (buffer[startIndex + 4] > '8'))
              {
                continue;  // Invalid message.
              }
              else
              {
                // Fill with number, not ASCII format;
                tempMessage.dataLength = (byte) (buffer[startIndex + 4] - '0');
              }

              // Frame type and length of data array.
              if (buffer[startIndex + 3] == 'D')
              {
                tempMessage.frameType = DATA_FRAME;
              }
              else if (buffer[startIndex + 3] == 'R')
              {
                tempMessage.frameType = REMOTE_FRAME;
              }
              else
              {
                continue;  // Invalid message.
              }

              // Find the Message ID.
              int j;
              for (j = startIndex + 6; j < startIndex + indexLength; j++)
              {
                // Find the space between the message ID and data. If there is
                // no space, it means that the rest of the buffer are messageID.
                if (buffer[j] == ' ')
                {
                  break;
                }
              }

              // Convert and copy the Message ID.
              tempMessageID = HexASCIIArrayToInt(buffer, startIndex + 6, 
                  j - startIndex - 6);
              if (tempMessageID == -1)
              {
                continue;  // Invalid message ID.
              }
              tempMessage.messageID = tempMessageID;

              // If there are data, convert and copy them.
              if ((tempMessage.dataLength != 0)
                  && (j != startIndex + indexLength))
              {
                for (int k = 0; k < tempMessage.dataLength; k++)
                {
                  tempData = HexASCIIArrayToInt(buffer, (j + 1) + (3 * k), 2);
                  if (tempData == -1)
                  {
                    continue;  // Invalid data.
                  }
                  tempMessage.data[k] = tempData;
                }
              }

              // Apply the filtering process.
              applyFilteringMessage(tempMessage);
            }
            else if (buffer[i] == (byte) 'X')
            {
              int startIndex = i;

              // The minimum length of the binary message is 4, check it first.
              if (i + 4 > length)
              {
                  offset = length - startIndex;
                  for (int l = 0; l < offset; l++)
                  {
                    buffer[l] = buffer[startIndex + l];
                  }
                  i = length;
                  continue;
              }

              // Store the current time.
              Date globalDate = new Date();
              tempMessage.timeStamp = globalDate.getTime();

              // Check whether the frame info is valid and check its content.
              i++; // Increase the index.
              if((buffer[i] & 0x30) != 0x00)
              {
                continue; // Invalid message.
              }
              tempFrameFormat = (byte) (buffer[i] & 0x80);
              tempFrameType = (byte) (buffer[i] & 0x40);
              tempMessage.dataLength = (byte) (buffer[i] & 0x0F);
              if (tempMessage.dataLength > 8)
              {
                continue; // Invalid data length.
              }
              tempMessageLength = 0;
              if (tempFrameFormat == 0)
              {
                tempMessageLength += 2; // 2bytes ID.
              }
              else
              {
                tempMessageLength += 4; // 4bytes ID.
              }
              if (tempFrameType == 0)
              {
                tempMessageLength += tempMessage.dataLength; // Data Length.
              }
              // Check whether the message is complete.
              if (i + tempMessageLength >= length)
              {
                  offset = length - startIndex;
                  for (int l = 0; l < offset; l++)
                  {
                    buffer[l] = buffer[startIndex + l];
                  }
                  i = length;
                  continue;
              }

              if (tempFrameFormat == 0)
              {
                tempMessage.frameFormat = STANDARD_FRAME;
                i = i + 2; // Jump the index to the end of the message ID byte.
                // Check the validity of the STD messageID.
                // Should not be bigger than 0x7FF.
                if (buffer[i-1] > 0x7)
                {
                  continue; // Invalid message ID.
                }
                tempMessage.messageID = (int) (((buffer[i - 1] & 0xFF) * Math.pow(16,2))
                    + (buffer[i] & 0xFF));
              }
              else
              {
                tempMessage.frameFormat = EXTENDED_FRAME;
                i = i + 4; // Jump the index to the end of the message ID byte.
                // Check the validity of the EXT messageID.
                // Should not be bigger than 0x1FFFFFFF.
                if (buffer[i-3] > 0x1F)
                {
                  continue; // Invalid message ID.
                }
                tempMessage.messageID = (int) (((buffer[i - 3] & 0xFF) * Math.pow(16,6))
                    + ((buffer[i - 2] & 0xFF) * Math.pow(16,4))
                    + ((buffer[i - 1] & 0xFF) * Math.pow(16,2))
                    + (buffer[i] & 0xFF));
              }

              // Increase the index to the beginning of the data or 
              // invalid index in case of remote frame.
              i++;
              if (tempFrameType == 0)
              {
                tempMessage.frameType = DATA_FRAME;
                for (byte j = 0; j < tempMessage.dataLength; j++)
                {
                  tempMessage.data[j] = (buffer[i++] & 0xFF);
                }
              }
              else
              {
                tempMessage.frameType = REMOTE_FRAME;
              }

              // Apply the filtering process.
              applyFilteringMessage(tempMessage);
              continue; // No need to check for '\n' or '\r'.
            }
            else
            {
              i++; // Throw away unknown data.
            }

            while((buffer[i] == 13) || (buffer[i] == 10))
            {
              // Check whether the buffer contains \r or \n, and throw them.
              i++;
              if (i < length)
              {
                continue;
              }
              else
              {
                // If the i is at the end of the buffer
                break;
              }
            }
          }
        }
        receiveThreadFlag = ReturnCode.THREAD_STOPPED;
      }
    }
    // End of Bluetooth specific methods --------------------------------------

    // Additional methods used internally -------------------------------------
    /**
     * Filter the received message and put it into the receive buffer of 
     * each message channel.
     * @param inputMessage Input: Message to be filtered.
     */
    private void applyFilteringMessage (MessageStructure inputMessage)
    {
      // Check the validity of the parameter.
      if (inputMessage == null)
      {
        return; // Invalid input.
      }

      // Since the number of Controller in CANblue / CANblue II is the
      // same as the number of Device, therefore the index used for
      // numberOfMessageChannel is the same as the deviceIndex, so
      // listIndex is used here.
      if (intDeviceList.receiveFilterType[listIndex] == HARDWARE_FILTER)
      {
        // Filtering is done in the hardware. Put the message directly
        // to the receive buffer of each message channel.
        for (int i = 0; i < intDeviceList.
            numberOfMessageChannel[listIndex]; i++)
        {
          returnCode = intCANMessage[i].intReceiveBuffer.queuePut(inputMessage);
        }
      }
      else if (intDeviceList.receiveFilterType[listIndex] == SOFTWARE_FILTER)
      {
        // Check for the filter status of each message channel.
        for (int i = 0; i < intDeviceList.
            numberOfMessageChannel[listIndex]; i++)
        {
          if ((inputMessage.frameFormat == STANDARD_FRAME) &&
              (intCANMessage[i].stdReceiveFilter.filterStatus == true))
          {
            // If the filter is empty, do nothing.
            if (intCANMessage[i].stdReceiveFilter.numberOfFilter == 0)
            {
              continue;
            }

            // If the STD filter is not empty, check whether the ID and the frame type is listed.
            int l;
            for (l = 0; l < intCANMessage[i].stdReceiveFilter.numberOfFilter;
                l++)
            {
              // Since the frameType of the FilterlList contains
              // both Data and Remote frames informations, it
              // should be masked before the comparison.
              if (intCANMessage[i].stdReceiveFilter.messageID[l] ==
                  inputMessage.messageID)
              {
                if ((intCANMessage[i].stdReceiveFilter.frameType[l]
                    & inputMessage.frameType) == inputMessage.frameType)
                {
                  break;  // Found the same ID and Frame type.
                }
              }
            }

            if (l != intCANMessage[i].stdReceiveFilter.numberOfFilter)
            {
              // The ID is listed, put it into the receive buffer.
              returnCode =
                  intCANMessage[i].intReceiveBuffer.queuePut(inputMessage);
            }
            else
            {
              // If the ID is not listed, do not put it into the receive buffer.
            	continue;
            }
          }
          else if ((inputMessage.frameFormat == EXTENDED_FRAME) &&
              (intCANMessage[i].extReceiveFilter.filterStatus == true))
          {
            // If the filter is empty, do nothing.
            if (intCANMessage[i].extReceiveFilter.numberOfFilter == 0)
            {
              continue;
            }
            // If the EXT filter is not empty, check whether the ID and the frame type is listed.
            int l;
            for (l = 0; l < intCANMessage[i].extReceiveFilter.numberOfFilter;
                l++)
            {
              // Since the frameType of the FilterlList contains
              // both Data and Remote frames informations, it
              // should be masked before the comparison.
              if (intCANMessage[i].extReceiveFilter.messageID[l] ==
                  inputMessage.messageID)
              {
                if ((intCANMessage[i].extReceiveFilter.frameType[l]
                  & inputMessage.frameType) == inputMessage.frameType)
                {
                  break;  // Found the same ID and Frame type.
                }
              }
            }
            if (l != intCANMessage[i].extReceiveFilter.
                numberOfFilter)
            {
              // The ID is listed, put it into the receive buffer.
              returnCode =
                  intCANMessage[i].intReceiveBuffer.queuePut(inputMessage);
            }
            else
            {
              // If the ID is not listed, do not put it into the receive buffer.
            	continue;
            }
          }
          else
          {
            // Either STD and EXT message without filter, put
            // directly into the receive buffer.
            returnCode = intCANMessage[i].intReceiveBuffer.
                queuePut(inputMessage);
          }
        }
      }
    }

    /**
     * This method should only be used internally for converting
     * the value of MessageID and Data[] with the maximum possible
     * value of 0x1FFF FFFF or 8 characters. For example: ‘7’, ‘F’, ‘F’ to 0x7FF.
     * @param inputArray  Input: An ASCII array.
     * @param startIndex  Input: Start index of the array. 
     * @param inputLength Input: Length of the data.
     * @return The value of the conversion result or -1 for unsupported value.
     */
    private int HexASCIIArrayToInt(byte[] inputArray, int startIndex, 
    		int inputLength)
    {
      // Check the validity of the input.
      if (inputArray == null)
      {
        return -1;
      }

      if ((inputArray[startIndex] > '8') && (inputLength == 8))
      {
        // Since the return value is int, it would not be able to return more
        // than 0x7FFF FFFF, so the input of this method should be limited.
        return -1;
      }
      else if (inputLength > 8)
      {
        // More than 8characters.
        return -1;
      }

      int temporaryValue = 0;
      for (int e = 0; e < inputLength; e++)
      {
        if ((inputArray[startIndex + e] >= '0') &&
            (inputArray[startIndex + e] <= '9'))
        {
          temporaryValue += ((inputArray[startIndex + e] - '0') *
              (Math.pow(16, inputLength - 1 - e)));
        }
        else if ((inputArray[startIndex + e] >= 'A') &&
            (inputArray[startIndex + e] <= 'F'))
        {
          temporaryValue += ((inputArray[startIndex + e] - 'A' + 10) *
              (Math.pow(16, inputLength - 1 - e)));
        }
        else if ((inputArray[startIndex + e] >= 'a') &&
            (inputArray[startIndex + e] <= 'f'))
        {
          temporaryValue += ((inputArray[startIndex + e] - 'a' + 10) *
              (Math.pow(16, inputLength - 1 - e)));
        }
        else
        {
          return -1;  // Unsupported value.
        }
      }
      return temporaryValue;
    }

    /**
     * This method should only be used internally for converting 
     * an integer (message ID or data) to an ASCII array, with the maximum 
     * input of 0x20000000. For example: 0x12 to '1' and '2'.
     * @param inputValue Input: An integer value.
     * @return An array of Hex ASCII or null if it is out of range.
     */
    private byte[] intToHexASCIIArray (int inputValue)
    {
      byte[] outputValue = null;
      if (inputValue >= 0x20000000)
      {
        // The maximum extended message ID.
        return outputValue;
      }

      for (int i = 1; i < 9; i++)
      {
        // The maximum value contains 8nibbles / 4bytes.
        if (inputValue < Math.pow(16, i))
        {
          outputValue = new byte[i];
          break;
        }
      }

      for (int i = 0; i < outputValue.length; i++)
      {
        outputValue[i] = (byte) (0x0F &
            (inputValue >> (4 * (outputValue.length - i - 1))));
      }

      for (int i = 0; i < outputValue.length; i++)
      {
        if (outputValue[i] < 0xA)
        {
          outputValue[i] += '0';
        }
        else
        {
          outputValue[i] += 'A' - 10;
        }
      }
      return outputValue;
    }

    /**
     * This method should only be used internally for converting 
     * an ASCII array to a String. For example: '1' and '2' to "12".
     * @param inputArray  Input: An ASCII array.
     * @param startIndex  Input: Start index of the array. 
     * @param inputLength Input: Length of the data.
     * @return A string or null if the conversion fails.
     */
    private String ASCIIArrayToString (byte[] inputArray, int startIndex,
        int inputLength)
    {
    	
    	
      // Check the validity of the input.
      if (inputArray == null)
      {
        return null;
      }

      char[] tempCharBuffer = new char[inputLength];
      String tempString;
      for (int j = 0; j < inputLength; j++)
      {
        tempCharBuffer[j] = (char) inputArray[startIndex + j];
      }
      try
      {
        tempString = String.copyValueOf(tempCharBuffer);
      }
      catch (Exception e)
      {
        e.printStackTrace();
        return null;
      }
      return tempString;
    }

    /**
     * Resize an array object, including int or String.
     * @param oldArray Input: The old object array.
     * @param newSize  Input: The new array size.
     * @return The new object array.
     */
    private Object resizeArray (Object oldArray, int newSize)
    {
      // Check the validity of the input.
      if (oldArray == null)
      {
        return ReturnCode.OBJECT_NOT_VALID;
      }

      int oldSize = Array.getLength(oldArray);
      Class<?> elementType = oldArray.getClass().getComponentType();
      Object newArray = java.lang.reflect.Array.newInstance(
          elementType,newSize);
      int preserveLength = Math.min(oldSize, newSize);
      if (preserveLength > 0)
      {
        System.arraycopy (oldArray, 0, newArray, 0, preserveLength);
      }
      return newArray; 
    }
    // End of additional methods ------------------------------------------

    // CANblue specific methods -------------------------------------------
    /**
     * Read the Firmware version of the CANblue device.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @param deviceInformation Output: The information from the device, 
     *     including version, protocol and hardware number information.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH}, 
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode readCANblueVersion(DeviceInformation deviceInformation)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the parameter.
      if (deviceInformation == null)
      {
        return ReturnCode.DEVICEINFORMATION_OBJECT_NOT_VALID;
      }

      versionNeeded = true;

      String command = "D VERSION";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
    	  versionNeeded = false;
        return returnCode;
      }

      // Check the content of the response.
      for (byte i = 0; i < respBuffer.bufferIndex; i++)
      {
        try
        {
          foundIndex = respBuffer.buffer[i].indexOf("CANblue Generic");
        }
        catch (Exception e)
        {
        	versionNeeded = false;
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          // Take the version information. 
          try
          {
            deviceInformation.firmwareVersion =
                respBuffer.buffer[i].substring (foundIndex);
          }
          catch (Exception e)
          {
            deviceInformation.firmwareVersion = null;
            versionNeeded = false;
            return ReturnCode.INVALID_RESPONSE;
          }
          break;
        }
      }
      if (foundIndex == -1)
      {
    	  versionNeeded = false;
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
    	  versionNeeded = false;
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Read the protocol version of the CANblue device.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @param deviceInformation Output: The information from the device, 
     *     including version, protocol and hardware number information.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode readCANblueProtocol(DeviceInformation deviceInformation)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the parameter.
      if (deviceInformation == null)
      {
        return ReturnCode.DEVICEINFORMATION_OBJECT_NOT_VALID;
      }

      String command = "D PROTOCOL";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf(
                  "ASCII Extended Protocol");
        }
        catch (Exception e)
        {
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          try
          {
            // Take the protocol version.
            deviceInformation.protocolVersion =
                respBuffer.buffer[index].substring (foundIndex);
          }
          catch (Exception e)
          {
            deviceInformation.protocolVersion = null;
            return ReturnCode.INVALID_RESPONSE;
          }
          break;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Read the hardware number of the CANblue device. 
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * Only work for CANblue II, CANblue only returns "I OK: IDENTIFY". 
     * So the hardware number for CANblue is "IDENTIFY".
     * @param deviceInformation Output: The information from the device, 
     *     including version, protocol and hardware number information.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#FAIL_PARSING_HARDWARE_NUMBER}, 
     *         {@link ReturnCode#UNKNOWN_DEVICE}, 
     *         {@link ReturnCode#NO_VALID_HARDWARE_NUMBER}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode readCANblueHardwareNumber(
        DeviceInformation deviceInformation)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the parameter.
      if (deviceInformation == null)
      {
        return ReturnCode.DEVICEINFORMATION_OBJECT_NOT_VALID;
      }

      String command = "D IDENTIFY";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // The response consist of more than one line, wait for more response.
      // The last line of the response should be "I OK: IDENTIFY". 
      index = 0;
      timeOutCounter = 0;
      while (true)
      {
        if (index < respBuffer.bufferIndex)
        {
          try
          {
            foundIndex = respBuffer.buffer[index].indexOf("IDENTIFY");
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.FAIL_SEARCHING_STRING;
          }
          if (foundIndex != -1)
          {
            break;  // Find the string.
          }
          // Increment the index and reset the timeout counter.
          index++;
          timeOutCounter = 0;
        }
        else
        {
          // Increment the counter while waiting for more response.
          timeOutCounter++;
          if (timeOutCounter >= WAITING_FOR_RESPONSE)
          {
            return ReturnCode.WAITING_FOR_RESPONSE_TIMEOUT;
          }
          try
          {
            Thread.sleep(SLEEP_TIME);
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.EXCEPTION_SLEEP_THREAD;
          }
        }
      }

      // Check the content of the response.
      // Check whether the device is CANblue II or CANblue.
      if (intDeviceList.deviceType[listIndex] == DeviceType.CANBLUE_II)
      {
        // Response for CANblue II
        // Take the hardware number from a string before
        // "I OK: IDENTIFY" line. The expected response:
        // "I HW-Number: HW123456", take only "HW123456".
        try
        {
          foundIndex = respBuffer.buffer[index - 1].indexOf("HW-Number");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex == -1)
        {
          return ReturnCode.NO_VALID_HARDWARE_NUMBER;
        }

        try
        {
          deviceInformation.hardwareNumber =
              respBuffer.buffer[index - 1].substring (13);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          deviceInformation.hardwareNumber = null;
          return ReturnCode.FAIL_PARSING_HARDWARE_NUMBER;
        }
        return ReturnCode.SUCCESS;
      }
      else if (intDeviceList.deviceType[listIndex] == DeviceType.CANBLUE)
      {
        // Response for CANblue.
        try
        {
          // Return the word "IDENTIFY".
          deviceInformation.hardwareNumber =
              respBuffer.buffer[index].substring (foundIndex);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          deviceInformation.hardwareNumber = null;
          return ReturnCode.FAIL_PARSING_HARDWARE_NUMBER;
        }
        return ReturnCode.SUCCESS;
      }
      else
      {
        return ReturnCode.UNKNOWN_DEVICE;
      }
    }

    /**
     * Read the configuration of the CANblue.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @param config Output: The configuration of the CANblue device.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode readCANblueConfiguration(CANblueConfiguration config)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the parameter.
      if (config == null)
      {
        return ReturnCode.DEVICEINFORMATION_OBJECT_NOT_VALID;
      }

      String command = "D CONFIG SHOW";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // The first line of the response is "I BT0=...", and the last line is 
      // "OK: CONFIG SHOW". The first "OK: CONFIG SHOW" in the response for the 
      // CANblue is ignored, because it is not there in CANblue II.
      int lineIndex1 = -1, lineIndex2 = -1;
      index = 0;
      timeOutCounter = 0;
      while (true)
      {
        if (index < respBuffer.bufferIndex)
        {
          try
          {
            foundIndex = respBuffer.buffer[index].indexOf("BT0");
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.FAIL_SEARCHING_STRING;
          }

          if (foundIndex != -1)
          {
            lineIndex1 = index;
            index++;
            break;
          }

          // Increment the index and reset the timeout counter.
          index++;
          timeOutCounter = 0;
        }
        else
        {
          // Increment the counter while waiting for more response.
          timeOutCounter++;
          if (timeOutCounter >= WAITING_FOR_RESPONSE)
          {
            return ReturnCode.WAITING_FOR_RESPONSE_TIMEOUT;
          }
          try
          {
            Thread.sleep(SLEEP_TIME);
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.EXCEPTION_SLEEP_THREAD;
          }
        }
      }
      // Wait for the last line.
      timeOutCounter = 0;
      while (true)
      {
        if (index < respBuffer.bufferIndex)
        {
          try
          {
            // The configuration is too long, got "Can' show more" line.
            foundIndex = respBuffer.buffer[index].indexOf("show more");
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.FAIL_SEARCHING_STRING;
          }
          if (foundIndex != -1)
          {
            return ReturnCode.READ_CONFIGURATION_CANT_SHOW_MORE;
          }

          try
          {
            foundIndex = respBuffer.buffer[index].indexOf("CONFIG SHOW");
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.FAIL_SEARCHING_STRING;
          }

          if (foundIndex != -1)
          {
            lineIndex2 = index;
            break;
          }
          // Increment the index and reset the timeout counter.
          index++;
          timeOutCounter = 0;
        }
        else
        {
          // Increment the counter while waiting for more response.
          timeOutCounter++;
          if (timeOutCounter >= WAITING_FOR_RESPONSE)
          {
            return ReturnCode.WAITING_FOR_RESPONSE_TIMEOUT;
          }
          try
          {
            Thread.sleep(SLEEP_TIME);
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.EXCEPTION_SLEEP_THREAD;
          }
        }
      }

      if ((lineIndex1 == -1) || (lineIndex2 == -1))
      {
        // Could not get valid first and last line.
        return ReturnCode.INVALID_RESPONSE;
      }

      // Start parsing the data.
      // Initialize some of the variables.
      config.MACMasterCount = 0;
      config.MACSlaveCount = 0;
      for (index = (byte) (lineIndex1); index < lineIndex2; index++)
      {
        // Find the Baudrate string.
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("BT0=");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          try
          {
            // Fill the config with the Baudrate string.
            // Example expected string: "BT0=0, BT1=14 (1000 kbaud)".
            config.baudrate = respBuffer.buffer[index].substring (foundIndex);
          }
          catch (Exception e)
          {
            e.printStackTrace();
            config.baudrate = null;
          }
          // Increase the index to the next response for a faster parsing.
          index++;
        }

        // Find the Bus Coupling string.
        // Example expected string: "Bus coupling: HIGH".
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("Bus coupling:");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          foundIndex = respBuffer.buffer[index].indexOf("LOW");
          if (foundIndex != -1)
          {
            // Fill it with Low Bus Coupling.
            config.busCoupling = BusCouplingStatus.BUSCOUPLING_LOW;
          }
          else
          {
            foundIndex = respBuffer.buffer[index].indexOf("HIGH");
            if (foundIndex != -1)
            {
              // Fill it with High Bus Coupling.
              config.busCoupling = BusCouplingStatus.BUSCOUPLING_HIGH;
            }
            else
            {
              // There must be an error either in parsing 
              // or from the device if this value is read.
              config.busCoupling = BusCouplingStatus.BUSCOUPLING_UNKNOWN;
            }
          }
          // Increase the index to the next response for a faster parsing.
          index++;
        }

        // Find the Autostart string.
        // Example expected string: "Autostart: ON".
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("Autostart:");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          foundIndex = respBuffer.buffer[index].indexOf("OFF");
          if (foundIndex != -1)
          {
            // Fill it with Autostart off.
            config.autostart = AutostartStatus.AUTOSTART_OFF;
          }
          else
          {
            foundIndex = respBuffer.buffer[index].indexOf("ON");
            if (foundIndex != -1)
            {
              // Fill it with Autostart on.
              config.autostart = AutostartStatus.AUTOSTART_ON;
            }
            else
            {
              // There must be an error either in parsing 
              // or from the device if this value is read.
              config.autostart = AutostartStatus.AUTOSTART_UNKNOWN;
            }
          }
          // Increase the index to the next response for a faster parsing.
          index++;
        }

        // Find the MAC List, only for CANblue, not used by CANblue II.
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("MAC-List:");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          // Find "MAC count" on the next line after "MAC-List".
          // Example expected string: "MAC count: 0".
          index++;
          try
          {
            foundIndex = respBuffer.buffer[index].indexOf("MAC count:");
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.FAIL_SEARCHING_STRING;
          }
          if (foundIndex != -1)
          {
            // Convert the number of MAC Count.
            try
            {
              config.MACCount = Integer.valueOf(
                  respBuffer.buffer[index].substring (13));
            }
            catch (Exception e)
            {
              e.printStackTrace();
              // If string cannot be parsed as an integer value.
              config.MACCount = 0;
              config.MACList = null;
            }
            if (config.MACCount == 0)
            {
              config.MACList = null;
            }
            else
            {
              // Make an array as big as the MAC Count and take
              // the MAC list below this line.
              config.MACList = new String[config.MACCount];
              int MACListIndex = 0;
              while (MACListIndex < config.MACCount)
              {
                index++;
                try
                {
                  config.MACList[MACListIndex] =
                      respBuffer.buffer[index].substring (10);
                }
                catch (Exception e)
                {
                  e.printStackTrace();
                  config.MACList[MACListIndex] = null;
                }
                MACListIndex++;
              }
            }
          }
          // Increase the index to the next response for a faster parsing.
          index++;
        }

        // Find the STD filter strings.
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("STD filter list:");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          // From the next line after "STD filter list:", keep increasing the
          // index until "STD filter enabled" or "STD filter disabled" is found.
          index++;
          int startFilterIndex = index;
          while (index < lineIndex2)
          {
            try
            {
              foundIndex = respBuffer.buffer[index].indexOf(
                  "STD filter enabled");
            }
            catch (Exception e)
            {
              e.printStackTrace();
              return ReturnCode.FAIL_SEARCHING_STRING;
            }
            if (foundIndex != -1)
            {
              // Fill the filter status.
              config.STDFilterStatus = FilterStatus.FILTER_ENABLED;
              break;
            }
            try
            {
              foundIndex = respBuffer.buffer[index].indexOf(
                  "STD filter disabled");
            }
            catch (Exception e)
            {
              e.printStackTrace();
              return ReturnCode.FAIL_SEARCHING_STRING;
            }
            if (foundIndex != -1)
            {
              // Fill the filter status.
              config.STDFilterStatus = FilterStatus.FILTER_DISABLED;
              break;
            }
            index++;
          }
          if (startFilterIndex == index)
          {
            // Nothing in between, no filter ID list.
            config.STDFilterList = null;
            config.STDFilterCount = 0;
          }
          else
          {
            // Find some filter list, take them.
            // Example expected string "CAN Id: 1" or "CAN Id: 4, RTR bit set".
            config.STDFilterCount = index - startFilterIndex;
            config.STDFilterList = new String[config.STDFilterCount];
            for (int j = 0; j < config.STDFilterCount; j++)
            {
              try
              {
                config.STDFilterList[j] = respBuffer.
                    buffer[startFilterIndex + j].substring (10);
              }
              catch (Exception e)
              {
                e.printStackTrace();
                config.STDFilterList[j] = null;
              }
            }
          }
          // Increase the index to the next response for a faster parsing.
          index++;
        }

        // Find the STD filter strings.
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("EXT filter list:");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          // From the next line after "EXT filter list:", keep increasing the
          // index until "EXT filter enabled" or "EXT filter disabled" is found.
          index++;
          int startFilterIndex = index;
          while (index < lineIndex2)
          {
            try
            {
              foundIndex = respBuffer.buffer[index].indexOf(
                  "EXT filter enabled");
            }
            catch (Exception e)
            {
              e.printStackTrace();
              return ReturnCode.FAIL_SEARCHING_STRING;
            }
            if (foundIndex != -1)
            {
              // Fill the filter status.
              config.EXTFilterStatus = FilterStatus.FILTER_ENABLED;
              break;
            }
            try
            {
              foundIndex = respBuffer.buffer[index].indexOf(
                  "EXT filter disabled");
            }
            catch (Exception e)
            {
              e.printStackTrace();
              return ReturnCode.FAIL_SEARCHING_STRING;
            }
            if (foundIndex != -1)
            {
              // Fill the filter status.
              config.EXTFilterStatus = FilterStatus.FILTER_DISABLED;
              break;
            }
            index++;
          }
          if (startFilterIndex == index)
          {
            // Nothing in between, no filter ID list.
            config.EXTFilterList = null;
            config.EXTFilterCount = 0;
          }
          else
          {
            // Find some filter list, take them.
            // Example expected string "CAN Id: 1" or "CAN Id: 4, RTR bit set".
            config.EXTFilterCount = index - startFilterIndex;
            config.EXTFilterList = new String[config.EXTFilterCount];
            for (int j = 0; j < config.EXTFilterCount; j++)
            {
              try
              {
                config.EXTFilterList[j] = respBuffer.
                    buffer[startFilterIndex + j].substring (10);
              }
              catch (Exception e)
              {
                e.printStackTrace();
                config.EXTFilterList[j] = null;
              }
            }
          }
          // Increase the index to the next response for a faster parsing.
          index++;
        }

        // Find the MAC-Master list, only for CANblue II, not used by CANblue.
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("MAC-Master:");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          try
          {
            //Example expected string "MAC-Master: C44619F9813A
            // Can-Bluet.-form.: off, State: connected"
            config.MACMasterList[config.MACMasterCount] =
                respBuffer.buffer[index].substring (14);
          }
          catch (Exception e)
          {
            e.printStackTrace();
            config.MACMasterList[config.MACMasterCount] = null;
          }
          // It is possible to have 2 MAC-Master.
          config.MACMasterCount++;
          continue;
        }

        // Find the MAC-Slave list, only for CANblue II, not used by CANblue.
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("MAC-Slave:");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          try
          {
            //Example expected string "MAC-Slave: 001122334455
            // Can-Bluet.-form.: binary, State: disconnected".
            config.MACSlaveList[config.MACSlaveCount] =
                respBuffer.buffer[index].substring (13);
          }
          catch (Exception e)
          {
            e.printStackTrace();
            config.MACSlaveList[config.MACSlaveCount] = null;
          }
          // Currently it is only possible to have 1 MAC-Slave.
          config.MACSlaveCount++;
          // Increase the index to the next response for a faster parsing.
          index++;
        }

        // Find the TX-Buff string.
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("TX-Buff. timeout:");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          try
          {
            config.TXBuffTimeout = respBuffer.buffer[index].substring (20);
          }
          catch (Exception e)
          {
            e.printStackTrace();
            config.TXBuffTimeout = null;
          }
        }
      }
      return ReturnCode.SUCCESS;
    }

    /**
     * Load the configuration of the CANblue.
     * This method is not used by the {@link API_ADK}.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#NO_VALID_CONFIG}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode loadCANblueConfiguration()
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      String command = "D CONFIG LOAD";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          // Search for the expected response.
          foundIndex = respBuffer.buffer[index].indexOf("CONFIG LOAD");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }

        try
        {
          // Search for the expected error response.
          foundIndex = respBuffer.buffer[index].indexOf("No valid config");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.NO_VALID_CONFIG;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Save the configuration of the CANblue.
     * This method is not used by the {@link API_ADK}.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#FAIL_SAVING_CONFIG}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode saveCANblueConfiguration()
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      String command = "D CONFIG SAVE";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("CONFIG SAVE");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf(
              "Error while saving config");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.FAIL_SAVING_CONFIG;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Change the Autostart mode on and off.
     * This method is not used by the {@link API_ADK}.
     * @param autostart Input: True for on or false for off.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode setCANblueAutostart(boolean autostart)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the input.
      String autoStartString;
      if (autostart == true)
      {
        autoStartString = "ON";
      }
      else
      {
        autoStartString = "OFF";
      }

      String command = "C AUTOSTART " + autoStartString;
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("AUTOSTART");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Use the default setting of the CANblue configuration.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode setCANblueDefaultSetting()
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      String command = "D SETTINGS_DEFAULT";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("SETTINGS_DEFAULT");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Reset the CAN controller of the CANblue.
     * This method is not used by the {@link API_ADK}.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode resetCANblueController()
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      String command = "C CAN_RESET";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("CAN_RESET");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Add a MAC address to the MAC list for the bridge mode. 
     * This method is not used by the {@link API_ADK}.
     * @param MAC_ID Input: String of MAC ID. The expected formats are either 
     *     "11:22:33:44:55:66" or "112233445566".
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#INVALID_MAC_ID}, 
     *         {@link ReturnCode#MAC_LIST_FULL}, 
     *         {@link ReturnCode#MAC_ADDRESS_ALREADY_EXIST}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode addCANblueMACList(String MAC_ID)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the input.
      if (MAC_ID == null)
      {
        return ReturnCode.STRING_NOT_VALID;
      }
      String MAC_ID_String = null;
      if (MAC_ID.length() == 12)
      {
        // Example expected string "123456789012".
        MAC_ID_String = MAC_ID;
      }
      else if ((MAC_ID.length() == 17) && (MAC_ID.charAt(2) == ':'))
      {
        // Example expected string "12:34:56:78:90:12".
        for (byte i = 0; i < 6; i++)
        {
          // Take the string without ":".
          MAC_ID_String += MAC_ID.substring(i * 3, (i * 3) + 2);
        }
      }
      else
      {
        return ReturnCode.INVALID_MAC_ID;
      }

      // The parameter offTime is not used by the CANblue II anymore, so
      // CANblue also uses the default value by not sending it.
      String command = "D MAC_ADD " + MAC_ID_String;
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("MAC_ADD");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("MAC-list is full");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.MAC_LIST_FULL;
        }
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf(
              "MAC Address already exist");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.MAC_ADDRESS_ALREADY_EXIST;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Remove a MAC address from the MAC list. 
     * There is a bug in CANblue. It returns nothing is the MAC ID is not on 
     * the list.
     * This method is not used by the {@link API_ADK}.
     * @param MAC_ID Input: String of MAC ID. The expected formats are either 
     *     "11:22:33:44:55:66" or "112233445566".
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#INVALID_MAC_ID}, 
     *         {@link ReturnCode#WRONG_MAC_ADDRESS}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode removeCANblueMACList(String MAC_ID)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the input.
      if (MAC_ID == null)
      {
        return ReturnCode.STRING_NOT_VALID;
      }
      String MAC_ID_String = null;
      if (MAC_ID.length() == 12)
      {
        // Example expected string "123456789012".
        MAC_ID_String = MAC_ID;
      }
      else if ((MAC_ID.length() == 17) && (MAC_ID.charAt(2) == ':'))
      {
        // Example expected string "12:34:56:78:90:12".
        for (byte i = 0; i < 6; i++)
        {
          // Take the string without ":".
          MAC_ID_String += MAC_ID.substring(i * 3, (i * 3) + 2); 
        }
      }
      else
      {
        return ReturnCode.INVALID_MAC_ID;
      }

      String command = "D MAC_REMOVE " + MAC_ID_String;
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("MAC_REMOVE");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("Wrong MAC Address");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.WRONG_MAC_ADDRESS;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Clear the MAC list.
     * This method is not used by the {@link API_ADK}.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode clearCANblueMACList()
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      String command = "D MAC_CLEAR";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("MAC_CLEAR");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Scan for any Bluetooth device. 
     * This command is not supported by CANblue ({@link ReturnCode#COMMAND_NOT_SUPPORTED}).
     * This method is not used by the {@link API_ADK}.
     * @param deviceList Output: The list of scanned Bluetooth devices.
     * @param time       Input: Timeout for searching a device (1 - 255, 
     *     0 for default value of 10).
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#COMMAND_NOT_SUPPORTED}, 
     *         {@link ReturnCode#INVALID_TIME_SCAN}, 
     *         {@link ReturnCode#NO_DEVICE_DETECTED}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode scanCANblueMAC(MACScanDeviceList deviceList, int time)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // This command is not supported by CANblue. Return error immediately.
      if (intDeviceList.deviceType[listIndex] == DeviceType.CANBLUE)
      {
        return ReturnCode.COMMAND_NOT_SUPPORTED;
      }

      // Check the validity of the input.
      if (deviceList == null)
      {
        return ReturnCode.MACSCANDEVICELIST_OBJECT_NOT_VALID;
      }
      String timeString = "";
      if (time == 0)
      {
        time = 10; // 10s as default.
      }
      else if ((time > 255) || (time < 0))
      {
        return ReturnCode.INVALID_TIME_SCAN;
      }
      timeString += time;

      String command = "D MAC_SCAN " + timeString;
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // The first line of the response should contains "MAC-Address".
      int lineIndex1 = -1, lineIndex2 = -1;
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("MAC-Address");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          lineIndex1 = index;  // Mark the first line.
          break;
        }
      }

      // Waiting for the last line. It will takes some seconds, depends
      // on the time input.
      index = 0;
      timeOutCounter = 0;
      while (true)
      {
        if (index < respBuffer.bufferIndex)
        {
          // The expected result should be "OK: MAC_SCAN" instead
          // of "OK_ MAC_SCAN", search only for "MAC_SCAN".
          try
          {
            foundIndex = respBuffer.buffer[index].indexOf("MAC_SCAN");
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.FAIL_SEARCHING_STRING;
          }
          if (foundIndex != -1)
          {
            lineIndex2 = index;  // Mark the last line.
            break;
          }
          // Increment the index and reset the timeout counter.
          index++;
          timeOutCounter = 0;
        }
        else
        {
          // The response is not complete
          // Wait for response, until the length of the response
          // change or timeout
          timeOutCounter++;
          if (timeOutCounter >= (time * WAITING_FOR_RESPONSE))
          {
            return ReturnCode.WAITING_FOR_RESPONSE_TIMEOUT;
          }
          try
          {
            Thread.sleep(SLEEP_TIME);
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.EXCEPTION_SLEEP_THREAD;
          }
        }
      }

      // Check the content of the response.
      if ((lineIndex1 != -1) && (lineIndex2 != -1))
      {
        byte listIndex = 0;
        // Increase the first line index. If it is the same as the
        // second line, then no device detected.
        lineIndex1++;
        deviceList.numberOfDevice = (byte) (lineIndex2 - lineIndex1);
        if (deviceList.numberOfDevice == 0)
        {
          return ReturnCode.NO_DEVICE_DETECTED;
        }
        // Fill the structure with the MAC Address and the Device Name.
        deviceList.deviceMACAddress = new String[deviceList.numberOfDevice];
        deviceList.deviceName = new String[deviceList.numberOfDevice];
        for (index = lineIndex1; index < lineIndex2; index++)
        {
          try
          {
            deviceList.deviceMACAddress[listIndex] =
                respBuffer.buffer[index].substring (2,14);
          }
          catch (Exception e)
          {
            e.printStackTrace();
            deviceList.deviceMACAddress[listIndex] = null;
          }
          try
          {
            deviceList.deviceName[listIndex] =
                respBuffer.buffer[index].substring (16);
          }
          catch (Exception e)
          {
            e.printStackTrace();
            deviceList.deviceName[listIndex] = null;
          }
          listIndex++;
        }
        return ReturnCode.SUCCESS;
      }
      else
      {
        return ReturnCode.INVALID_RESPONSE;
      }
    }

    /**
     * Set the Timeout parameter of CANblue II Send Buffer.
     * This command is not supported by CANblue ({@link ReturnCode#COMMAND_NOT_SUPPORTED}).
     * This method is not used by the {@link API_ADK}.
     * @param timeout Input: Timeout value for the send buffer (0 - 1000).
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#COMMAND_NOT_SUPPORTED}, 
     *         {@link ReturnCode#INVALID_TIMEOUT_VALUE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode setCANblueTimeout(int timeout)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // This command is not supported by CANblue. Return error immediately.
      if (intDeviceList.deviceType[listIndex] == DeviceType.CANBLUE)
      {
        return ReturnCode.COMMAND_NOT_SUPPORTED;
      }

      // Check the validity of the input.
      if ((timeout > 1000) || (timeout < 0))
      {
        return ReturnCode.INVALID_TIMEOUT_VALUE;
      }

      String command = "D BUFF_TIMEOUT " + timeout;
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("BUFF_TIMEOUT");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Set the Bluetooth connection latency setting.
     * This command is not supported by CANblue ({@link ReturnCode#COMMAND_NOT_SUPPORTED}).
     * This method is not used by the {@link API_ADK}.
     * @param latencySetting Input: Set the latency as 
     *     {@link ConstantList#DEFAULT_LATENCY} or 
     *     {@link ConstantList#SHORTEST_LATENCY}.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#COMMAND_NOT_SUPPORTED}, 
     *         {@link ReturnCode#INVALID_LATENCY_SETTING}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode setCANblueLatencySetting(byte latencySetting)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // This command is not supported by CANblue. Return error immediately.
      if (intDeviceList.deviceType[listIndex] == DeviceType.CANBLUE)
      {
        return ReturnCode.COMMAND_NOT_SUPPORTED;
      }

      // Check the validity of the input.
      String latencySettingString;
      if (latencySetting == DEFAULT_LATENCY)
      {
        latencySettingString = "DEFAULT";
      }
      else if (latencySetting == SHORTEST_LATENCY)
      {
        latencySettingString = "SHORTEST_LATENCY";
      }
      else
      {
        return ReturnCode.INVALID_LATENCY_SETTING;
      }

      String command = "D LINK_POLICY " + latencySettingString;
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("LINK_POLICY");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Set the Bluetooth connection settings.
     * This command is not supported by CANblue ({@link ReturnCode#COMMAND_NOT_SUPPORTED}).
     * This method is not used by the {@link API_ADK}.
     * @param packetType       Input: The value of packet type (0 - 0xFFFF).
     * @param pagescanInterval Input: The value of pagescan interval (0 - 0x1000).
     * @param pagescanWindows  Input: The value of pagescan window (0 - 0x100).
     * @param pagescanType     Input: The value of pagescan type (0 or 1).
     * @param latency          Input: The value of latency (0 - 0xFFFFFFFF).
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#COMMAND_NOT_SUPPORTED}, 
     *         {@link ReturnCode#INVALID_PACKET_TYPE_VALUE}, 
     *         {@link ReturnCode#INVALID_PAGESCAN_INTERVAL_VALUE}, 
     *         {@link ReturnCode#INVALID_PAGESCAN_WINDOWS_VALUE}, 
     *         {@link ReturnCode#INVALID_PAGESCAN_TYPE_VALUE}, 
     *         {@link ReturnCode#INVALID_LATENCY_VALUE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode setCANblueConnectionSettings(int packetType,
        int pagescanInterval, int pagescanWindows, 
        byte pagescanType, long latency)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // This command is not supported by CANblue. Return error immediately.
      if (intDeviceList.deviceType[listIndex] == DeviceType.CANBLUE)
      {
        return ReturnCode.COMMAND_NOT_SUPPORTED;
      }

      // Check the validity of the input.
      String packetTypeString;
      String pagescanIntervalString;
      String pagescanWindowsString;
      String pagescanTypeString;
      String latencyString;
      if ((packetType <= 0xFFFF) && (packetType >= 0))
      {
        try
        {
          packetTypeString = Integer.toHexString(packetType);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.INVALID_PACKET_TYPE_VALUE;
        }
      }
      else
      {
        return ReturnCode.INVALID_PACKET_TYPE_VALUE;
      }

      if ((pagescanInterval <= 0x1000) || (pagescanInterval >= 0))
      {
        try
        {
          pagescanIntervalString = Integer.toHexString(pagescanInterval);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.INVALID_PAGESCAN_INTERVAL_VALUE;
        }
      }
      else
      {
        return ReturnCode.INVALID_PAGESCAN_INTERVAL_VALUE;
      }

      if ((pagescanWindows <= 0x100) || (pagescanWindows >= 0))
      {
        try
        {
          pagescanWindowsString = Integer.toHexString(pagescanWindows);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.INVALID_PAGESCAN_WINDOWS_VALUE;
        }
      }
      else
      {
        return ReturnCode.INVALID_PAGESCAN_WINDOWS_VALUE;
      }

      if ((pagescanType <= 1) && (pagescanType >= 0))
      {
        try
        {
          pagescanTypeString = Integer.toHexString(pagescanType);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.INVALID_PAGESCAN_TYPE_VALUE;
        }
      }
      else
      {
        return ReturnCode.INVALID_PAGESCAN_TYPE_VALUE;
      }

      if ((latency <= 0xFFFFFFFFL) && (latency >= 0))
      {
        try
        {
          latencyString = Long.toHexString(latency);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.INVALID_LATENCY_VALUE;
        }
      }
      else
      {
        return ReturnCode.INVALID_LATENCY_VALUE;
      }

      String command = "D LINK_POLICY_CUSTOM " + packetTypeString + " "
                       + pagescanIntervalString + " " + pagescanWindowsString
                       + " " + pagescanTypeString + " " + latencyString;
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("LINK_POLICY_CUSTOM");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          break;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Read the Bluetooth connection latency setting. The device list and its 
     * connection status is not parsed / included.
     * This command is not supported by CANblue ({@link ReturnCode#COMMAND_NOT_SUPPORTED}).
     * This method is not used by the {@link API_ADK}.
     * @param latencyInformation Output: The latency information.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#COMMAND_NOT_SUPPORTED}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode readCANblueLatencyInformation(
        LatencyInformation latencyInformation)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // This command is not supported by CANblue. Return error immediately.
      if (intDeviceList.deviceType[listIndex] == DeviceType.CANBLUE)
      {
        return ReturnCode.COMMAND_NOT_SUPPORTED;
      }

      // Check the validity of the parameter.
      if (latencyInformation == null)
      {
        return ReturnCode.DEVICEINFORMATION_OBJECT_NOT_VALID;
      }
      String command = "D INFO";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // The response consist of more than one line, wait for more response.
      // The first line should contain "Link-policy" and the last line
      // should contain "D INFO". 
      int lineIndex1 = -1, lineIndex2 = -1;
      index = 0;
      timeOutCounter = 0;
      while (true)
      {
        if (index < respBuffer.bufferIndex)
        {
          try
          {
            foundIndex = respBuffer.buffer[index].indexOf("Link-policy");
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.FAIL_SEARCHING_STRING;
          }
          if (foundIndex != -1)
          {
            lineIndex1 = index;  // Find the first line.
          }
          try
          {
            foundIndex = respBuffer.buffer[index].indexOf("D INFO");
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.FAIL_SEARCHING_STRING;
          }
          if (foundIndex != -1)
          {
            lineIndex2 = index;  // Find the last line.
            break;
          }
          // Increment the index and reset the timeout counter.
          index++;
          timeOutCounter = 0;
        }
        else
        {
          // Increment the counter while waiting for more response.
          timeOutCounter++;
          if (timeOutCounter >= WAITING_FOR_RESPONSE)
          {
            return ReturnCode.WAITING_FOR_RESPONSE_TIMEOUT;
          }
          try
          {
            Thread.sleep(SLEEP_TIME);
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.EXCEPTION_SLEEP_THREAD;
          }
        }
      }

      // Check the content of the response.
      if ((lineIndex1 != -1) && (lineIndex2 != -1))
      {
        // Increase the first line index.
        lineIndex1++;
        String packetTypeString = null, pagescanIntervalString = null,
            pagescanWindowString = null, pagescanTypeString = null,
            latencyString = null;
        byte numberOfLine = (byte) (lineIndex2 - lineIndex1);
        if (numberOfLine < 6)
        {
          return ReturnCode.INVALID_RESPONSE;
        }
        // Fill the connection name.
        try
        {
          latencyInformation.connectionName =
              respBuffer.buffer[lineIndex1 + 0].substring (20);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          latencyInformation.connectionName = null;
        }

        // Convert and fill the packet type.
        try
        {
          packetTypeString =
              respBuffer.buffer[lineIndex1 + 1].substring (20);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          latencyInformation.packetType = -1;
        }
        try
        {
          latencyInformation.packetType = Integer.parseInt(packetTypeString, 16);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          latencyInformation.packetType = -1;
        }

        // Convert and fill the pagescan interval.
        try
        {
          pagescanIntervalString =
              respBuffer.buffer[lineIndex1 + 2].substring (20);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          latencyInformation.pagescanInterval = -1;
        }
        try
        {
          latencyInformation.pagescanInterval =
              Integer.parseInt(pagescanIntervalString, 16);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          latencyInformation.pagescanInterval = -1;
        }

        // Convert and fill the pagescan window.
        try
        {
          pagescanWindowString =
              respBuffer.buffer[lineIndex1 + 3].substring (20);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          latencyInformation.pagescanWindow = -1;
        }
        try
        {
          latencyInformation.pagescanWindow =
              Integer.parseInt(pagescanWindowString, 16);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          latencyInformation.pagescanWindow = -1;
        }

        // Convert and fill the pagescan type.
        try
        {
          pagescanTypeString =
              respBuffer.buffer[lineIndex1 + 4].substring (20);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          latencyInformation.pagescanType = -1;
        }
        try
        {
          latencyInformation.pagescanType =
              (byte) Integer.parseInt(pagescanTypeString, 16);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          latencyInformation.pagescanType = -1;
        }

        // Convert and fill the latency.
        try
        {
          latencyString =
              respBuffer.buffer[lineIndex1 + 5].substring (20);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          latencyInformation.latency = -1;
        }
        try
        {
          latencyInformation.latency = Integer.parseInt(latencyString, 16);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          latencyInformation.latency = -1;
        }
        return ReturnCode.SUCCESS;
      }
      else
      {
        return ReturnCode.INVALID_RESPONSE;
      }
    }

    /**
     * Reset the CANblue device and the connection is lost.
     * This method is not used by the {@link API_ADK}.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode resetCANblueDevice()
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      String command = "D RESET";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("RESET");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Write the Hardware Serial Number.
     * This command is not supported by CANblue ({@link ReturnCode#COMMAND_NOT_SUPPORTED}).
     * This method is not used by the {@link API_ADK}.
     * @param hardwareSerialNumber Input: A string of number with 6characters 
     *        length (000000 - 999999).
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#COMMAND_NOT_SUPPORTED}, 
     *         {@link ReturnCode#INVALID_HARDWARE_SERIAL_NUMBER_LENGTH}, 
     *         {@link ReturnCode#FAIL_WRITING_HW_SERIAL_NUM}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode writeCANblueHardwareSerialNumber(String hardwareSerialNumber)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // This command is not supported by CANblue. Return error immediately.
      if (intDeviceList.deviceType[listIndex] == DeviceType.CANBLUE)
      {
        return ReturnCode.COMMAND_NOT_SUPPORTED;
      }

      // Check the validity of the input
      if (hardwareSerialNumber == null)
      {
        return ReturnCode.STRING_NOT_VALID;
      }
      else if (hardwareSerialNumber.length() != 6)
      {
        return ReturnCode.INVALID_HARDWARE_SERIAL_NUMBER_LENGTH;
      }

      String command = "D WRITE_HW_SERIAL_NUM HW" + hardwareSerialNumber;
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("WRITE_HW_SERIAL_NUM");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("Unknown error");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.FAIL_WRITING_HW_SERIAL_NUM;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Turn on the Bluetooth test mode.
     * This command is not supported by CANblue ({@link ReturnCode#COMMAND_NOT_SUPPORTED}).
     * This method is not used by the {@link API_ADK}.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#COMMAND_NOT_SUPPORTED}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode writeCANblueDUTEnable()
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // This command is not supported by CANblue. Return error immediately.
      if (intDeviceList.deviceType[listIndex] == DeviceType.CANBLUE)
      {
        return ReturnCode.COMMAND_NOT_SUPPORTED;
      }

      String command = "D CBHCI_CMDWRDUTENABLE";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("CBHCI_CMDWRDUTENABLE");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Turn on the Bluetooth test mode.
     * This command is not supported by CANblue ({@link ReturnCode#COMMAND_NOT_SUPPORTED}).
     * This method is not used by the {@link API_ADK}.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#COMMAND_NOT_SUPPORTED}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode enableCANblueDebugInfo()
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // This command is not supported by CANblue. Return error immediately.
      if (intDeviceList.deviceType[listIndex] == DeviceType.CANBLUE)
      {
        return ReturnCode.COMMAND_NOT_SUPPORTED;
      }

      String command = "D DEBUG_INFO";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("DEBUG_INFO");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          break;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Manually change the Baudrate bits of the CAN controller.
     * This method is not used by the {@link API_ADK}.
     * @param BT0         Input: The value of BT0 byte.
     * @param BT1         Input: The value of BT1 byte.
     * @param busCoupling Input: {@link ConstantList#HIGH_BUSCOUPLING} or 
     *     {@link ConstantList#LOW_BUSCOUPLING}.
     * @param name        Input: The name of the connection.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#INVALID_BUS_COUPLING}, 
     *         {@link ReturnCode#FAIL_INITIALIZING_CONTROLLER}, 
     *         {@link ReturnCode#BUS_COUPLING_NOT_SUPPORTED}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode setCANblueBaudrateBit(byte BT0, byte BT1,
        byte busCoupling, String name)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the input.
      if (name == null)
      {
        return ReturnCode.STRING_NOT_VALID;
      }
      String busCouplingString;
      if (busCoupling == HIGH_BUSCOUPLING)
      {
        busCouplingString = "HIGH";
      }
      else if (busCoupling == LOW_BUSCOUPLING)
      {
        busCouplingString = "LOW";
      }
      else
      {
        return ReturnCode.INVALID_BUS_COUPLING;
      }

      String command = "C CAN_INIT_CUSTOM " + Integer.toHexString(BT0) + " "
                       + Integer.toHexString(BT1) + " " + busCouplingString
                       + " \"" + name + "\"";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("CAN_INIT_CUSTOM");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf(
              "Error while initializing CAN");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.FAIL_INITIALIZING_CONTROLLER;
        }
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf(
              "Unsupported parameter");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.BUS_COUPLING_NOT_SUPPORTED;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Manually initialize the Baudrate of the CAN controller.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @param baudrate    Input: The value of baudrate (10 - 1000).
     * @param busCoupling Input: {@link ConstantList#HIGH_BUSCOUPLING} or 
     *     {@link ConstantList#LOW_BUSCOUPLING}.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#INVALID_BAUDRATE_VALUE},
     *         {@link ReturnCode#INVALID_BUS_COUPLING}, 
     *         {@link ReturnCode#BAUDRATE_NOT_SUPPORTED}, 
     *         {@link ReturnCode#FAIL_INITIALIZING_CONTROLLER}, 
     *         {@link ReturnCode#BUS_COUPLING_NOT_SUPPORTED}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode setCANblueBaudrateManual(int baudrate, byte busCoupling)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

    	// Check the validity of the input.
      String busCouplingString;
      if ((baudrate < 10) || (baudrate > 1000))
      {
        return ReturnCode.INVALID_BAUDRATE_VALUE;
      }

      if (busCoupling == HIGH_BUSCOUPLING)
      {
        busCouplingString = "HIGH";
      }
      else if (busCoupling == LOW_BUSCOUPLING)
      {
        busCouplingString = "LOW";
      }
      else
      {
        return ReturnCode.INVALID_BUS_COUPLING;
      }

      String command = "C CAN_INIT " + baudrate + " " + busCouplingString;
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("CAN_INIT");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf(
              "Baudrate not supported");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.BAUDRATE_NOT_SUPPORTED;
        }
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf(
              "Error while initializing CAN");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.FAIL_INITIALIZING_CONTROLLER;
        }
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf(
              "Unsupported parameter");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.BUS_COUPLING_NOT_SUPPORTED;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Determine the baudrate of the CAN network and use it as 
     * the baudrate of the controller.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @param timeout     Input: The timeout for testing each supported baudrate.
     * @param busCoupling Input: {@link ConstantList#HIGH_BUSCOUPLING} or 
     *     {@link ConstantList#LOW_BUSCOUPLING}.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#INVALID_TIMEOUT_VALUE},
     *         {@link ReturnCode#INVALID_BUS_COUPLING}, 
     *         {@link ReturnCode#NO_BAUDRATE_DETECTED}, 
     *         {@link ReturnCode#BUS_COUPLING_NOT_SUPPORTED}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode setCANblueBaudrateAuto(int timeout,
        byte busCoupling)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

    	// Check the validity of the input.
      String busCouplingString;
      if ((timeout < 1) || (timeout > 1000))
      {
        return ReturnCode.INVALID_TIMEOUT_VALUE;
      }

      if (busCoupling == HIGH_BUSCOUPLING)
      {
        busCouplingString = "HIGH";
      }
      else if (busCoupling == LOW_BUSCOUPLING)
      {
        busCouplingString = "LOW";
      }
      else
      {
        return ReturnCode.INVALID_BUS_COUPLING;
      }

      String command = "C CAN_INIT_AUTO " + timeout + " " + busCouplingString;
      // The waiting time depends on the number of the supported baudrate.
      // Currently there are 9 baudrates.
      returnCode = sendAndReceiveCommand(command,
          (timeout * 10 * 9) + WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // The response consist of more than one line, wait for more response.
      index = 0;
      timeOutCounter = 0;
      while (true)
      {
        if (index < respBuffer.bufferIndex)
        {
          try
          {
            foundIndex = respBuffer.buffer[index].indexOf("CAN_INIT_AUTO");
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.FAIL_SEARCHING_STRING;
          }
          if (foundIndex != -1)
          {
            return ReturnCode.SUCCESS;
          }
          try
          {
            foundIndex = respBuffer.buffer[index].indexOf("Baudrate not detected");
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.FAIL_SEARCHING_STRING;
          }
          if (foundIndex != -1)
          {
        	  return ReturnCode.NO_BAUDRATE_DETECTED;
          }
          try
          {
            foundIndex = respBuffer.buffer[index].indexOf("Unsupported parameter");
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.FAIL_SEARCHING_STRING;
          }
          if (foundIndex != -1)
          {
        	  return ReturnCode.BUS_COUPLING_NOT_SUPPORTED;
          }
          // Increment the index and reset the timeout counter.
          index++;
          timeOutCounter = 0;
        }
        else
        {
          // Increment the counter while waiting for more response.
          timeOutCounter++;
          if (timeOutCounter >= WAITING_FOR_RESPONSE)
          {
            return ReturnCode.WAITING_FOR_RESPONSE_TIMEOUT;
          }
          try
          {
            Thread.sleep(SLEEP_TIME);
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.EXCEPTION_SLEEP_THREAD;
          }
        }
      }
    }

    /**
     * Activate or deactivate the sending of CAN message and its
     * mode, ASCII or Binary.
     * This command is not supported by CANblue ({@link ReturnCode#COMMAND_NOT_SUPPORTED}).
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @param mode Input: The value of mode ({@link ConstantList#SEND_FRAME_OFF}, 
     *     {@link ConstantList#SEND_FRAME_ASCII}, or 
     *     {@link ConstantList#SEND_FRAME_BINARY}).
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#COMMAND_NOT_SUPPORTED},
     *         {@link ReturnCode#INVALID_INPUT_MODE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode setCANblueSendCANFrames (byte mode)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

    	// This command is not supported by CANblue. Return error immediately.
      if (intDeviceList.deviceType[listIndex] == DeviceType.CANBLUE)
      {
        return ReturnCode.COMMAND_NOT_SUPPORTED;
      }

      // Check the validity of the input.
      String modeString;
      if (mode == SEND_FRAME_OFF)
      {
        modeString = "OFF";
      }
      else if (mode == SEND_FRAME_ASCII)
      {
        modeString = "ASCII";
      }
      else if (mode == SEND_FRAME_BINARY)
      {
        modeString = "BINARY";
      }
      else
      {
        return ReturnCode.INVALID_INPUT_MODE;
      }

      String command = "C SEND_CAN_FRAMES " + modeString;
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        // The response should be "OK: SEND_CAN_FRAMES" instead of
        // "OK: C SEND_CAN_FRAMES".
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf(
              "SEND_CAN_FRAMES");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Clear the receive filter of the CANblue.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @param frameFormat Input: The value of frame format 
     *     ({@link ConstantList#STANDARD_FRAME}, or {@link ConstantList#STANDARD_FRAME}).
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#INVALID_FRAME_FORMAT_VALUE},
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode clearCANblueFilter(byte frameFormat)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

    	// Check the validity of the input.
      String frameFormatString;
      if (frameFormat == STANDARD_FRAME)
      {
        frameFormatString = "STD";
      }
      else if (frameFormat == EXTENDED_FRAME)
      {
        frameFormatString = "EXT";
      }
      else
      {
        return ReturnCode.INVALID_FRAME_FORMAT_VALUE;
      }

      String command = "C FILTER_CLEAR " + frameFormatString;

      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("FILTER_CLEAR");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Add an ID to the receive filter of the CANblue.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @param frameFormat Input: The value of frame format 
     *     ({@link ConstantList#STANDARD_FRAME}, or {@link ConstantList#STANDARD_FRAME}).
     * @param messageID   Input: The value of message ID (0 - 0x7FF for 
     *     Standard frame and 0 - 0x1FFFFFFF for Extended frame).
     * @param frameType Input: The value of frame type 
     *     ({@link ConstantList#DATA_FRAME}, or {@link ConstantList#REMOTE_FRAME}).
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#INVALID_MESSAGE_ID_VALUE}, 
     *         {@link ReturnCode#INVALID_FRAME_FORMAT_VALUE}, 
     *         {@link ReturnCode#INVALID_FRAME_TYPE_VALUE}, 
     *         {@link ReturnCode#FAIL_ADDING_ID_TO_FILTER}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode addCANblueFilter(byte frameFormat, 
        int messageID, byte frameType)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

    	// Check the validity of the input.
      String frameFormatString;
      String frameTypeString;
      if (frameFormat == STANDARD_FRAME)
      {
        frameFormatString = "STD";
        if ((messageID > 0x7FF) || (messageID < 0))
        {
          return ReturnCode.INVALID_MESSAGE_ID_VALUE;
        }
      }
      else if (frameFormat == EXTENDED_FRAME)
      {
        frameFormatString = "EXT";
        if ((messageID > 0x1FFFFFFFL) || (messageID < 0))
        {
          return ReturnCode.INVALID_MESSAGE_ID_VALUE;
        }
      }
      else
      {
        return ReturnCode.INVALID_FRAME_FORMAT_VALUE;
      }

      if (frameType == DATA_FRAME)
      {
        frameTypeString = "DATA";
      }
      else if (frameType == REMOTE_FRAME)
      {
        frameTypeString = "RTR";
      }
      else
      {
        return ReturnCode.INVALID_FRAME_TYPE_VALUE;
      }

      String command = "C FILTER_ADD " + frameFormatString +
          " " + Integer.toHexString(messageID) + " " + frameTypeString;
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("FILTER_ADD");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf(
              "Error adding ID to filter");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.FAIL_ADDING_ID_TO_FILTER;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Remove an ID from the receive filter of the CANblue.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @param frameFormat Input: The value of frame format 
     *     ({@link ConstantList#STANDARD_FRAME}, or {@link ConstantList#STANDARD_FRAME}).
     * @param messageID   Input: The value of message ID (0 - 0x7FF for 
     *     Standard frame and 0 - 0x1FFFFFFF for Extended frame).
     * @param frameType Input: The value of frame type 
     *     ({@link ConstantList#DATA_FRAME}, or {@link ConstantList#REMOTE_FRAME}).
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#INVALID_MESSAGE_ID_VALUE}, 
     *         {@link ReturnCode#INVALID_FRAME_FORMAT_VALUE}, 
     *         {@link ReturnCode#INVALID_FRAME_TYPE_VALUE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode removeCANblueFilter(byte frameFormat, 
        int messageID, byte frameType)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

    	// Check the validity of the input.
      String frameFormatString;
      String frameTypeString;
      if (frameFormat == STANDARD_FRAME)
      {
        frameFormatString = "STD";
        if ((messageID > 0x7FF) || (messageID < 0))
        {
          return ReturnCode.INVALID_MESSAGE_ID_VALUE;
        }
      }
      else if (frameFormat == EXTENDED_FRAME)
      {
        frameFormatString = "EXT";
        if ((messageID > 0x1FFFFFFFL) || (messageID < 0))
        {
          return ReturnCode.INVALID_MESSAGE_ID_VALUE;
        }
      }
      else
      {
        return ReturnCode.INVALID_FRAME_FORMAT_VALUE;
      }

      if (frameType == DATA_FRAME)
      {
        frameTypeString = "DATA";
      }
      else if (frameType == REMOTE_FRAME)
      {
        frameTypeString = "RTR";
      }
      else
      {
        return ReturnCode.INVALID_FRAME_TYPE_VALUE;
      }

      String command = "C FILTER_REMOVE " + frameFormatString +
          " " + Integer.toHexString(messageID) + " " + frameTypeString;
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("FILTER_REMOVE");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Enable or disable the receive filter of the CANblue.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @param frameFormat  Input: The value of frame format 
     *     ({@link ConstantList#STANDARD_FRAME}, or {@link ConstantList#STANDARD_FRAME}).
     * @param enableFilter Input: True for enabling or false for disabling 
     *     the filter.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#INVALID_FRAME_FORMAT_VALUE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode setCANblueFilter(byte frameFormat, boolean enableFilter)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the input.
      String frameFormatString;
      if (frameFormat == STANDARD_FRAME)
      {
        frameFormatString = "STD";
      }
      else if (frameFormat == EXTENDED_FRAME)
      {
        frameFormatString = "EXT";
      }
      else
      {
        return ReturnCode.INVALID_FRAME_FORMAT_VALUE;
      }

      String command;
      if (enableFilter == true)
      {
        command = "C FILTER_ENABLE " + frameFormatString;
      }
      else
      {
        command = "C FILTER_DISABLE " + frameFormatString;
      }
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("FILTER_DISABLE");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("FILTER_ENABLE");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Read the status of CANblue Controller.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @param status Output: The status of the CAN controller.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode readCANblueControllerInfo(CANInfo status)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the parameter.
      if (status == null)
      {
    	  return ReturnCode.CANINFO_OBJECT_NOT_VALID;
      }
      String command = "C CAN_INFO";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // The response consist of more than one line, wait for more response.
      // The last line should contains "OK: CAN_INFO"
      int lineIndex1 = -1, lineIndex2 = -1;
      index = 0;
      timeOutCounter = 0;
      while (true)
      {
        if (index < respBuffer.bufferIndex)
        {
          try
          {
            foundIndex = respBuffer.buffer[index].indexOf("CAN_INFO");
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.FAIL_SEARCHING_STRING;
          }
          if (foundIndex != -1)
          {
            lineIndex2 = index;
            break;
          }
          // Increment the index and reset the timeout counter.
          index++;
          timeOutCounter = 0;
        }
        else
        {
          // Wait for more response, until the length of the
          // response change or timeout
          timeOutCounter++;
          if (timeOutCounter >= WAITING_FOR_RESPONSE)
          {
            return ReturnCode.WAITING_FOR_RESPONSE_TIMEOUT;
          }
          try
          {
            Thread.sleep(SLEEP_TIME);
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.EXCEPTION_SLEEP_THREAD;
          }
        }
      }

      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        // Search for the first line. It might contain either
        // "CAN started" or "CAN stopped".
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("CAN stopped");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          status.controllerStatus = ControllerStatus.CONTROLLER_STOP;
          intDeviceList.controllerStatus[listIndex] = status.controllerStatus;
          lineIndex1 = index;
          break;
        }

        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("CAN started");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          status.controllerStatus = ControllerStatus.CONTROLLER_START;
          intDeviceList.controllerStatus[listIndex] = status.controllerStatus;
          lineIndex1 = index;
          break;
        }
      }

      // Initialize some of the variables.
      status.busOff = false;
      status.RxCANControllerOverrun = false;
      status.RxSWQueueOverrun = false;
      status.TxPending = false;
      status.TxSWQueueOverrun = false;
      status.warningLevel = false;

      if ((lineIndex1 != -1) && (lineIndex2 != -1))
      {
        if ((lineIndex2 - lineIndex1 - 1) == 0)
        {
          // No line in between / no flag, return immediately.
          return ReturnCode.SUCCESS;
        }
      }
      else
      {
        return ReturnCode.INVALID_RESPONSE;
      }

      // Start parsing for flags.
      for (index = (lineIndex1 + 1); index < lineIndex2; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf(
              "CAN controller in BUS OFF");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          status.busOff = true;
          continue;
        }

        try
        {
          foundIndex = respBuffer.buffer[index].indexOf(
              "CAN controller in WARNING LEVEL");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          status.warningLevel = true;
          continue;
        }

        try
        {
          foundIndex = respBuffer.buffer[index].indexOf(
              "Rx CAN controller OVERRUN");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          status.RxCANControllerOverrun = true;
          continue;
        }

        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("Rx SW queue OVERRUN");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          status.RxSWQueueOverrun = true;
          continue;
        }

        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("Tx SW queue OVERRUN");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          status.TxSWQueueOverrun = true;
          continue;
        }

        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("Tx pending");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          status.TxPending = true;
          continue;
        }
      }
      return ReturnCode.SUCCESS;
    }

    /**
     * Start the CAN Controller of the CANblue.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#FAIL_STARTING_CONTROLLER}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode startCANblueController()
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      String command = "C CAN_START";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("CAN_START");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("Error starting CAN");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.FAIL_STARTING_CONTROLLER;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /**
     * Stop the CAN Controller of the CANblue.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#FAIL_STOPPING_CONTROLLER}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode stopCANblueController()
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      String command = "C CAN_STOP";
      returnCode = sendAndReceiveCommand(command, WAITING_FOR_RESPONSE);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      // Check the content of the response.
      for (index = 0; index < respBuffer.bufferIndex; index++)
      {
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("CAN_STOP");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.SUCCESS;
        }
        try
        {
          foundIndex = respBuffer.buffer[index].indexOf("Error stop CAN");
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.FAIL_SEARCHING_STRING;
        }
        if (foundIndex != -1)
        {
          return ReturnCode.FAIL_STOPPING_CONTROLLER;
        }
      }
      if (foundIndex == -1)
      {
        return ReturnCode.INVALID_RESPONSE;
      }
      else
      {
        return ReturnCode.SUCCESS;
      }
    }

    /** The transmit buffer. */
    private byte[] dataArray = new byte[MAXIMUM_MESSAGE_ARRAY_LENGTH];
    /** Temporary array for converting the data from an integer to ASCII. */
    private byte[] tempData = null;
    /** Temporary array for converting the message ID from an integer to ASCII. */
    private byte[] tempMessageID = null;
    /** The index used for the transmit buffer. */
    private byte byteIndex = 0;

    /**
     * Transmit a message (in ASCII format) to the CANblue controller.
     * This method works together with the transmit thread by not sending every 
     * message directly. The transmit mechanism will be activated every 5ms or 
     * if there are enough data inside the buffer before 5ms. This mechanism 
     * increases the data rate and decrease time needed to send messages.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @param message Message to be sent.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#INVALID_MESSAGE_ID_VALUE},
     *         {@link ReturnCode#INVALID_FRAME_FORMAT_VALUE}, 
     *         {@link ReturnCode#INVALID_DATA_LENGTH}, 
     *         {@link ReturnCode#INVALID_DATA_VALUE}, 
     *         {@link ReturnCode#INVALID_FRAME_TYPE_VALUE}, 
     *         {@link ReturnCode#EXCEPTION_SEMAPHORE_ACQUIRE}, 
     *         {@link ReturnCode#EXCEPTION_SEMAPHORE_RELEASE}, 
     *         {@link ReturnCode#WAITING_TO_SEND_TIMEOUT}, or 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}.
     */
    public ReturnCode PutCANblueASCIIMessage(MessageStructure message)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the input.
      if (message == null)
      {
        return ReturnCode.MESSAGESTRUCTURE_OBJECT_NOT_VALID;
      }
      byteIndex = 0;
      dataArray[byteIndex++] = 'M';
      dataArray[byteIndex++] = ' ';
      if (message.frameFormat == STANDARD_FRAME)
      {
        dataArray[byteIndex++] = 'S';
        if ((message.messageID > 0x7FF) || (message.messageID < 0))
        {
          return ReturnCode.INVALID_MESSAGE_ID_VALUE;
        }
      }
      else if (message.frameFormat == EXTENDED_FRAME)
      {
        dataArray[byteIndex++] = 'E';
        if ((message.messageID > 0x1FFFFFFFL) || (message.messageID < 0))
        {
          return ReturnCode.INVALID_MESSAGE_ID_VALUE;
        }
      }
      else
      {
        return ReturnCode.INVALID_FRAME_FORMAT_VALUE;
      }

      if ((message.dataLength > 8) || (message.dataLength < 0))
      {
        return ReturnCode.INVALID_DATA_LENGTH;
      }

      if (message.frameType == DATA_FRAME)
      {
        dataArray[byteIndex++] = 'D';
        // Since the data length is always smaller than 9, it is
        // safe to directly convert it to ASCII by adding '0'.
        dataArray[byteIndex++] = (byte) (message.dataLength + '0');
        dataArray[byteIndex++] = ' ';
        tempMessageID = intToHexASCIIArray(message.messageID);
        if (tempMessageID == null)
        {
          return ReturnCode.INVALID_MESSAGE_ID_VALUE;
        }
        for (int i = 0; i < tempMessageID.length; i++)
        {
          dataArray[byteIndex++] = tempMessageID[i];
        }
        if (message.dataLength == 0)
        {
          // Add nothing.
        }
        else
        {
          if (message.data == null)
          {
            return ReturnCode.INVALID_DATA_LENGTH;
          }
          /*if (message.data.length != message.dataLength)
          {
            return ReturnCode.INVALID_DATA_LENGTH;
          }*/
          for (int i = 0; i < message.dataLength; i++)
          {
            if ((message.data[i] > 0xFF) || (message.data[i] < 0))
            {
              return ReturnCode.INVALID_DATA_VALUE;
            }
            tempData = intToHexASCIIArray(message.data[i]);
            if (tempData == null)
            {
              return ReturnCode.INVALID_DATA_VALUE;
            }
            dataArray[byteIndex++] = ' ';
            for (byte j = 0; j < tempData.length; j++)
            {
            	dataArray[byteIndex++] = tempData[j];
            }
          }
        }
      }
      else if (message.frameType == REMOTE_FRAME)
      {
        dataArray[byteIndex++] = 'R';
        // Since the data length is always smaller than 9, it is
        // safe to directly convert it to ASCII by adding '0'.
        dataArray[byteIndex++] = (byte) (message.dataLength + '0');
        dataArray[byteIndex++] = ' ';
        tempMessageID = intToHexASCIIArray(message.messageID);
        if (tempMessageID == null)
        {
          return ReturnCode.INVALID_MESSAGE_ID_VALUE;
        }
        for (int i = 0; i < tempMessageID.length; i++)
        {
          dataArray[byteIndex++] = tempMessageID[i];
        }
      }
      else
      {
        return ReturnCode.INVALID_FRAME_TYPE_VALUE;
      }

      dataArray[byteIndex++] = 0xA;  // '\n'.

      // Put the data into the buffer.
      timeOutCounter = 0;
      while(true)
      {
        if ((bulkBufferIndex < bulkBufferFull))
        {
          try
          {
            bulkBufferFlag.acquire();
          }
          catch (InterruptedException e)
          {
            e.printStackTrace();
            return ReturnCode.EXCEPTION_SEMAPHORE_ACQUIRE;
          }
          for (byte i = 0; i < byteIndex; i++)
          {
            bulkBuffer[bulkBufferIndex++] = dataArray[i];
          }
          try
          {
            bulkBufferFlag.release();
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.EXCEPTION_SEMAPHORE_RELEASE;
          }
          break;
        }
        timeOutCounter++;
        if (timeOutCounter >= 1000)
        {
          return ReturnCode.WAITING_TO_SEND_TIMEOUT;
        }
        try
        {
          Thread.sleep(0, 100000);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.EXCEPTION_SLEEP_THREAD;
        }
      }
      return ReturnCode.SUCCESS;
    }

    /**
     * Transmit a message (in Binary format) to the CANblue controller.
     * This method works together with the transmit thread by not sending every 
     * message directly. The transmit mechanism will be activated every 5ms or 
     * if there are enough data inside the buffer before 5ms. This mechanism 
     * increases the data rate and decrease time needed to send messages.
     * The binary format is shorter than the ASCII format, 
     * so it takes less time and increase data rate.
     * This method is used by the {@link API_ADK}, but should not be called directly.
     * @param message Message to be sent.
     * @return {@link ReturnCode#SUCCESS},
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED}, 
     *         {@link ReturnCode#INVALID_MESSAGE_ID_VALUE},
     *         {@link ReturnCode#INVALID_FRAME_FORMAT_VALUE}, 
     *         {@link ReturnCode#INVALID_DATA_LENGTH}, 
     *         {@link ReturnCode#INVALID_DATA_VALUE}, 
     *         {@link ReturnCode#INVALID_FRAME_TYPE_VALUE}, 
     *         {@link ReturnCode#EXCEPTION_SEMAPHORE_ACQUIRE}, 
     *         {@link ReturnCode#EXCEPTION_SEMAPHORE_RELEASE}, 
     *         {@link ReturnCode#WAITING_TO_SEND_TIMEOUT}, or 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}.
     */
    public ReturnCode PutCANblueBinaryMessage(MessageStructure message)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the input.
      if (message == null)
      {
        return ReturnCode.MESSAGESTRUCTURE_OBJECT_NOT_VALID;
      }
      byteIndex = 0;
      dataArray[byteIndex++] = 'X';

      dataArray[byteIndex] = 0x00; // Prepare the frame info byte.
      if (message.frameFormat == STANDARD_FRAME)
      {
        // Fill with nothing.
        if ((message.messageID > 0x7FF)  || (message.messageID < 0))
        {
        	return ReturnCode.INVALID_MESSAGE_ID_VALUE;
        }
        else
        {
        	dataArray[byteIndex] |= message.dataLength;
        }
      }
      else if (message.frameFormat == EXTENDED_FRAME)
      {
        dataArray[byteIndex] |= 0x80;
        if ((message.messageID > 0x1FFFFFFFL) || (message.messageID < 0))
        {
          return ReturnCode.INVALID_MESSAGE_ID_VALUE;
        }
        else
        {
        	dataArray[byteIndex] |= message.dataLength;
        }
      }
      else
      {
        return ReturnCode.INVALID_FRAME_FORMAT_VALUE;
      }

      if (message.frameType == DATA_FRAME)
      {
        // Fill with nothing.
      }
      else if (message.frameType == REMOTE_FRAME)
      {
        dataArray[byteIndex] |= 0x40;
      }
      else
      {
        return ReturnCode.INVALID_FRAME_TYPE_VALUE;
      }

      byteIndex++; // Increase the byte index and fill it with message ID.
      if (message.frameFormat == STANDARD_FRAME)
      {
        for (byte i = 0; i < 2; i++)
        {
        	dataArray[byteIndex++] = (byte)(0xFF
        			& (message.messageID >> (8 * (1 - i))));
        }
      }
      else if (message.frameFormat == EXTENDED_FRAME)
      {
        for (byte i = 0; i < 4; i++)
        {
        	dataArray[byteIndex++] = (byte)(0xFF
        			& (message.messageID >> (8 * (3 - i))));
        }
      }

      // Check the data length.
      if ((message.dataLength > 8) || (message.dataLength < 0))
      {
        return ReturnCode.INVALID_DATA_LENGTH;
      }
      // Fill the data for data frame.
      if (message.frameType == DATA_FRAME)
      {
        for(byte i = 0; i < message.dataLength; i++)
        {
        	if ((message.data[i] > 0xFF) || (message.data[i] < 0))
            {
              return ReturnCode.INVALID_DATA_VALUE;
            }
        	dataArray[byteIndex++] = (byte) message.data[i];
        }
      }
      else if (message.frameType == REMOTE_FRAME)
      {
        // Fill with nothing.
      }

      // Put the data into the buffer.
      timeOutCounter = 0;
      while(true)
      {
        if ((bulkBufferIndex < bulkBufferFull))
        {
          try
          {
            bulkBufferFlag.acquire();
          }
          catch (InterruptedException e)
          {
            e.printStackTrace();
            return ReturnCode.EXCEPTION_SEMAPHORE_ACQUIRE;
          }
          for (byte i = 0; i < byteIndex; i++)
          {
            bulkBuffer[bulkBufferIndex++] = dataArray[i];
          }
          try
          {
            bulkBufferFlag.release();
          }
          catch (Exception e)
          {
            e.printStackTrace();
            return ReturnCode.EXCEPTION_SEMAPHORE_RELEASE;
          }
          break;
        }
        timeOutCounter++;
        if (timeOutCounter >= 1000)
        {
          return ReturnCode.WAITING_TO_SEND_TIMEOUT;
        }
        try
        {
          Thread.sleep(0, 100000);
        }
        catch (Exception e)
        {
          e.printStackTrace();
          return ReturnCode.EXCEPTION_SLEEP_THREAD;
        }
      }
      return ReturnCode.SUCCESS;
    }

    /**
     * Transmit a single message (in ASCII format) to the CANblue controller.
     * This method is not used by the {@link API_ADK}.
     * @param message Input: Message to be sent.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#INVALID_MESSAGE_ID_VALUE},
     *         {@link ReturnCode#INVALID_FRAME_FORMAT_VALUE}, 
     *         {@link ReturnCode#INVALID_DATA_LENGTH}, 
     *         {@link ReturnCode#INVALID_DATA_VALUE}, 
     *         {@link ReturnCode#INVALID_FRAME_TYPE_VALUE}, 
     *         {@link ReturnCode#MESSAGE_TOO_LONG}, or 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH}.
     */
    public ReturnCode transmitCANblueMessage(MessageStructure message)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return deviceStatus;
      }

      // Check the validity of the input.
      if (message == null)
      {
        return ReturnCode.MESSAGESTRUCTURE_OBJECT_NOT_VALID;
      }
      byte[] dataArray = new byte[MAXIMUM_MESSAGE_ARRAY_LENGTH];
      byte[] tempData = new byte[2];
      byte[] tempMessageID = null;
      byte byteIndex = 0;
      dataArray[byteIndex++] = 'M';
      dataArray[byteIndex++] = ' ';
      if (message.frameFormat == STANDARD_FRAME)
      {
        dataArray[byteIndex++] = 'S';
        if ((message.messageID > 0x7FF) || (message.messageID < 0))
        {
          return ReturnCode.INVALID_MESSAGE_ID_VALUE;
        }
      }
      else if (message.frameFormat == EXTENDED_FRAME)
      {
        dataArray[byteIndex++] = 'E';
        if ((message.messageID > 0x1FFFFFFFL) || (message.messageID < 0))
        {
          return ReturnCode.INVALID_MESSAGE_ID_VALUE;
        }
      }
      else
      {
        return ReturnCode.INVALID_FRAME_FORMAT_VALUE;
      }

      if (message.dataLength > 8)
      {
        return ReturnCode.INVALID_DATA_LENGTH;
      }

      if (message.frameType == DATA_FRAME)
      {
        dataArray[byteIndex++] = 'D';
        // Since the data length is always smaller than 9, it is
        // safe to directly convert it to ASCII by adding '0'.
        dataArray[byteIndex++] = (byte) (message.dataLength + '0');
        dataArray[byteIndex++] = ' ';
        tempMessageID = intToHexASCIIArray(message.messageID);
        if (tempMessageID == null)
        {
          return ReturnCode.INVALID_MESSAGE_ID_VALUE;
        }
        for (int i = 0; i < tempMessageID.length; i++)
        {
          dataArray[byteIndex++] = tempMessageID[i];
        }
        if (message.dataLength == 0)
        {
          // Add nothing.
        }
        else
        {
          if (message.data == null)
          {
            return ReturnCode.INVALID_DATA_LENGTH;
          }
          for (int i = 0; i < message.dataLength; i++)
          {
            if ((message.data[i] > 0xFF) || (message.data[i] < 0))
            {
              return ReturnCode.INVALID_DATA_VALUE;
            }
            tempData = intToHexASCIIArray(message.data[i]);
            if (tempData == null)
            {
              return ReturnCode.INVALID_DATA_VALUE;
            }
            dataArray[byteIndex++] = ' ';
            dataArray[byteIndex++] = tempData[0];
            dataArray[byteIndex++] = tempData[1];
          }
        }
      }
      else if (message.frameType == REMOTE_FRAME)
      {
          dataArray[byteIndex++] = 'R';
          // Since the data length is always smaller than 9, it is
          // safe to directly convert it to ASCII by adding '0'.
          dataArray[byteIndex++] = (byte) (message.dataLength + '0');
          dataArray[byteIndex++] = ' ';
          tempMessageID = intToHexASCIIArray(message.messageID);
          if (tempMessageID == null)
          {
            return ReturnCode.INVALID_MESSAGE_ID_VALUE;
          }
          for (int i = 0; i < tempMessageID.length; i++)
          {
            dataArray[byteIndex++] = tempMessageID[i];
          }
      }
      else
      {
        return ReturnCode.INVALID_FRAME_TYPE_VALUE;
      }

      // Send the string to Bluetooth.
      return writeArrayToBluetooth(dataArray, byteIndex);
    }
    // End of CANblue specific methods ----------------------------------------

    /**
     * Constructor of the CANController class.
     * @param inputListIndex Input: The listIndex of {@link Driver#intDeviceList}
     *     value.
     * @return {@link CANController} object or null if it is already created.
     */
    public CANController createCANControllerObject(byte inputListIndex)
    {

      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return null;
      }

      if ((inputListIndex > intDeviceList.numberOfController) || (inputListIndex < 0))
      {
        return null;  // Empty index.
      }

      if (intDeviceList.deviceIndex[inputListIndex] != 
    		  intDeviceList.deviceIndex[listIndex])
      {
        // The index used is different than the created device.
        return null;
      }

      if ((intDeviceList.controllerObjectStatus[inputListIndex] ==
          ConnectionStatus.INSTANCE_NOT_CREATED) &&
          (intDeviceList.deviceObjectStatus[inputListIndex] ==
          ConnectionStatus.INSTANCE_CREATED) &&
          (intDeviceList.deviceIndex[inputListIndex] == deviceIndex))
      {
        intDeviceList.controllerObjectStatus[inputListIndex] =
            ConnectionStatus.INSTANCE_CREATED;
        return new CANController(inputListIndex);
      }
      else
      {
        return null;
      }
    }

// The class of CANController -------------------------------------------------
    /**
     * Subclass CANController.
     * @author hroesdiyono
     * @see API_ADK.Device.Controller
     */
    public class CANController
    {
      /**
       * Private constructor, can only be called from inside the class.
       * It initializes internal variables and objects.
       * When used with {@link API_ADK}, it is created automatically at the 
       * creation of {@link API_ADK.Device.Controller} object.
       * @param inputListIndex Input: The listIndex of {@link Driver#intDeviceList}
       *     value.
       */
      private CANController(byte inputListIndex)
      {
        // Copy the device index and list index.
        controllerIndex = intDeviceList.controllerIndex[inputListIndex];
        listIndex = inputListIndex;
      }

      /** Internal index. */
      private byte controllerIndex, listIndex;

      /** Internal initialization status to make sure the object of this class 
       * has been initialize before using it and could not be used anymore 
       * after deinitializing it. */
      private ReturnCode controllerStatus = ReturnCode.OBJECT_IS_NOT_INITIALIZED;

      /**
       * Open a connection to the controller.
       * For CANblue or CANblue II, do nothing since the connection to the 
       * device is the same as the controller.
       * This is the beginning of the initialization sequence, after this 
       * method call directly{@link CANController#initializeControllerBaudrate(int)} 
       * or {@link CANController#initializeControllerBaudrate()}, 
       * {@link CANController#initializeReceiveFilter}, and read the controller 
       * status {@link CANController#readStatus} to fill the controllerStatus of 
       * {@link Driver#intDeviceList} automatically.
       * The sequence can only be called once.
       * @return {@link ReturnCode#OBJECT_IS_DEINITIALIZED}, 
       *         {@link ReturnCode#OBJECT_IS_INITIALIZED}, or 
       *         {@link ReturnCode#SUCCESS}.
       */
      public ReturnCode connectController()
      {
        if (controllerStatus == ReturnCode.OBJECT_IS_DEINITIALIZED)
    	  {
    		  // It is already deinitialized, can not be used anymore.
    		  return controllerStatus;
    	  }

        // The object is initialized if only the initialization sequence 
        // (connect to the controller, initialize baudrate and receive filter) 
        // is success. It can only be intialized once.
        if (controllerStatus == ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return controllerStatus;
        }

        return ReturnCode.SUCCESS;
      }

      /**
       * Close a connection from a controller.
       * Can not close the connection if any message channel is still 
       * using the controller.
       * @return {@link ReturnCode#SUCCESS} or 
       *         {@link ReturnCode#MESSAGE_CHANNEL_STILL_USING_CONTROLLER}.
       */
      public ReturnCode disconnectController()
      {
        if (controllerStatus == ReturnCode.OBJECT_IS_DEINITIALIZED)
        {
          // It is already deinitialized.
          return ReturnCode.SUCCESS;
        }

        // Check the number of message channel.
        if (intDeviceList.numberOfMessageChannel[listIndex] != 0)
        {
          return ReturnCode.MESSAGE_CHANNEL_STILL_USING_CONTROLLER;
        }

        // Change the connection status.
        intDeviceList.controllerObjectStatus[listIndex] =
            ConnectionStatus.INSTANCE_NOT_CREATED;

        controllerStatus = ReturnCode.OBJECT_IS_DEINITIALIZED;
        return ReturnCode.SUCCESS;
      }

      /**
       * Initialize the baudrate manually with the high Bus Coupling.
       * @param baudrate Input: The value of baudrate (10 - 1000).
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#INVALID_RESPONSE}, 
       *         {@link ReturnCode#INVALID_BAUDRATE_VALUE},
       *         {@link ReturnCode#INVALID_BUS_COUPLING}, 
       *         {@link ReturnCode#BAUDRATE_NOT_SUPPORTED}, 
       *         {@link ReturnCode#FAIL_INITIALIZING_CONTROLLER}, 
       *         {@link ReturnCode#BUS_COUPLING_NOT_SUPPORTED}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode initializeControllerBaudrate(int baudrate)
      {
        // Can only be used if the controller is not initialized.
        if (controllerStatus != ReturnCode.OBJECT_IS_NOT_INITIALIZED)
        {
          return controllerStatus;
        }

        // Use High Buscoupling as default.
        return setCANblueBaudrateManual(baudrate, HIGH_BUSCOUPLING);
      }

      /**
       * Determine the baudrate of the CAN network with the high 
       * Bus Coupling (and 5s for each supported baudrate) and use it 
       * as the baudrate of the controller.
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#INVALID_RESPONSE}, 
       *         {@link ReturnCode#INVALID_TIMEOUT_VALUE},
       *         {@link ReturnCode#INVALID_BUS_COUPLING}, 
       *         {@link ReturnCode#NO_BAUDRATE_DETECTED}, 
       *         {@link ReturnCode#BUS_COUPLING_NOT_SUPPORTED}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode initializeControllerBaudrate()
      {
        // Can only be used if the controller is not initialized.
        if (controllerStatus != ReturnCode.OBJECT_IS_NOT_INITIALIZED)
        {
          return controllerStatus;
        }

        // Use High Buscoupling as default, and default Timeout value 5.
        return setCANblueBaudrateAuto(1, HIGH_BUSCOUPLING);
      }

      /**
       * Use the device default setting to clear and disable the receive 
       * filter of the device, and set the active filter list (Hardware or 
       * Software filter).
       * @param receiveFilterType Input: The value of frame format 
       *     ({@link ConstantList#HARDWARE_FILTER}, or 
       *     {@link ConstantList#SOFTWARE_FILTER}).
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED}
       *         {@link ReturnCode#INVALID_FILTER_TYPE}, or 
       *         {@link ReturnCode#FAIL_USING_SETTINGS_DEFAULT}.
       */
      public ReturnCode initializeReceiveFilter(byte receiveFilterType)
      {
        // Can only be used if the controller is not initialized.
        if (controllerStatus != ReturnCode.OBJECT_IS_NOT_INITIALIZED)
        {
          return controllerStatus;
        }

        returnCode = setCANblueDefaultSetting();
        if (returnCode != ReturnCode.SUCCESS)
        {
          return ReturnCode.FAIL_USING_SETTINGS_DEFAULT;
        }

        // Set the active filter list, Hardware or Software filter.
        if ((receiveFilterType != HARDWARE_FILTER) &&
            (receiveFilterType != SOFTWARE_FILTER))
        {
          return ReturnCode.INVALID_FILTER_TYPE;
        }
        else
        {
          intDeviceList.receiveFilterType[listIndex] = receiveFilterType;
        }

        // The object is initialized if only the initialization sequence 
        // (connect to the controller, initialize baudrate and receive filter) 
        // is success .
        controllerStatus = ReturnCode.OBJECT_IS_INITIALIZED;
        return ReturnCode.SUCCESS;
      }

      /**
       * Read the status of the Controller. Call 
       * {@link CANDevice#readErrorStatus} instead.
       * @param status Output: The status of the CAN controller.
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#INVALID_RESPONSE}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode readStatus(CANInfo status)
      {
        // Can not be used if the controller object is not initialized.
        if (controllerStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return controllerStatus;
        }

        // Check the validity of the input.
        if (status == null)
        {
          return ReturnCode.CANINFO_OBJECT_NOT_VALID;
        }
        return readCANblueControllerInfo(status);
      }

      /**
       * Enable or disable the listen mode of the CAN controller.
       * The enabled listen mode supports both ASCII and binary.
       * @param mode Input: The value of mode 
       *     ({@link ConstantList#SEND_FRAME_OFF}, 
       *     {@link ConstantList#SEND_FRAME_ASCII}, or 
       *     {@link ConstantList#SEND_FRAME_BINARY}).
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#INVALID_RESPONSE}, 
       *         {@link ReturnCode#COMMAND_NOT_SUPPORTED},
       *         {@link ReturnCode#INVALID_INPUT_MODE}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode enableListenMode(byte mode)
      {
        // Can not be used if the controller object is not initialized.
        if (controllerStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return controllerStatus;
        }

        return setCANblueSendCANFrames(mode);
      }

      /**
       * Start the CAN Controller.
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#INVALID_RESPONSE}, 
       *         {@link ReturnCode#FAIL_STARTING_CONTROLLER}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode startCANController()
      {
        // Can not be used if the controller object is not initialized.
        if (controllerStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return controllerStatus;
        }

        ReturnCode returnCode;
        returnCode = startCANblueController();
        if (returnCode != ReturnCode.SUCCESS)
        {
        	return returnCode;
        }
        else
        {
        	intDeviceList.controllerStatus[listIndex] = 
        			ControllerStatus.CONTROLLER_START;
        	return ReturnCode.SUCCESS;
        }
      }

      /**
       * Stop the CAN Controller.
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#INVALID_RESPONSE}, 
       *         {@link ReturnCode#FAIL_STOPPING_CONTROLLER}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode stopCANController()
      {
        // Can not be used if the controller object is not initialized.
        if (controllerStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return controllerStatus;
        }

        ReturnCode returnCode;
        returnCode = stopCANblueController();
        if (returnCode != ReturnCode.SUCCESS)
        {
        	return returnCode;
        }
        else
        {
        	intDeviceList.controllerStatus[listIndex] = 
        			ControllerStatus.CONTROLLER_STOP;
        	return ReturnCode.SUCCESS;
        }
      }

      /**
       * Transmit a message to the controller.
       * There are 2 message formats, ASCII and binary. Binary format is 
       * shorter than the ASCII format, so it takes less time and increase 
       * data rate. 
       * This method is optimized for fast and repetitive sending message for 
       * more than 1 message in the interval of 5ms.
       * Note that sending any message will change the receive message format 
       * to the same format as the sending message.
       * Read the error status to check whether there is an error in sending 
       * the message.
       * @param message       Input: Message to be sent.
       * @param messageFormat Input: ({@link ConstantList#ASCII_FORMAT}, or 
       *     {@link ConstantList#BINARY_FORMAT})
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
       *         {@link ReturnCode#INVALID_MESSAGE_FORMAT},
       *         {@link ReturnCode#INVALID_MESSAGE_ID_VALUE},
       *         {@link ReturnCode#INVALID_FRAME_FORMAT_VALUE}, 
       *         {@link ReturnCode#INVALID_DATA_LENGTH}, 
       *         {@link ReturnCode#INVALID_DATA_VALUE}, 
       *         {@link ReturnCode#INVALID_FRAME_TYPE_VALUE}, 
       *         {@link ReturnCode#EXCEPTION_SEMAPHORE_ACQUIRE}, 
       *         {@link ReturnCode#EXCEPTION_SEMAPHORE_RELEASE}, 
       *         {@link ReturnCode#WAITING_TO_SEND_TIMEOUT}, or 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}.
       */
      public ReturnCode transmitMessage(MessageStructure message, 
    		  byte messageFormat)
      {
        // Can not be used if the controller object is not initialized.
        if (controllerStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return controllerStatus;
        }

    	  if (messageFormat == ASCII_FORMAT)
    	  {
    		  return PutCANblueASCIIMessage(message);
    	  }
    	  else if (messageFormat == BINARY_FORMAT)
    	  {
    		  return PutCANblueBinaryMessage(message);
    	  }
    	  else
    	  {
    		  return ReturnCode.INVALID_MESSAGE_FORMAT;
    	  }
      }
    }

    /**
     * Constructor of the CANMessage class.
     * The limitation of the object creation is 1 if the Hardware filter is 
     * used, and 128 if the Software filter is used.
     * The controller should be stopped before creating MessageChannel object.
     * @param inputListIndex Input: The listIndex of {@link Driver#intDeviceList}
     *     value.
     * @return {@link CANMessage} object or null if the input is wrong or 
     *     the number of the object is more than the limitation.
     */
    public CANMessage createCANMessageObject(byte inputListIndex)
    {
      // Can not be used if the device object is not initialized.
      if (deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
      {
        return null;
      }

      if ((inputListIndex > intDeviceList.numberOfController) || (inputListIndex < 0))
      {
        return null;  // Empty index.
      }

      if (intDeviceList.deviceIndex[inputListIndex] != 
          intDeviceList.deviceIndex[listIndex])
      {
        // The index used is different than the created device.
        return null;
      }

      // Check the type of the receive filter type and number of message channel.
      if ((intDeviceList.receiveFilterType[inputListIndex] == HARDWARE_FILTER)
          && (intDeviceList.numberOfMessageChannel[inputListIndex] >=
          HARDWARE_CHANNEL_LIMITATION))
      {
        return null;
      }
      else if ((intDeviceList.receiveFilterType[inputListIndex] == 
          SOFTWARE_FILTER) &&
          (intDeviceList.numberOfMessageChannel[inputListIndex] >=
          MAXIMUM_BYTE_SIZE))
      {
        return null;
      }

      // The object of the controller should be created before creating
      // an object for the message channel and the controller is stop.
      if ((intDeviceList.controllerObjectStatus[inputListIndex] ==
          ConnectionStatus.INSTANCE_CREATED) &&
          (intDeviceList.controllerStatus[inputListIndex] ==
          ControllerStatus.CONTROLLER_STOP) &&
          (intDeviceList.deviceIndex[inputListIndex] == deviceIndex))
      {
        // Increase the number of message channel.
        intDeviceList.numberOfMessageChannel[inputListIndex]++;
        // Since the index starts from 0, the index is 1 less than the
        // number of message channel.
        byte intMessageIndex =
            (byte) (intDeviceList.numberOfMessageChannel[inputListIndex] - 1);
        CANMessage temptCANMessage = new CANMessage(inputListIndex,
            intMessageIndex); 
        if (intCANMessage == null)
        {
          // Create internal CANMessage instance for filtering.
          intCANMessage = new CANMessage[1];
        }
        else
        {
          // Increase the size of the internal CANMessage instance.
          intCANMessage = (CANMessage[])resizeArray(intCANMessage,
              intDeviceList.numberOfMessageChannel[inputListIndex]);
        }
        intCANMessage[intMessageIndex] = temptCANMessage;
        return temptCANMessage;
      }
      else
      {
        return null;
      }
    }

// The class of CANMessage ----------------------------------------------------
    /**
     * Subclass CANMessage.
     * It can only be used if the Controller object has been created. 
     * {@link CANMessage#initializeCANMessage}, 
     * {@link CANMessage#deinitializeCANMessage}, 
     * {@link CANMessage#clearFilter}, 
     * {@link CANMessage#addFilter}, 
     * {@link CANMessage#removeFilter}, and 
     * {@link CANMessage#setFilter} can not be used if the controller is 
     * started. It could produce an error if the controller is receiving 
     * message while the message channel and filter configuration are changed. 
     * @author hroesdiyono
     * @see API_ADK.Device.MessageChannel
     */
    public class CANMessage
    {
      /**
       * Private constructor, can only be called from inside the class.
       * It initializes internal variables and objects.
       * When used with {@link API_ADK}, it is created automatically at the 
       * creation of {@link API_ADK.Device.MessageChannel} object.
       * @param inputListIndex    Input: The listIndex of {@link Driver#intDeviceList}
       *     value.
       * @param inputMessageIndex Input: Assign the index for each message 
       *     channel. This index is used internally.
       */
      private CANMessage(byte inputListIndex, byte inputMessageIndex)
      {
        // Copy the message index, device index and list index.
        controllerIndex = intDeviceList.controllerIndex[inputListIndex];
        messageIndex = inputMessageIndex;
        listIndex = inputListIndex;
        intReceiveBuffer = new ReceiveBuffer();
        // Initialize the software filter.
        stdReceiveFilter = new FilterList(STD_FILTER_LENGTH);
        extReceiveFilter = new FilterList(EXT_FILTER_LENGTH);
      }

      /** Internal index. */
      private byte controllerIndex, messageIndex, listIndex;

      /** Internal initialization status to make sure the object of this class 
       * has been initialize before using it and could not be used anymore 
       * after deinitializing it. */
      private ReturnCode messageChannelStatus = ReturnCode.OBJECT_IS_NOT_INITIALIZED;

      /** The internal structure of software STD filter. */
      private FilterList stdReceiveFilter;
      /** The length of the STD filter. */
      private final int STD_FILTER_LENGTH = MAXIMUM_FILTER_LENGTH;
      /** The internal structure of software EXT filter. */
      private FilterList extReceiveFilter;
      /** The length of the STD filter. */
      private final int EXT_FILTER_LENGTH = MAXIMUM_FILTER_LENGTH;
      /** A receive buffer for each message channel. */
      private ReceiveBuffer intReceiveBuffer;

      /**
       * Initialize the receive filter and message buffer.
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#CONTROLLER_IS_STARTED}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED}, or 
       *         {@link ReturnCode#INVALID_FILTER_TYPE}.
       */
      public ReturnCode initializeCANMessage()
      {
        if (intDeviceList.controllerStatus[listIndex] !=
            ControllerStatus.CONTROLLER_STOP)
        {
          return ReturnCode.CONTROLLER_IS_STARTED;
        }
        // Can not be initialized anymore if it has been deinitialized.
        if (messageChannelStatus == ReturnCode.OBJECT_IS_DEINITIALIZED)
        {
          return messageChannelStatus;
        }
        else if (messageChannelStatus == ReturnCode.OBJECT_IS_INITIALIZED)
        {
            return ReturnCode.SUCCESS;
        }

        if (intDeviceList.receiveFilterType[listIndex] == HARDWARE_FILTER)
        {
          messageChannelStatus = ReturnCode.OBJECT_IS_INITIALIZED;
          // Deinitialize the software filter.
          stdReceiveFilter = null;
          extReceiveFilter = null;
          return ReturnCode.SUCCESS;
        }
        else if (intDeviceList.receiveFilterType[listIndex] == SOFTWARE_FILTER)
        {
          messageChannelStatus = ReturnCode.OBJECT_IS_INITIALIZED;
          // The software filter is already initialized inside the constructor.
          return ReturnCode.SUCCESS;
        }
        else
        {
          return ReturnCode.INVALID_FILTER_TYPE;
        }
      }

      /**
       * Deinitialize the message object.
       * Reduce the number of message channel and unreference the internal 
       * filter and receive buffer.
       * @return {@link ReturnCode#SUCCESS} or 
       *         {@link ReturnCode#CONTROLLER_IS_STARTED}.
       */
      public ReturnCode deinitializeCANMessage()
      {
        if (intDeviceList.controllerStatus[listIndex] !=
            ControllerStatus.CONTROLLER_STOP)
        {
          return ReturnCode.CONTROLLER_IS_STARTED;
        }

        // If it has been deinitialized, do nothing.
        if (messageChannelStatus == ReturnCode.OBJECT_IS_DEINITIALIZED)
        {
          return ReturnCode.SUCCESS;
        }

        stdReceiveFilter = null;
        extReceiveFilter = null;
        intReceiveBuffer = null;

        // If there is no CANMessage, return success immediately.
        if (intDeviceList.numberOfMessageChannel[listIndex] == 0)
        {
        	return ReturnCode.SUCCESS;
        }
        // Decrease the size of the internal CANMessage instance.
        // Shift the array after the message index and the
        // reduce the array size.
        for (byte i = messageIndex; i <
            intDeviceList.numberOfMessageChannel[listIndex] - 1; i++)
        {
          intCANMessage[i] = intCANMessage[i + 1];
          intCANMessage[i].messageIndex = i;
        }
        intCANMessage[intDeviceList.numberOfMessageChannel[listIndex] - 1] = null;

        intDeviceList.numberOfMessageChannel[listIndex]--;
        messageChannelStatus = ReturnCode.OBJECT_IS_DEINITIALIZED;
        return ReturnCode.SUCCESS;
      }

      /**
       * Clear the receive filter of active filter.
       * @param frameFormat Input: The value of frame format 
       *     ({@link ConstantList#STANDARD_FRAME}, or 
       *     {@link ConstantList#EXTENDED_FRAME}).
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#CONTROLLER_IS_STARTED}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED}, 
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#INVALID_FILTER_TYPE}, 
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#INVALID_RESPONSE}, 
       *         {@link ReturnCode#INVALID_FRAME_FORMAT_VALUE},
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode clearFilter(byte frameFormat)
      {
        if (intDeviceList.controllerStatus[listIndex] !=
            ControllerStatus.CONTROLLER_STOP)
        {
          return ReturnCode.CONTROLLER_IS_STARTED;
        }

        // Can not be used if the message channel is not initialized.
        if (messageChannelStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return messageChannelStatus;
        }

        // Check the validity of the input.
        if ((frameFormat != STANDARD_FRAME) &&
            (frameFormat != EXTENDED_FRAME))
        {
          return ReturnCode.INVALID_FRAME_FORMAT_VALUE;
        }

        if (intDeviceList.receiveFilterType[listIndex] == HARDWARE_FILTER)
        {
          return clearCANblueFilter(frameFormat);
        }
        else if (intDeviceList.receiveFilterType[listIndex] == SOFTWARE_FILTER)
        {
          // Clear Filter for software.
          if (frameFormat == STANDARD_FRAME)
          {
            stdReceiveFilter.clearFilterList();
          }
          else if (frameFormat == EXTENDED_FRAME)
          {
            extReceiveFilter.clearFilterList();
          }
          return ReturnCode.SUCCESS;
        }
        else
        {
          return ReturnCode.INVALID_FILTER_TYPE;
        }
      }

      /**
       * Add an ID to the receive filter of active filter.
       * @param frameFormat Input: The value of frame format 
       *     ({@link ConstantList#STANDARD_FRAME}, or 
       *     {@link ConstantList#EXTENDED_FRAME}).
       * @param messageID   Input: The value of message ID (0 - 0x7FF for 
       *     Standard frame and 0 - 0x1FFFFFFF for Extended frame).
       * @param frameType Input: The value of frame type 
       *     ({@link ConstantList#DATA_FRAME}, or 
       *     {@link ConstantList#REMOTE_FRAME}).
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#CONTROLLER_IS_STARTED}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED}, 
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#INVALID_MESSAGE_ID_VALUE}, 
       *         {@link ReturnCode#INVALID_FRAME_FORMAT_VALUE}, 
       *         {@link ReturnCode#INVALID_FRAME_TYPE_VALUE}, 
       *         {@link ReturnCode#INVALID_FILTER_TYPE}, 
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#INVALID_RESPONSE}, 
       *         {@link ReturnCode#FAIL_ADDING_ID_TO_FILTER}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode addFilter(byte frameFormat, 
          int messageID, byte frameType)
      {
        if (intDeviceList.controllerStatus[listIndex] !=
            ControllerStatus.CONTROLLER_STOP)
        {
          return ReturnCode.CONTROLLER_IS_STARTED;
        }

        // Can not be used if the message channel is not initialized.
        if (messageChannelStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return messageChannelStatus;
        }

        // Check the validity of the input.
        if (frameFormat == STANDARD_FRAME)
        {
          if ((messageID > 0x7FF) || (messageID < 0))
          {
            return ReturnCode.INVALID_MESSAGE_ID_VALUE;
          }
        }
        else if (frameFormat == EXTENDED_FRAME)
        {
          if ((messageID > 0x1FFFFFFFL) || (messageID < 0))
          {
            return ReturnCode.INVALID_MESSAGE_ID_VALUE;
          }
        }
        else
        {
          return ReturnCode.INVALID_FRAME_FORMAT_VALUE;
        }

        if ((frameType != DATA_FRAME) && (frameType != REMOTE_FRAME))
        {
          return ReturnCode.INVALID_FRAME_TYPE_VALUE;
        }

        if (intDeviceList.receiveFilterType[listIndex] == HARDWARE_FILTER)
        {
          return addCANblueFilter(frameFormat, messageID, frameType);
        }
        else if (intDeviceList.receiveFilterType[listIndex] == SOFTWARE_FILTER)
        {
          // Add Filter for software.
          // Since the frameType of the FilterlList contains
          // both Data and Remote frames informations, it
          // should be masked before storing.
          if (frameFormat == STANDARD_FRAME)
          {
            // If the list is empty, add it directly.
            if (stdReceiveFilter.numberOfFilter == 0)
            {
              stdReceiveFilter.messageID[stdReceiveFilter.numberOfFilter] =
                  messageID;
              stdReceiveFilter.frameType[stdReceiveFilter.numberOfFilter] =
                  frameType;
              stdReceiveFilter.numberOfFilter++;
              return ReturnCode.SUCCESS;
            }

            // Check whether the ID is already added.
            for (int i = 0; i < stdReceiveFilter.numberOfFilter; i++)
            {
              if (stdReceiveFilter.messageID[i] == messageID)
              {
                if ((stdReceiveFilter.frameType[i] & frameType) == frameType)
                {
                  return ReturnCode.SUCCESS;
                }
                else
                {
                  stdReceiveFilter.frameType[i] |= frameType;
                  return ReturnCode.SUCCESS;
                }
              }
            }

            // Check whether the filter is full.
            if (stdReceiveFilter.numberOfFilter == STD_FILTER_LENGTH)
            {
            	return ReturnCode.FAIL_ADDING_ID_TO_FILTER;
            }
            // If it is not on the list, add the ID.
            stdReceiveFilter.messageID[stdReceiveFilter.numberOfFilter] =
                messageID;
            stdReceiveFilter.frameType[stdReceiveFilter.numberOfFilter] =
                frameType;
            stdReceiveFilter.numberOfFilter++;
          }
          else if (frameFormat == EXTENDED_FRAME)
          {
            // If the list is empty, add it directly.
            if (extReceiveFilter.numberOfFilter == 0)
            {
            	extReceiveFilter.messageID[extReceiveFilter.numberOfFilter] =
                  messageID;
            	extReceiveFilter.frameType[extReceiveFilter.numberOfFilter] =
                  frameType;
            	extReceiveFilter.numberOfFilter++;
              return ReturnCode.SUCCESS;
            }

            // Check whether the ID is already added.
            for (int i = 0; i < extReceiveFilter.numberOfFilter; i++)
            {
              if (extReceiveFilter.messageID[i] == messageID)
              {
                if ((extReceiveFilter.frameType[i] & frameType) == frameType)
                {
                  return ReturnCode.SUCCESS;
                }
                else
                {
                  extReceiveFilter.frameType[i] |= frameType;
                  return ReturnCode.SUCCESS;
                }
              }
            }

            // Check whether the filter is full.
            if (extReceiveFilter.numberOfFilter == EXT_FILTER_LENGTH)
            {
            	return ReturnCode.FAIL_ADDING_ID_TO_FILTER;
            }
            // If it is not on the list, add the ID.
            extReceiveFilter.messageID[extReceiveFilter.numberOfFilter] =
                messageID;
            extReceiveFilter.frameType[extReceiveFilter.numberOfFilter] =
                frameType;
            extReceiveFilter.numberOfFilter++;
          }
          return ReturnCode.SUCCESS;
        }
        else
        {
          return ReturnCode.INVALID_FILTER_TYPE;
        }
      }

      /**
       * Remove an ID from the receive filter of active filter.
       * @param frameFormat Input: The value of frame format 
       *     ({@link ConstantList#STANDARD_FRAME}, or 
       *     {@link ConstantList#EXTENDED_FRAME}).
       * @param messageID Input: The value of message ID (0 - 0x7FF for 
       *     Standard frame and 0 - 0x1FFFFFFF for Extended frame).
       * @param frameType Input: The value of frame type 
       *     ({@link ConstantList#DATA_FRAME}, or 
       *     {@link ConstantList#REMOTE_FRAME}).
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#CONTROLLER_IS_STARTED}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED}, 
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#INVALID_MESSAGE_ID_VALUE}, 
       *         {@link ReturnCode#INVALID_FRAME_FORMAT_VALUE}, 
       *         {@link ReturnCode#INVALID_FRAME_TYPE_VALUE}, 
       *         {@link ReturnCode#INVALID_FILTER_TYPE}, 
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#INVALID_RESPONSE}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode removeFilter(byte frameFormat, 
          int messageID, byte frameType)
      {
        if (intDeviceList.controllerStatus[listIndex] !=
            ControllerStatus.CONTROLLER_STOP)
        {
          return ReturnCode.CONTROLLER_IS_STARTED;
        }

        // Can not be used if the message channel is not initialized.
        if (messageChannelStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return messageChannelStatus;
        }
        // Check the validity of the input.
        if (frameFormat == STANDARD_FRAME)
        {
          if ((messageID > 0x7FF) || (messageID < 0))
          {
            return ReturnCode.INVALID_MESSAGE_ID_VALUE;
          }
        }
        else if (frameFormat == EXTENDED_FRAME)
        {
          if ((messageID > 0x1FFFFFFFL) || (messageID < 0))
          {
            return ReturnCode.INVALID_MESSAGE_ID_VALUE;
          }
        }
        else
        {
          return ReturnCode.INVALID_FRAME_FORMAT_VALUE;
        }

        if ((frameType != DATA_FRAME) && (frameType != REMOTE_FRAME))
        {
          return ReturnCode.INVALID_FRAME_TYPE_VALUE;
        }

        if (intDeviceList.receiveFilterType[listIndex] == HARDWARE_FILTER)
        {
          return removeCANblueFilter(frameFormat, messageID, frameType);
        }
        else if (intDeviceList.receiveFilterType[listIndex] == SOFTWARE_FILTER)
        {
          // Remove Filter for software.
          if (frameFormat == STANDARD_FRAME)
          {
            // If the list is empty, return immediately.
            if (stdReceiveFilter.numberOfFilter == 0)
            {
              return ReturnCode.SUCCESS;
            }

            // Check whether the ID is listed.
            for (int i = 0; i < stdReceiveFilter. numberOfFilter; i++)
            {
              if (stdReceiveFilter.messageID[i] == messageID)
              {
                if ((stdReceiveFilter.frameType[i] & frameType) != frameType)
                {
                  // Not the same frame type.
                  return ReturnCode.SUCCESS;
                }
                else if (stdReceiveFilter.frameType[i] != frameType)
                {
				  // Contains other frame type. Just change the frame type.
                  stdReceiveFilter.frameType[i] =
                      (byte) (stdReceiveFilter.frameType[i] ^ frameType);
                  return ReturnCode.SUCCESS;
                }
                else
                {
				  // If the frameType in the filterList is the same as the
                  // input, remove the ID from the list.
                  if (stdReceiveFilter.numberOfFilter == 1)
                  {
                    // If the number of filter is only 1, simply remove it.
                    stdReceiveFilter.messageID[0] = -1;
                    stdReceiveFilter.frameType[0] = -1;
                  }
                  else
                  {
                    // Shift the data array after the removed ID and the
                    // Reduce the filter size.
                    for (int j = i; j <stdReceiveFilter.numberOfFilter - 1;
                        j++)
                    {
                      stdReceiveFilter.messageID[j] =
                          stdReceiveFilter.messageID[j + 1];
                      stdReceiveFilter.frameType[j] =
                          stdReceiveFilter.frameType[j + 1];
                    }
                    stdReceiveFilter.messageID[stdReceiveFilter.numberOfFilter - 1] = -1;
                    stdReceiveFilter.frameType[stdReceiveFilter.numberOfFilter - 1] = -1;
                  }
                  // Reduce the number of filter.
                  stdReceiveFilter.numberOfFilter--;
                  return ReturnCode.SUCCESS;
                }
              }
            }
            // If it is not on the list, return Success.
            return ReturnCode.SUCCESS;
          }
          else if (frameFormat == EXTENDED_FRAME)
          {
            // If the list is empty, return immediately.
            if (extReceiveFilter.numberOfFilter == 0)
            {
              return ReturnCode.SUCCESS;
            }

            // Check whether the ID is listed.
            for (int i = 0; i < extReceiveFilter. numberOfFilter; i++)
            {
              if (extReceiveFilter.messageID[i] == messageID)
              {
                if ((extReceiveFilter.frameType[i] & frameType) != frameType)
                {
                  // Not the same frame type.
                  return ReturnCode.SUCCESS;
                }
                else if (extReceiveFilter.frameType[i] != frameType)
                {
				  // Contains other frame type. Just change the frame type.
                  extReceiveFilter.frameType[i] =
                      (byte) (extReceiveFilter.frameType[i] ^ frameType);
                  return ReturnCode.SUCCESS;
                }
                else
                {
				  // If the frameType in the filterList is the same as the
                  // input, remove the ID from the list.
                  if (extReceiveFilter.numberOfFilter == 1)
                  {
                    // If the number of filter is only 1, simply remove it.
                    extReceiveFilter.messageID[0] = -1;
                    extReceiveFilter.frameType[0] = -1;
                  }
                  else
                  {
                    // Shift the data array after the removed ID and the
                    // Reduce the filter size.
                    for (int j = i; j <extReceiveFilter.numberOfFilter - 1;
                        j++)
                    {
                      extReceiveFilter.messageID[j] =
                          extReceiveFilter.messageID[j + 1];
                      extReceiveFilter.frameType[j] =
                          extReceiveFilter.frameType[j + 1];
                    }
                    extReceiveFilter.messageID[extReceiveFilter.numberOfFilter - 1] = -1;
                    extReceiveFilter.frameType[extReceiveFilter.numberOfFilter - 1] = -1;
                  }
                  // Reduce the number of filter.
                  extReceiveFilter.numberOfFilter--;
                  return ReturnCode.SUCCESS;
                }
              }
            }
          }
          // If it is not on the list, return success.
          return ReturnCode.SUCCESS;
        }
        else
        {
          return ReturnCode.INVALID_FILTER_TYPE;
        }
      }

      /**
       * Enable or disable the receive filter of active filter.
       * @param frameFormat  Input: The value of frame type 
       *     ({@link ConstantList#DATA_FRAME}, or 
       *     {@link ConstantList#REMOTE_FRAME}).
       * @param enableFilter Input: True for enabling or 
       *     false for disabling the filter.
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#CONTROLLER_IS_STARTED}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED}, 
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#INVALID_FRAME_FORMAT_VALUE}, 
       *         {@link ReturnCode#INVALID_FILTER_TYPE}, 
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#INVALID_RESPONSE}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode setFilter(byte frameFormat, 
          boolean enableFilter)
      {
        if (intDeviceList.controllerStatus[listIndex] !=
            ControllerStatus.CONTROLLER_STOP)
        {
          return ReturnCode.CONTROLLER_IS_STARTED;
        }

        // Can not be used if the message channel is not initialized.
        if (messageChannelStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return messageChannelStatus;
        }

        // Check the validity of the input.
        if ((frameFormat != STANDARD_FRAME) && (frameFormat != EXTENDED_FRAME))
        {
          return ReturnCode.INVALID_FRAME_FORMAT_VALUE;
        }

        if (intDeviceList.receiveFilterType[listIndex] == HARDWARE_FILTER)
        {
          return setCANblueFilter(frameFormat, enableFilter);
        }
        else if (intDeviceList.receiveFilterType[listIndex] == SOFTWARE_FILTER)
        {
          // Set Filter for software
          if (frameFormat == STANDARD_FRAME)
          {
            if (enableFilter == true)
            {
              stdReceiveFilter.filterStatus = true;
            }
            else
            {
              stdReceiveFilter.filterStatus = false;
            }
          }
          else if (frameFormat == EXTENDED_FRAME)
          {
            if (enableFilter == true)
            {
              extReceiveFilter.filterStatus = true;
            }
            else
            {
              extReceiveFilter.filterStatus = false;
            }
          }
          return ReturnCode.SUCCESS;
        }
        else
        {
          return ReturnCode.INVALID_FILTER_TYPE;
        }
      }

      /**
       * Read the current status of the active receive filter.
       * The Hardware filter information is read using 
       * {@link Driver.CANDevice#readCANblueConfiguration}.
       * @param frameFormat Input: The value of frame format 
       *     ({@link ConstantList#STANDARD_FRAME}, or 
       *     {@link ConstantList#EXTENDED_FRAME}).
       * @param filterList  Output: The filter information.
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED}, 
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#INVALID_FRAME_FORMAT_VALUE}, 
       *         {@link ReturnCode#FAIL_READING_CONFIG}, 
       *         {@link ReturnCode#INVALID_FILTER_STATUS}, 
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#INVALID_RESPONSE}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode readFilterInformation(byte frameFormat,
          FilterList filterList)
      {
        // Can not be used if the message channel is not initialized.
        if (messageChannelStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return messageChannelStatus;
        }

    	  // Check the validity of the input.
        if (filterList == null)
        {
          return ReturnCode.FILTERLIST_OBJECT_NOT_VALID;
        }
        if ((frameFormat != STANDARD_FRAME) && (frameFormat != EXTENDED_FRAME))
        {
          return ReturnCode.INVALID_FRAME_FORMAT_VALUE;
        }

        if (intDeviceList.receiveFilterType[listIndex] == HARDWARE_FILTER)
        {
          // Read the filter information inside the CANblue config.
          CANblueConfiguration config = new CANblueConfiguration();

          returnCode = readCANblueConfiguration(config);
          if (returnCode != ReturnCode.SUCCESS)
          {
            return returnCode;
          }
          else if ((config.STDFilterStatus == null) ||
              (config.EXTFilterStatus == null) || (config.STDFilterStatus ==
              FilterStatus.UNKNOWN_STATUS) ||
              (config.EXTFilterStatus == FilterStatus.UNKNOWN_STATUS))
          {
            // No valid config data.
            return ReturnCode.FAIL_READING_CONFIG;
          }

          if (frameFormat == STANDARD_FRAME)
          {
            if (config.STDFilterStatus == FilterStatus.FILTER_ENABLED)
            {
              filterList.filterStatus = true;
            }
            else if (config.STDFilterStatus == FilterStatus.FILTER_DISABLED)
            {
              filterList.filterStatus = false;
            }
            else
            {
              return ReturnCode.INVALID_FILTER_STATUS;
            }

            filterList.numberOfFilter = config.STDFilterCount;

            if (filterList.numberOfFilter != 0)
            {
              filterList.frameType = new byte[filterList.numberOfFilter];
              filterList.messageID = new int[filterList.numberOfFilter];
              for (int i = 0; i < filterList.numberOfFilter; i++)
              {
                try
                {
                  foundIndex = config.STDFilterList[i].indexOf(", RTR");
                }
                catch (Exception e)
                {
                  e.printStackTrace();
                  return ReturnCode.FAIL_SEARCHING_STRING;
                }
                if (foundIndex == -1)
                {
                  // Filter contains DATA ID.
                  try
                  {
                    filterList.messageID[i] = Integer.valueOf(
                        config.STDFilterList[i]);
                  }
                  catch (Exception e)
                  {
                    e.printStackTrace();
                    // If string cannot be parsed as an integer value.
                    filterList.messageID[i] = -1;
                  }
                  filterList.frameType[i] = DATA_FRAME;
                }
                else
                {
                  // Filter contains RTR ID.
                  try
                  {
                    filterList.messageID[i] = Integer.valueOf(
                        config.STDFilterList[i].substring(0, foundIndex));
                  }
                  catch (Exception e)
                  {
                    e.printStackTrace();
                    // If string cannot be parsed as an integer value.
                    filterList.messageID[i] = -1;
                  }
                  filterList.frameType[i] = REMOTE_FRAME;
                }
              }
            }
            else
            {
              filterList.frameType = null;
              filterList.messageID = null;
            }
          }
          else if (frameFormat == EXTENDED_FRAME)
          {
            if (config.EXTFilterStatus == FilterStatus.FILTER_ENABLED)
            {
              filterList.filterStatus = true;
            }
            else if (config.EXTFilterStatus == FilterStatus.FILTER_DISABLED)
            {
              filterList.filterStatus = false;
            }
            else
            {
              return ReturnCode.INVALID_FILTER_STATUS;
            }

            filterList.numberOfFilter = config.EXTFilterCount;

            if (filterList.numberOfFilter != 0)
            {
              filterList.frameType = new byte[filterList.numberOfFilter];
              filterList.messageID = new int[filterList.numberOfFilter];
              for (int i = 0; i < filterList.numberOfFilter; i++)
              {
                try
                {
                  foundIndex = config.EXTFilterList[i].indexOf(", RTR");
                }
                catch (Exception e)
                {
                  e.printStackTrace();
                  return ReturnCode.FAIL_SEARCHING_STRING;
                }
                if (foundIndex == -1)
                {
                  // Filter contains DATA ID.
                  try
                  {
                    filterList.messageID[i] = Integer.valueOf(
                        config.EXTFilterList[i]);
                  }
                  catch (Exception e)
                  {
                    e.printStackTrace();
                    // If string cannot be parsed as an integer value.
                    filterList.messageID[i] = -1;
                  }
                  filterList.frameType[i] = DATA_FRAME;
                }
                else
                {
                  // Filter contains RTR ID.
                  try
                  {
                    filterList.messageID[i] = Integer.valueOf(
                        config.EXTFilterList[i].substring(0, foundIndex));
                  }
                  catch (Exception e)
                  {
                    e.printStackTrace();
                    // If string cannot be parsed as an
                    // integer value.
                    filterList.messageID[i] = -1;
                  }
                  filterList.frameType[i] = REMOTE_FRAME;
                }
              }
            }
            else
            {
              filterList.frameType = null;
              filterList.messageID = null;
            }
          }
          return ReturnCode.SUCCESS;
        }
        else if (intDeviceList.receiveFilterType[listIndex] == SOFTWARE_FILTER)
        {
          // Read the Software Filter information.
          if (frameFormat == STANDARD_FRAME)
          {
            filterList.filterStatus = stdReceiveFilter.filterStatus;
            filterList.numberOfFilter = stdReceiveFilter.numberOfFilter;
            if (filterList.numberOfFilter != 0)
            {
              filterList.frameType = new byte[filterList.numberOfFilter];
              filterList.messageID = new int[filterList.numberOfFilter];
              for (int i = 0; i < filterList.numberOfFilter; i++)
              {
                filterList.frameType[i] = stdReceiveFilter.frameType[i];
                filterList.messageID[i] = stdReceiveFilter.messageID[i];
              }
            }
            else
            {
              filterList.frameType = null;
              filterList.messageID = null;
            }
          }
          else if (frameFormat == EXTENDED_FRAME)
          {
            filterList.filterStatus = extReceiveFilter.filterStatus;
            filterList.numberOfFilter = extReceiveFilter.numberOfFilter;
            if (filterList.numberOfFilter != 0)
            {
              filterList.frameType = new byte[filterList.numberOfFilter];
              filterList.messageID = new int[filterList.numberOfFilter];
              for (int i = 0; i < filterList.numberOfFilter; i++)
              {
                filterList.frameType[i] = extReceiveFilter.frameType[i];
                filterList.messageID[i] = extReceiveFilter.messageID[i];
              }
            }
            else
            {
              filterList.frameType = null;
              filterList.messageID = null;
            }
          }
          return ReturnCode.SUCCESS;
        }
        else
        {
          return ReturnCode.INVALID_FILTER_TYPE;
        }
      }

      /**
       * Take a message from the message buffer.
       * @param receivedMessage Output: Message receive.
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED}, 
       *         {@link ReturnCode#RECEIVE_BUFFER_EMPTY}, 
       *         {@link ReturnCode#EXCEPTION_SEMAPHORE_ACQUIRE}, or 
       *         {@link ReturnCode#EXCEPTION_SEMAPHORE_RELEASE}.
       */
      public ReturnCode receiveMessage(MessageStructure receivedMessage)
      {
        // Can not be used if the message channel is not initialized.
        if (messageChannelStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return messageChannelStatus;
        }

    	  // Check the validity of the input.
        if (receivedMessage == null)
        {
          return ReturnCode.MESSAGESTRUCTURE_OBJECT_NOT_VALID;
        }
        return intReceiveBuffer.queueGet(receivedMessage);
      }

      /**
       * Determine the bus load.
       * This method is not implemented.
       * @param busLoad Output: The current Busload.
       * @return {@link ReturnCode#SUCCESS},
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED}, or
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED}.
       */
      public ReturnCode determineBusLoad(int busLoad)
      {
        // Can not be used if the message channel is not initialized.
        if (messageChannelStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return messageChannelStatus;
        }
        return ReturnCode.SUCCESS;
      }

      /**
       * Return the status of the receive message buffer and reset it.
       * @return {@link ReturnCode#RECEIVE_BUFFER_NO_STATUS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED}, 
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED}, or 
       *         {@link ReturnCode#RECEIVE_BUFFER_OVERRUN}.
       */
      public ReturnCode receiveBufferStatus()
      {

        // Can not be used if the message channel is not initialized.
        if (messageChannelStatus != ReturnCode.OBJECT_IS_INITIALIZED)
        {
          return messageChannelStatus;
        }

        ReturnCode returnCode;
        returnCode = intReceiveBuffer.receiveBufferStatus;

        intReceiveBuffer.receiveBufferStatus =
            ReturnCode.RECEIVE_BUFFER_NO_STATUS;
        return returnCode;
      }
    }
  }
}