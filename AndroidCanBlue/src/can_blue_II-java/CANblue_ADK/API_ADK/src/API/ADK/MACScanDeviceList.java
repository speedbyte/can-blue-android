package API.ADK;

/**
 * Structure for the MACScan response. It contains the number of detected 
 * device, name of device and its MAC address.
 * @author hroesdiyono
 */
public class MACScanDeviceList
{

  /** The Bluetooth name of the device. */
  public String deviceName[];
  /** The MAC Address of the device. */
  public String deviceMACAddress[];
  /** The number of detected device. */
  public byte numberOfDevice;

  /**
   * The constructor of the MACScanDeviceList.
   * @param size Input: The size of the list.
   */
  public MACScanDeviceList(byte size)
  {
    this.deviceMACAddress = new String[size];
    this.deviceName = new String[size];
  }

  /**
   * The default constructor of the MACScanDeviceList.
   */
  public MACScanDeviceList()
  {
    // Do nothing.
  }
}

