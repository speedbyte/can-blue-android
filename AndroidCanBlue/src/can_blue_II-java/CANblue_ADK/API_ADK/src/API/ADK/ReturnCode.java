package API.ADK;

/**
 * Enum of all return codes. 
 * These return codes are used in almost all methods and also used as 
 * error messages.
 * @author hroesdiyono
 */
public enum ReturnCode
{
  /** No error. */
  SUCCESS,
  /** The object is initialized. */
  OBJECT_IS_INITIALIZED,
  /** The object is not initialized, initialize the object first. */
  OBJECT_IS_NOT_INITIALIZED,
  /** The object is deinitialized, it can not be used anymore. */
  OBJECT_IS_DEINITIALIZED,
  /** The Bluetooth is not supported by the application. */
  BLUETOOTH_NOT_SUPPORTED,
  /**
   *  Possibly Runtime exception due to accessing the Bluetooth Adapter not
   *  from an Activity thread.
   */
  FAIL_ACCESSING_BLUETOOTH,
  /** Fail turning the Bluetooth on. */
  FAIL_TURNING_BLUETOOTH_ON,
  /** Fail turning the Bluetooth off. */
  FAIL_TURNING_BLUETOOTH_OFF,
  /** No paired device found. */
  NO_PAIRED_DEVICE,
  /** No device detected. Only use by CANblue MAC scan command. */
  NO_DEVICE_DETECTED,
  /** No supported device found. */
  NO_SUPPORTED_DEVICE,
  /** Fail starting the receive thread. */
  FAIL_STARTING_RECEIVE_THREAD,
  /** Fail starting the transmit thread. */
  FAIL_STARTING_TRANSMIT_THREAD,
  /** The thread is running. */
  THREAD_RUNNING,
  /** The thread is stopped. */
  THREAD_STOPPED,
  /** The value of a byte variable is more than the maximum possible value. */
  MAXIMUM_BYTE_CAPACITY_REACH,
  /** The input Baudrate is not supported. */
  BAUDRATE_NOT_SUPPORTED,
  /** No baudrate detected. */
  NO_BAUDRATE_DETECTED,
  /** CANblue II only supports high buscoupling while CANblue supports both. */
  BUS_COUPLING_NOT_SUPPORTED,
  /** Fail initializing the controller. */
  FAIL_INITIALIZING_CONTROLLER,
  /** Fail starting the controller. */
  FAIL_STARTING_CONTROLLER,
  /** Fail stopping the controller. */
  FAIL_STOPPING_CONTROLLER,
  /** Fail adding ID to the filter or the filter is full. */ 
  FAIL_ADDING_ID_TO_FILTER,
  /** The MAC list is full. */
  MAC_LIST_FULL,
  /** The MAC Address is already exist. */
  MAC_ADDRESS_ALREADY_EXIST,
  /** CANblue II returns this error if it tries to remove unlisted MAC ID. */
  WRONG_MAC_ADDRESS,
  /** Fail writing the hardware serial number. */
  FAIL_WRITING_HW_SERIAL_NUM,
  /** There is no valid config to load. */
  NO_VALID_CONFIG,
  /** Fail saving config. */
  FAIL_SAVING_CONFIG,
  /** Fail reading config. */
  FAIL_READING_CONFIG,
  /** The read config is too long, the device can not show more. */
  READ_CONFIGURATION_CANT_SHOW_MORE,
  /** This error code is not used by CANblue II. */
  LAST_CONFIG_NOT_VALID,
  /** Invalid Bus coupling input. */
  INVALID_BUS_COUPLING,
  /** Invalid MAC ID input. */
  INVALID_MAC_ID,
  /** Invalid Time scan input. */
  INVALID_TIME_SCAN,
  /** Invalid Latency setting input. */
  INVALID_LATENCY_SETTING,
  /** Invalid Packet type input. */
  INVALID_PACKET_TYPE_VALUE,
  /** Invalid Pagescan interval input. */
  INVALID_PAGESCAN_INTERVAL_VALUE,
  /** Invalid Pagescan windows input. */
  INVALID_PAGESCAN_WINDOWS_VALUE,
  /** Invalid Pagescan type input. */
  INVALID_PAGESCAN_TYPE_VALUE,
  /** Invalid Latency input. */
  INVALID_LATENCY_VALUE,
  /** Invalid Hardware serial number length, the length should be 6characters. */
  INVALID_HARDWARE_SERIAL_NUMBER_LENGTH,
  /** No valid Hardware number stored in the device. */
  NO_VALID_HARDWARE_NUMBER,
  /** Invalid Baudrate input. */
  INVALID_BAUDRATE_VALUE,
  /** Invalid Timeout input. */
  INVALID_TIMEOUT_VALUE,
  /** Invalid Frame format input. */
  INVALID_FRAME_FORMAT_VALUE,
  /** Invalid Message ID input. */
  INVALID_MESSAGE_ID_VALUE,
  /** Invalid Frame type input. */
  INVALID_FRAME_TYPE_VALUE,
  /** Invalid Data length input. */
  INVALID_DATA_LENGTH,
  /** Invalid Data input. */
  INVALID_DATA_VALUE,
  /** Invalid Filter type input. */
  INVALID_FILTER_TYPE,
  /** Invalid Filter status input. */
  INVALID_FILTER_STATUS,
  /** Invalid Mode input. */
  INVALID_INPUT_MODE,
  /** Invalid Message format. */
  INVALID_MESSAGE_FORMAT,
  /** Fail using settings default. */
  FAIL_USING_SETTINGS_DEFAULT,
  /** Fail getting Bluetooth remote device. */
  FAIL_GETTING_REMOTE_DEVICE,
  /** Fail creating Bluetooth socket. */
  FAIL_CREATING_BLUETOOTH_SOCKET,
  /** Fail opening Bluetooth socket. */
  FAIL_OPENING_BLUETOOTH_SOCKET,
  /** Fail opening and closing Bluetooth socket. */ 
  FAIL_OPENING_AND_CLOSING_BLUETOOTH_SOCKET,
  /** Fail closing Bluetooth socket. */
  FAIL_CLOSING_BLUETOOTH_SOCKET,
  /** Fail opening Bluetooth input stream. */
  FAIL_OPENING_INPUTSTREAM,
  /** Fail opening Bluetooth output stream. */
  FAIL_OPENING_OUTPUTSTREAM,
  /** Fail writing to Bluetooth. */
  FAIL_WRITING_TO_BLUETOOTH,
  /** Fail parsing Hardware number. */
  FAIL_PARSING_HARDWARE_NUMBER,
  /** Fail converting a String to an array. */ 
  FAIL_CONVERTING_TO_ARRAY,
  /** The responses received are not as expected. */
  INVALID_RESPONSE,
  /** No response until timeout. */
  NO_RESPONSE,
  /** The device is not supported. */
  UNKNOWN_DEVICE,
  /** Waiting for response timeout. */
  WAITING_FOR_RESPONSE_TIMEOUT,
  /** Waiting for the send buffer to be empty. */
  WAITING_TO_SEND_TIMEOUT,
  /**
   * The number of Message channel is not zero (still using the controller).
   * Deinitialize all message objects first.
   */
  MESSAGE_CHANNEL_STILL_USING_CONTROLLER,
  /**
   * Controller instance is still connected to the device. 
   * Close a connection from a controller first.
   */
  CONTROLLER_INSTANCE_STILL_CONNECTED,
  /**
   * The number of Message channel is not zero (still using the device).
   * Deinitialize all message objects first.
   */
  MESSAGE_CHANNEL_STILL_OPEN,
  /** Device instance is still open. Disconnect the connection first. */
  DEVICE_INSTANCE_STILL_OPEN,
  /** The receive buffer is full. */
  RECEIVE_BUFFER_FULL,
  /** The receive buffer is empty. */
  RECEIVE_BUFFER_EMPTY,
  /** There is no error status for the receive buffer. */
  RECEIVE_BUFFER_NO_STATUS,
  /** The receive buffer is overrun. At least there is one message discarded. */
  RECEIVE_BUFFER_OVERRUN,
  /** The error buffer is full. */
  ERROR_BUFFER_FULL,
  /** The error buffer is empty. */
  ERROR_BUFFER_EMPTY,
  /** There is no error status for the error buffer. */
  ERROR_BUFFER_NO_STATUS,
  /** The error buffer is overrun. At least there is one error message discarded. */
  ERROR_BUFFER_OVERRUN,
  /** The String is null or unsearchable. */
  FAIL_SEARCHING_STRING,
  /**
   * An exception in the sleep thread, if interrupt() was called for this 
   * Thread while it was sleeping.
   */
  EXCEPTION_SLEEP_THREAD,
  /** An exception on the acquire method of a semaphore. */
  EXCEPTION_SEMAPHORE_ACQUIRE,
  /** An exception on the release method of a semaphore. */
  EXCEPTION_SEMAPHORE_RELEASE,
  /** The length of the message is bigger than 
    * {@value API.ADK.ConstantList#MAXIMUM_MESSAGE_ARRAY_LENGTH}.
    */
  MESSAGE_TOO_LONG,
  /** The method / command is not supported by the connecting device. */ 
  COMMAND_NOT_SUPPORTED,
  /**
   * The controller is started. Create MessageChannel object and all methods 
   * of MessageChannel can not be used. Stop the controller first.
   */
  CONTROLLER_IS_STARTED,
  /** The CANInfo object is not valid / null. */
  CANINFO_OBJECT_NOT_VALID,
  /** The DeviceOnlyList object is not valid / null. */
  DEVICEONLYLIST_OBJECT_NOT_VALID,
  /** The DeviceList object is not valid / null. */
  DEVICELIST_OBJECT_NOT_VALID,
  /** The DeviceInformation object is not valid / null. */
  DEVICEINFORMATION_OBJECT_NOT_VALID,
  /** The MACScanDeviceList object is not valid / null. */
  MACSCANDEVICELIST_OBJECT_NOT_VALID,
  /** The String is not valid / null. */
  STRING_NOT_VALID,
  /** The Array is not valid / null. */
  ARRAY_NOT_VALID,
  /** The Object is not valid / null. */
  OBJECT_NOT_VALID,
  /** The MessageStructure object is not valid / null. */
  MESSAGESTRUCTURE_OBJECT_NOT_VALID,
  /** The FilterList object is not valid / null. */
  ERRORBUFFER_OBJECT_NOT_VALID,
  /** The FilterList object is not valid / null. */
  FILTERLIST_OBJECT_NOT_VALID
}