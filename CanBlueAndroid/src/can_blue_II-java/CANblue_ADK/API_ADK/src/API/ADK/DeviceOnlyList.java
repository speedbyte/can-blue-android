package API.ADK;

/**
 * List of Device (Name, MAC Address, and Detection status only). 
 * This list contains the number of device, name of 
 * device, its MAC address, and the detection status of each device.
 * This list is used internally.
 * @author hroesdiyono

 */
public class DeviceOnlyList
{
  /** The Bluetooth name of the device. */
  public String deviceName[];

  /** The MAC Address of the device. */
  public String deviceMACAddress[];

  /** The status of the detection. */
  public DetectionMethod detectionStatus[];

  /** The number of detected device. */
  public byte numberOfDevice;

  /**
   * The constructor of the DeviceOnlyList.
   * @param size Input: The size of the list.
   */
  public DeviceOnlyList(byte size)
  {
    this.deviceName = new String[size];
    this.deviceMACAddress = new String[size];
    this.detectionStatus = new DetectionMethod[size];
    this.numberOfDevice = size;
  }

  /**
   * The default constructor of the DeviceOnlyList.
   */
  public DeviceOnlyList()
  {
    this.numberOfDevice = 0;
  }

}