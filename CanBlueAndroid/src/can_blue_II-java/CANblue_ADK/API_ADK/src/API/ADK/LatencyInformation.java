package API.ADK;

/**
 * Structure for the Latency information. This structure is filled by calling 
 * {@link Driver.CANDevice#readCANblueLatencyInformation}.
 * @author hroesdiyono
 */
public class LatencyInformation
{
  /** The name of the connection. */
  public String connectionName;
  /** The value of packet type. */
  public int packetType;
  /** The value of pagescan interval. */
  public int pagescanInterval;
  /** The value of pagescan window. */
  public int pagescanWindow;
  /** The value of pagescan type. */
  public byte pagescanType;
  /** The value of latency. */
  public int latency;
  /*I MAC,          Latency,   Link quality, RSSI,    Tx-Power, PacketType
  I 000461870BB4, 40*625us,  255,          8dB,      246,     CC18
  I OK: D INFO*/

  /** The default constructor of the LatencyInformation.  */
  public LatencyInformation(){
    // Do nothing.
  }
}
