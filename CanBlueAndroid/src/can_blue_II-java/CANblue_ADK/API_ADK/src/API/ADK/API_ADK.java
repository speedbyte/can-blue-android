package API.ADK;

//The class of API_ADK --------------------------------------------------------
/**
 * This class implements all the functionalities of the ADK and should be 
 * called by an application that wants to connect and communicate with a 
 * CAN device. Call {@link API_ADK#createAPI_ADKObject} to create the object of this 
 * class and then call {@link API_ADK#initializeADK} to initialize the 
 * class. This class uses {@link Driver} class and its subclasses internally.
 * @author hroesdiyono
 */
public class API_ADK implements ConstantList
{
  /** Keep the number of object for this class. */
  private static byte numberOfObject = 0;

  /** Private constructor, can only be called from inside the class. */
  private API_ADK()
  {
    // Initialize the driver object.
    driver = Driver.createDriverObject();
    // Initialize the internal device list.
    intDeviceList = new DeviceList();
  }

  /**
   * Call this method to create this class object.
   * The object can only be created once. Call {@link API_ADK#initializeADK} directly 
   * after this method to be able to use this class. Note that after calling 
   * {@link API_ADK#deinitializeADK}, the object becomes unusable and a new object can 
   * be created again.
   * @return {@link API_ADK} object or null if the object creation fails.
   */
  public static synchronized API_ADK createAPI_ADKObject()
  {
    if (numberOfObject == 0)
    {
      numberOfObject++;
      return new API_ADK();
    }
    else
    {
      return null;
    }
  }

  /** The version string of the ADK. */
  private static final String ADK_VERSION = "0.0.3";

  /** A {@link Driver} object used internally inside the API_ADK. */
  private Driver driver;

  /** Global variable for {@link ReturnCode}. */
  private ReturnCode returnCode;

  /**
   * Structure contains list of devices, controllers, message channels, 
   * including the name, number of each parts, and their connection status. 
   * This structure is used internally and should be filled to be able to use 
   * the ADK. It could be filled manually or automatically. To fill it 
   * automatically, call {@link #searchAvailableDevice} with this structure as 
   * its parameter.
   */
  volatile public static DeviceList intDeviceList;

  /**
   * Return the version of the ADK.
   * @return The string of the ADK version.
   */
  public String getADKVersion()
  {
    return ADK_VERSION;
  }

  /**
   * Return the version of the Driver.
   * @return The string of the Driver version.
   */
  public String getDriverVersion()
  {
    return driver.getDriverVersion();
  }

  /**
   * Initialize objects and the communication interface. The initialize 
   * communication interface is a blocking method, which check whether the 
   * communication interface is turned on or not. If it is not turned on, 
   * it will be turned on and wait until it is ready to be used. This method should be 
   * called first after creating the object, and before calling any other 
   * method.
   * @return {@link ReturnCode#SUCCESS}, 
   *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
   *         {@link ReturnCode#FAIL_ACCESSING_BLUETOOTH}, 
   *         {@link ReturnCode#BLUETOOTH_NOT_SUPPORTED}, or 
   *         {@link ReturnCode#FAIL_TURNING_BLUETOOTH_ON}.
   */
  public ReturnCode initializeADK()
  {
    // Initialize driver object.
    returnCode = driver.initializeObjects();
    if (returnCode != ReturnCode.SUCCESS)
    {
      return returnCode;
    }

    // Initialize the communication interface.
    returnCode = driver.initializeCommunicationInterface();
    if (returnCode != ReturnCode.SUCCESS)
    {
      return returnCode;
    }

    return ReturnCode.SUCCESS;
  }

