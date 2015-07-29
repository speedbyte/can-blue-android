package API.ADK;

/**
 * Structure for the CANblue configuration.
 * This structure is internally used by the {@link API_ADK} for reading the 
 * hardware filter list.
 * @author hroesdiyono
 */
public class CANblueConfiguration
{
  /** String of baudrate, including baudrate bit. */
  public String baudrate;

  /** The status of the busCoupling. */
  public BusCouplingStatus busCoupling;

  /** The status of the autostart. */
  public AutostartStatus autostart;

  /** The list of MAC. This list is only used by CANblue. */
  public String MACList[];
  /** The length of MACList. Only used by CANblue. */
  public int MACCount;

  /** The list of MAC Slave. This list is only used by CANblue II. */
  public String MACSlaveList[];
  /** The length of MACSlaveList. Only used by CANblue II. */
  public byte MACSlaveCount;

  /** The list of MAC Master. This list is only used by CANblue II. */
  public String MACMasterList[];
  /** The length of MACMasterList. Only used by CANblue II. */
  public byte MACMasterCount;

  /** The list of hardware standard frame filter. */
  public String STDFilterList[];
  /** The length of STDFilterList. */
  public int STDFilterCount;
  /** The status of the standard frame filter. */
  public FilterStatus STDFilterStatus;

  /** The list of hardware extended frame filter. */
  public String EXTFilterList[];
  /** The length of EXTFilterList. */
  public int EXTFilterCount;
  /** The status of the extended frame filter. */
  public FilterStatus EXTFilterStatus;

  /** The TXBuffTimeout value. Only used by CANblue II. */
  public String TXBuffTimeout;

  /**
   * The constructor of the CANblueConfiguration.
   * Initialize the size of MACMasterList and MACSlaveList arrays.
   */
  public CANblueConfiguration()
  {
    // The maximum of two MAC Master in CANblue II.
    this.MACMasterList = new String[2];
    // There is only one possible MAC slave in CANblue II.
    this.MACSlaveList = new String[1];
  }
}