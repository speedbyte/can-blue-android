package API.ADK;

/**
 * List of Information about Supported devices.
 * @author hroesdiyono
 */
public class DeviceListInformation
{
  /** Number of supported device. */
  public static final byte numberOfSupportedDevice = 2;

  // First device.
  // Name: IXXAT CANblue (XXXXXXXXXXXX), compare the string with only
  // "CANblue (".
  // Second device.
  // Name: IXXAT CANblue II (XXXXXXXXXXXX), compare the string with only
  // "CANblue II (".
  /**
   * The String contains the default name for each device. 
   * It is used internally for differentiating each device.
   */
  public static final String deviceName[] = {"CANblue (", "CANblue II ("};
  /**
   * The type of each device. 
   * It is used internally for differentiating each device.
   */
  public static final DeviceType deviceType[] = {DeviceType.CANBLUE, DeviceType.CANBLUE_II};
  /** The number of controller of each device. */
  public static final byte numberOfController[] = {1, 1};

  /** The default constructor of the DeviceListInformation. */
  public DeviceListInformation()
  {
    // Do nothing.
  }
}