  /**
   * Close the communication interface and deinitialize objects. The close 
   * communication interface is a blocking method, which turned the 
   * communication interface off and waits until it is completely off.
   * This method will only return success if all the connection to the device 
   * have been closed. After calling this method, the class object becomes 
   * unusable, any other methods will not be executed. Call this method at the 
   * end of the application.
   * @return {@link ReturnCode#SUCCESS}, 
   *         {@link ReturnCode#DEVICE_INSTANCE_STILL_OPEN}, or 
   *         {@link ReturnCode#FAIL_TURNING_BLUETOOTH_OFF}.
   */
  public ReturnCode deinitializeADK()
  {
    // Close the communication interface.
    returnCode = driver.deinitializeCommunicationInterface();
    if (returnCode != ReturnCode.SUCCESS)
    {
      return returnCode;
    }

    // Destroy used objects and variables.
    returnCode = driver.deinitializeObjects();
    if (returnCode != ReturnCode.SUCCESS)
    {
      return returnCode;
    }

    if (numberOfObject != 0)
    {
      numberOfObject--;
    }

    return ReturnCode.SUCCESS;
  }

  /**
   * List for all paired devices, but only return the supported device.
   * Use {@link API_ADK#intDeviceList} as the parameter to fill the internal 
   * Device List automatically.
   * @param supportedDeviceList Output: List of supported devices.
   * @return {@link ReturnCode#SUCCESS}, 
   *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
   *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
   *         {@link ReturnCode#DEVICELIST_OBJECT_NOT_VALID}, 
   *         {@link ReturnCode#MAXIMUM_BYTE_CAPACITY_REACH}, 
   *         {@link ReturnCode#NO_PAIRED_DEVICE}, or 
   *         {@link ReturnCode#NO_SUPPORTED_DEVICE}. 
   */
  public ReturnCode searchAvailableDevice(DeviceList supportedDeviceList)
  {
    // Check the validity of the parameter.
    if (supportedDeviceList == null)
    {
      return ReturnCode.DEVICELIST_OBJECT_NOT_VALID;
    }

    DeviceOnlyList pairedDeviceList = new DeviceOnlyList();
    // Search for all paired devices.
    returnCode = driver.listPairedDevice(pairedDeviceList);
    if (returnCode != ReturnCode.SUCCESS)
    {
      return returnCode;
    }

    // Return only supported devices and number of controllers.
    return driver.checkForSupportedDevice(pairedDeviceList, supportedDeviceList);
  }

  /**
   * Create an object of the Device class. Choose one of the device from the 
   * internal Device List. Call {@link Device#connectDevice} directly after this 
   * method to connect to the device. Call {@link Device#disconnectDevice} to 
   * disconnect from the device and deinitialize the Device object.
   * @param inputListIndex Input: The listIndex of {@link API_ADK#intDeviceList}
   *     value.
   * @return {@link Device} object or null if it is already created.
   */
  public Device createDeviceObject(byte inputListIndex)
  {
    // The Driver should be initialized first.
    if (driver.driverStatus != ReturnCode.OBJECT_IS_INITIALIZED)
    {
      return null;
    }

    if (intDeviceList.numberOfController == 0)
    {
      return null; // The list is empty;
    }
    if ((inputListIndex > intDeviceList.numberOfController) || (inputListIndex < 0))
    {
      return null; // Invalid index.
    }

    // Check whether the object is already created.
    // The object can only be one for each device.
    if (intDeviceList.deviceObjectStatus[inputListIndex] ==
        ConnectionStatus.INSTANCE_NOT_CREATED)
    {
      // Change the deviceStatus as INSTANCE_CREATED in Driver.CANDevice.
      return new Device(inputListIndex);
    }
    else
    {
      return null;
    }
  }

// The class of Device --------------------------------------------------------
  /**
   * Subclass Device.
   * This class is used to communicate to a device.
   * @author hroesdiyono
   */
  public class Device
  {
    /**
     * Private constructor, can only be called from inside the class.
     * It initializes internal variables and objects.
     * @param inputListIndex Input: The listIndex of
     *     {@link API_ADK#intDeviceList} value.
     */
    private Device(byte inputListIndex)
    {
      // Copy the device index and list index.
      deviceIndex = intDeviceList.deviceIndex[inputListIndex];
      listIndex = inputListIndex;
      // Initialize the Driver.CANDevice object.
      device = driver.createCANDeviceObject(inputListIndex);
    }

