package API.ADK;

/**
 * List of all supported devices and its status.
 * This list contains the number of device, name of 
 * device, its MAC address, its number of controller, each 
 * controller's number of message channel, the detection status of each device. 
 * All the indexes start from 0.
 * @author hroesdiyono
 */
public class DeviceList
{
  /**
   * Incremental index of the list. 
   * This index is used externally for creating object of Device, 
   * Controller, or Message Channel.
   */
  public byte listIndex[];

  /**
   * Incremental index of the device. 
   * There might be more than one row that have the same device index 
   * number if the device contains more than one controller. 
   * This index is used internally.
   */
  public byte deviceIndex[];

  /** The Bluetooth name of the device. */
  public String deviceName[];

  /**
   * The MAC Address of the device.
   * This address is used to open a connection to the device.
   */
  public String deviceMACAddress[];

  /**
   * The type of the device. 
   * This device type is used internally to solve compatibility issue between 
   * different device types.
   */
  public DeviceType deviceType[];

  /** The status of the detection, PAIRED_DEVICE or DETECTED_DEVICE. */
  public DetectionMethod detectionStatus[];

  /**
   *  The index of the controller. 
   * Each device has its own controller index. 
   * Currently, there is no available device that has more than one 
   * controller, so this index is reserved for future use. 
   */
  public byte controllerIndex[];

  /**
   * The status of the device object, either the object has not been created, 
   * or has been created.
   */
  public ConnectionStatus deviceObjectStatus[];

  /**
   * The status of the controller object, either the object has not been 
   * created, has been created, or has been connected.
   */
  public ConnectionStatus controllerObjectStatus[];

  /**
   * The status of the controller, either the it is started or stopped.
   * It is filled automatically at the initialization of Controller object.
   */
  public ControllerStatus controllerStatus[];

  /**
   * The type of receive filter used by each controller, HARDWARE_FILTER 
   * or SOFTWARE_FILTER.
   */
  public byte receiveFilterType[];

  /** The number of message channel of each controller. */
  public byte numberOfMessageChannel[];

  /** The number of detected device. */
  public byte numberOfDevice;

  /**
   * The total number of detected controller. 
   * Since the number of detected controller is the same as the length 
   * of the list, this number is used internally and externally as a 
   * reference to the length of the list.
   */
  public byte numberOfController;

  /**
   * The constructor of the DeviceList.
   * @param size Input: The size of the list.
   */
  public DeviceList(byte size)
  {
    // Create an object with a certain size.
    this.listIndex = new byte[size];
    this.deviceIndex = new byte[size];
    this.deviceName = new String[size];
    this.deviceType = new DeviceType[size];
    this.deviceMACAddress = new String[size];
    this.detectionStatus = new DetectionMethod[size];
    this.controllerIndex = new byte[size];
    this.deviceObjectStatus = new ConnectionStatus[size];
    this.controllerObjectStatus = new ConnectionStatus[size];
    this.controllerStatus = new ControllerStatus[size];
    this.receiveFilterType = new byte[size];
    this.numberOfMessageChannel = new byte[size];
    this.numberOfDevice = 0;
    this.numberOfController = 0;
  }

  /**
   * The default constructor of the DeviceList.
   */
  public DeviceList()
  {
    this.numberOfDevice = 0;
    this.numberOfController = 0;
  }
}