    /** Internal index. */
    private byte deviceIndex, listIndex;

    /** A {@link Driver.CANDevice} object used inside the Device. */
    private Driver.CANDevice device;

    /**
     * Initialize the object and open a connection to the device. This method 
     * should be called directly after creating the Device object.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#INVALID_MAC_ID}, 
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
      return device.connectDevice();
    }

    /**
     * Close a connection to the device and deinitialize the Device object. 
     * This method will only return success if all the connection to the 
     * Controller and MessageChannel have been closed. After calling this 
     * method, the class object becomes unusable, any other methods will not be 
     * executed. Call this method at the end of the device communication. 
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#CONTROLLER_INSTANCE_STILL_CONNECTED}, 
     *         {@link ReturnCode#MESSAGE_CHANNEL_STILL_OPEN}, or 
     *         {@link ReturnCode#FAIL_CLOSING_BLUETOOTH_SOCKET}.
     */
    public ReturnCode disconnectDevice()
    {
      return device.disconnectDevice();
    }

    /**
     * Return the information about the device, such as 
     * Firmware version, Protocol Version, and Hardware Number.
     * @param deviceInformation Output: The information from the device, 
     *     including version, protocol and hardware number information.
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#DEVICEINFORMATION_OBJECT_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#FAIL_PARSING_HARDWARE_NUMBER}, 
     *         {@link ReturnCode#UNKNOWN_DEVICE}, 
     *         {@link ReturnCode#NO_VALID_HARDWARE_NUMBER}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode readDeviceInformation(DeviceInformation deviceInformation)
    {
      // Check the validity of the parameter.
      if (deviceInformation == null)
      {
        return ReturnCode.DEVICEINFORMATION_OBJECT_NOT_VALID;
      }

      returnCode = device.readDeviceVersion(deviceInformation);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      returnCode = device.readDeviceProtocol(deviceInformation);
      if (returnCode != ReturnCode.SUCCESS)
      {
        return returnCode;
      }

      return device.readHardwareNumber(deviceInformation);
    }

    /**
     * Read the status of the CAN Controller and the status of the internal 
     * transmit and receive thread. This method could be called periodically to 
     * check the status of the CAN controller and the internal thread. If one 
     * of the internal thread is not running, there is a possibility that the 
     * connection to the device is no longer exist. If the threads are not 
     * running, try connecting to the device again.
     * Eventhough the return code is not success, the thread status are valid.
     * @param flag Output: The status of the controller and threads. 
     * @return {@link ReturnCode#SUCCESS}, 
     *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
     *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
     *         {@link ReturnCode#STRING_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
     *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
     *         {@link ReturnCode#ERRORBUFFER_OBJECT_NOT_VALID}, 
     *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
     *         {@link ReturnCode#INVALID_RESPONSE}, 
     *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
     *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
     *         {@link ReturnCode#NO_RESPONSE}.
     */
    public ReturnCode readErrorStatus(ErrorBuffer flag)
    {
      // Check the validity of the parameter.
      if (flag == null)
      {
        return ReturnCode.ERRORBUFFER_OBJECT_NOT_VALID;
      }

      return device.readErrorStatus(flag);
    }

    /**
     * Constructor of the Controller class. Since currently there is only one 
     * Controller for each Device, use the same listIndex as the Device Object.
     * Call {@link Controller#initializeController(int,byte)} or 
     * {@link Controller#initializeController(byte)} directly after this method 
     * to initialize the controller. Call 
     * {@link Controller#deinitializeController} to deinitialize the Controller 
     * object.
     * @param inputListIndex Input: The listIndex of {@link API_ADK#intDeviceList}
     *     value.
     * @return {@link Controller} object or null if it is already created.
     */
    public Controller createControllerObject(byte inputListIndex)
    {
      // Can not be used if the device object is not initialized.
      if (device.deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
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

      // The object can only be created once for each controller.
      // The object of its device should be created first.
      if ((intDeviceList.controllerObjectStatus[inputListIndex] ==
          ConnectionStatus.INSTANCE_NOT_CREATED) &&
          (intDeviceList.deviceObjectStatus[inputListIndex] ==
          ConnectionStatus.INSTANCE_CREATED) &&
          (intDeviceList.deviceIndex[inputListIndex] == deviceIndex))
      {
        // Set the deviceStatus as INSTANCE_CREATED in CANDevice class.
        return new Controller(inputListIndex);
      }
      else
      {
        return null;
      }
    }

// The class of Controller ----------------------------------------------------

    /**
     * Subclass Controller.
     * This class is created one for each controller.
     * @author hroesdiyono
     */
    public class Controller
    {
      /**
        * Private constructor, can only be called from inside the class.
        * It initializes internal variables and objects.
        * @param inputListIndex Input: The listIndex of {@link API_ADK#intDeviceList}
        *     value.
        */
      private Controller(byte inputListIndex)
      {
        // Copy the controller index and list index.
        /*controllerIndex = intDeviceList.controllerIndex[inputListIndex];
        listIndex = inputListIndex;*/
        // Initialize the Device.CANController object.
        controller = device.createCANControllerObject(inputListIndex);
      }

      /** Internal index. */
      /*private byte controllerIndex, listIndex;*/

      /**
       * A {@link Driver.CANDevice.CANController} object used inside
       * the Controller.
       */
      private Driver.CANDevice.CANController controller;

      /**
       * Open a connection to the controller, determine the baudrate manually, 
       * initialize the receive filter, and read the status of the Controller.
       * It is also reset the setting of the controller to its default setting.
       * The receive filter type should only be determined once, and should not 
       * be changed after the controller is running or any MessageChannel 
       * object is created. This method can only be used once in order to make 
       * sure that the receive filter is not changed. This method also fill the 
       * controllerStatus of {@link API_ADK#intDeviceList} automatically.
       * @param controllerBaudrate Input: The value of baudrate (10 - 1000).
       * @param receiveFilterType Input: The value of frame format 
       *     ({@link ConstantList#HARDWARE_FILTER}, or 
       *     {@link ConstantList#SOFTWARE_FILTER}).
       * @return {@link ReturnCode#SUCCESS}, 
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
       *         {@link ReturnCode#INVALID_FILTER_TYPE}, 
       *         {@link ReturnCode#FAIL_USING_SETTINGS_DEFAULT}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode initializeController(int controllerBaudrate,
          byte receiveFilterType)
      {
        CANInfo status = new CANInfo();

        // Open a connection to the controller.
        returnCode = controller.connectController();
        if (returnCode != ReturnCode.SUCCESS)
        {
          return returnCode;
        }

        // Initialize the baudrate of the controller.
        returnCode = controller.initializeControllerBaudrate(controllerBaudrate);
        if (returnCode != ReturnCode.SUCCESS)
        {
          return returnCode;
        }

        // Determine the active filter list and initialize the receive
        // filter list.
        returnCode = controller.initializeReceiveFilter(receiveFilterType);
        if (returnCode != ReturnCode.SUCCESS)
        {
          return returnCode;
        }

        returnCode = controller.readStatus(status);
        if (returnCode != ReturnCode.SUCCESS)
        {
          return returnCode;
        }

        intDeviceList.controllerStatus[listIndex] = status.controllerStatus;
        return ReturnCode.SUCCESS;
      }

      /**
       * Open a connection to the controller, determine the baudrate 
       * automatically (the CAN bus should be active), and initialize the 
       * receive filter. The receive filter type should only be determined 
       * once, and should not be changed after the controller is running or any 
       * MessageChannel object is created.
       * @param receiveFilterType Input: The value of frame format 
       *     ({@link ConstantList#HARDWARE_FILTER}, or 
       *     {@link ConstantList#SOFTWARE_FILTER}).
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#INVALID_RESPONSE}, 
       *         {@link ReturnCode#INVALID_BUS_COUPLING}, 
       *         {@link ReturnCode#INVALID_TIMEOUT_VALUE},
       *         {@link ReturnCode#NO_BAUDRATE_DETECTED}, 
       *         {@link ReturnCode#BUS_COUPLING_NOT_SUPPORTED}, 
       *         {@link ReturnCode#INVALID_FILTER_TYPE}, 
       *         {@link ReturnCode#FAIL_USING_SETTINGS_DEFAULT}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode initializeController(byte receiveFilterType)
      {
        // Open a connection to the controller.
        returnCode = controller.connectController();
        if (returnCode != ReturnCode.SUCCESS)
        {
          return returnCode;
        }

        // Determine the baudrate of the CAN network and use it as the
        // baudrate of the controller.
        returnCode = controller.initializeControllerBaudrate();
        if (returnCode != ReturnCode.SUCCESS)
        {
          return returnCode;
        }

        // Determine the active filter list and initialize the receive
        // filter list.
        return controller.initializeReceiveFilter(receiveFilterType);
      }

      /**
       * Disconnect from a controller and deinitialize the Controller object. 
       * This method will only return success if all MessageChannels that use 
       * this controller have been closed. After calling this method, the class 
       * object becomes unusable, any other methods will not be executed.
       * @return {@link ReturnCode#SUCCESS} or 
       *         {@link ReturnCode#MESSAGE_CHANNEL_STILL_USING_CONTROLLER}.
       */
      public ReturnCode deinitializeController()
      {
        return controller.disconnectController();
      }

      /**
       * Read the status of the CAN controller. Use {@link Device#readErrorStatus} 
       * instead.
       * @param controllerStatus Output: The status of the CAN controller.
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#CANINFO_OBJECT_NOT_VALID},
       *         {@link ReturnCode#FAIL_SEARCHING_STRING}, 
       *         {@link ReturnCode#INVALID_RESPONSE}, 
       *         {@link ReturnCode#WAITING_FOR_RESPONSE_TIMEOUT}, 
       *         {@link ReturnCode#EXCEPTION_SLEEP_THREAD}, or 
       *         {@link ReturnCode#NO_RESPONSE}.
       */
      public ReturnCode readControllerStatus(CANInfo controllerStatus)
      {
        // Check the validity of the parameter.
        if (controllerStatus == null)
        {
          return ReturnCode.CANINFO_OBJECT_NOT_VALID;
        }

        return controller.readStatus(controllerStatus);
      }

      /**
       * Enable or disable the listen mode of the CAN controller. This listen 
       * mode determines the format of the received message. Binary format is 
       * shorter than the ASCII format, so it takes less time and increase 
       * data rate. The Off mode means that the device will not relay any 
       * message. If the mode is Off, calling {@link Controller#startController} 
       * would change the mode to ASCII. To change the mode to Off, start the 
       * controller first before calling this method. <br>
       * Note that Sending any message (in ASCII or Binary format) will change 
       * the mode to the respective message format, for example Off to Binary, 
       * or Binary to ASCII.
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
      public ReturnCode enableControllerListenMode(byte mode)
      {
        return controller.enableListenMode(mode);
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
      public ReturnCode startController()
      {
        return controller.startCANController();
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
      public ReturnCode stopController()
      {
        return controller.stopCANController();
      }

      /**
       * Put a message to the transmit buffer. The internal transmit thread 
       * will send the message to the device or collective message every 5ms. This method is 
       * optimized for fast and repetitive sending message for more than 1 
       * message in the interval of 5ms. <br>
       * There are 2 message formats, ASCII and binary. Binary format is 
       * shorter than the ASCII format, so it takes less time and increase 
       * data rate. <br>
       * Note that Sending any message (in ASCII or Binary format) will change 
       * the receive message mode to the respective message format, for example 
       * Off to Binary, or Binary to ASCII.
       * The method returns success if it could successfully put the message 
       * into the transmit buffer. Call {@link Device#readErrorStatus} to check 
       * whether the Device could send the message to the CAN bus or the 
       * internal transmit thread is still working.
       * @param message       Input: Message to be sent.
       * @param messageFormat Input: ({@link ConstantList#ASCII_FORMAT}, or 
       *     {@link ConstantList#BINARY_FORMAT})
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED},
       *         {@link ReturnCode#STRING_NOT_VALID}, 
       *         {@link ReturnCode#FAIL_CONVERTING_TO_ARRAY}, 
       *         {@link ReturnCode#FAIL_WRITING_TO_BLUETOOTH},
       *         {@link ReturnCode#MESSAGESTRUCTURE_OBJECT_NOT_VALID},
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
        // Check the validity of the parameter.
        if (message == null)
        {
          return ReturnCode.MESSAGESTRUCTURE_OBJECT_NOT_VALID;
        }

        return controller.transmitMessage(message, messageFormat);
      }
    }

    /**
     * Constructor of the MessageChannel class. Use the same listIndex as the 
     * Controller object. Call {@link MessageChannel#initializeMessageChannel} 
     * directly after this method to initialize the message channel. Call 
     * {@link  MessageChannel#deinitializeMessageChannel} to deinitialize the 
     * MessageChannel object. <br>
     * The limitation of the object creation is 1 if the Hardware filter is 
     * used, and 128 if the Software filter is used.
     * The object of the controller should be created before creating
     * an object for the message channel and the controller should be stopped 
     * before creating MessageChannel object.
     * @param inputListIndex Input: The listIndex of {@link API_ADK#intDeviceList}
     *     value.
     * @return {@link MessageChannel} object or null if the input is wrong or 
     *     the number of the object is more than the limitation.
     */
    public MessageChannel createMessageChannelObject(byte inputListIndex)
    {
      // Can not be used if the device object is not initialized.
      if (device.deviceStatus != ReturnCode.OBJECT_IS_INITIALIZED)
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
        // Update the number of message channel in CANMessage class.
        return new MessageChannel(inputListIndex);
      }
      else
      {
        return null;
      }
    }

// The class of MessageChannel ------------------------------------------------
    /**
     * Subclass MessageChannel.
     * This class is used for receiving and filtering message.
     * It can only be used if the Controller object has been created. 
     * {@link MessageChannel#initializeMessageChannel}, 
     * {@link MessageChannel#deinitializeMessageChannel}, 
     * {@link MessageChannel#clearReceiveFilter}, 
     * {@link MessageChannel#addReceiveFilter}, 
     * {@link MessageChannel#removeReceiveFilter}, and 
     * {@link MessageChannel#setReceiveFilter} can not be used if the 
     * controller is started. It could produce an error if the 
     * controller is receiving message while the message channel and filter 
     * configuration are changed.
     * @author hroesdiyono
     */
    public class MessageChannel
    {
      /**
        * Private constructor, can only be called from inside the class.
        * It initializes internal variables and objects.
        * @param inputListIndex Input: The listIndex of {@link API_ADK#intDeviceList}
        *     value.
        */
      private MessageChannel(byte inputListIndex)
      {
        // Copy the controller index, message index, and list index.
        /*controllerIndex = intDeviceList.controllerIndex[inputListIndex];
        messageIndex =
          intDeviceList.numberOfMessageChannel[inputListIndex];*/
        listIndex = inputListIndex;
        message = device.createCANMessageObject(inputListIndex);
      }

      /** Internal index. */
      /*private byte messageIndex, controllerIndex, listIndex;*/

      /** A {@link Driver.CANDevice.CANMessage} used inside the MessageChannel. */
      private Driver.CANDevice.CANMessage message;

      /**
       * Initialize the message channel. This method should be call before 
       * calling any other method.
       * @return {@link ReturnCode#SUCCESS},
       *         {@link ReturnCode#CONTROLLER_IS_STARTED}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED}, or 
       *         {@link ReturnCode#INVALID_FILTER_TYPE}.
       */
      public ReturnCode initializeMessageChannel()
      {
        return message.initializeCANMessage();
      }

      /**
       * Deinitialize the message channel. This method should be called after 
       * finish using the message channel. 
       * @return {@link ReturnCode#SUCCESS} or
       *         {@link ReturnCode#CONTROLLER_IS_STARTED}.
       */
      public ReturnCode deinitializeMessageChannel()
      {
        return message.deinitializeCANMessage();
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
      public ReturnCode clearReceiveFilter(byte frameFormat)
      {
        return message.clearFilter(frameFormat);
      }

      /**
       * Add an ID to the receive filter of active filter.
       * @param frameFormat Input: The value of frame format 
       *     ({@link ConstantList#STANDARD_FRAME}, or 
       *     {@link ConstantList#EXTENDED_FRAME}).
       * @param messageID   Input: The value of message ID (0 - 0x7FF for 
       *     Standard frame and 0 - 0x1FFFFFFFF for Extended frame).
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
      public ReturnCode addReceiveFilter(byte frameFormat, 
          int messageID, byte frameType)
      {
        return message.addFilter(frameFormat, messageID, frameType);
      }

      /**
       * Remove an ID from the receive filter of active filter.
       * @param frameFormat Input: The value of frame format 
       *     ({@link ConstantList#STANDARD_FRAME}, or 
       *     {@link ConstantList#EXTENDED_FRAME}).
       * @param messageID Input: The value of message ID (0 - 0x7FF for 
       *     Standard frame and 0 - 0x1FFFFFFFF for Extended frame).
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
      public ReturnCode removeReceiveFilter(byte frameFormat, 
          int messageID, byte frameType)
      {
        return message.removeFilter(frameFormat, messageID, frameType);
      }

      /**
       * Enable or disable the receive filter of active filter.
       * @param frameFormat Input: The value of frame format 
       *     ({@link ConstantList#STANDARD_FRAME}, or 
       *     {@link ConstantList#EXTENDED_FRAME}).
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
      public ReturnCode setReceiveFilter(byte frameFormat, 
          boolean enableFilter)
      {
        return message.setFilter(frameFormat, enableFilter);
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
       *         {@link ReturnCode#FILTERLIST_OBJECT_NOT_VALID},
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
        // Check the validity of the parameter.
        if (filterList == null)
        {
          return ReturnCode.FILTERLIST_OBJECT_NOT_VALID;
        }

        return message.readFilterInformation(frameFormat, filterList);
      }

      /**
       * Take a message from the message buffer.
       * @param receivedMessage Output: Message receive.
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED},
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED}, 
       *         {@link ReturnCode#MESSAGESTRUCTURE_OBJECT_NOT_VALID},
       *         {@link ReturnCode#RECEIVE_BUFFER_EMPTY}, 
       *         {@link ReturnCode#EXCEPTION_SEMAPHORE_ACQUIRE}, or 
       *         {@link ReturnCode#EXCEPTION_SEMAPHORE_RELEASE}.
       */
      public ReturnCode receiveMessage(MessageStructure receivedMessage)
      {
        // Check the validity of the parameter.
        if (receivedMessage == null)
        {
          return ReturnCode.MESSAGESTRUCTURE_OBJECT_NOT_VALID;
        }

        return message.receiveMessage(receivedMessage);
      }

      /**
       * Determine the bus load. This method is not implemented.
       * @param busLoad Output: The current Bus Load.
       * @return {@link ReturnCode#SUCCESS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED}, or 
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED}.
       */
      public ReturnCode determineBusLoad(int busLoad)
      {
        return message.determineBusLoad(busLoad);
      }

      /**
       * Return the status of the receive message buffer. This method could be 
       * called periodically to check whether the internal receive buffer is 
       * full. Calling this method reset the status of the buffer.
       * @return {@link ReturnCode#RECEIVE_BUFFER_NO_STATUS}, 
       *         {@link ReturnCode#OBJECT_IS_DEINITIALIZED}, 
       *         {@link ReturnCode#OBJECT_IS_NOT_INITIALIZED}, or 
       *         {@link ReturnCode#RECEIVE_BUFFER_OVERRUN}.
       */
      public ReturnCode receiveBufferStatus()
      {
        return message.receiveBufferStatus();
      }
    }
  }
}
