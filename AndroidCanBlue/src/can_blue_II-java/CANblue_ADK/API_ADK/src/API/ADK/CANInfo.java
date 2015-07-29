package API.ADK;

/**
 * Structure for the CAN controller status and also the error 
 * flags (state, overruns, Warning Level or BUS OFF).
 * @author hroesdiyono
 */
public class CANInfo
{
  /** The status of the CAN controller. */
  public ControllerStatus controllerStatus;
  /** True if there is a Warning Level. */
  public boolean warningLevel;
  /** True if there is a Bus Off. */
  public boolean busOff;
  /** True if there is a RX CAN Controller Overrun. */
  public boolean RxCANControllerOverrun;
  /** True if there is a RX SW Queue Overrun. */
  public boolean RxSWQueueOverrun;
  /** True if there is a TX SW Queue Overrun. */
  public boolean TxSWQueueOverrun;
  /** True if there is a Tx Pending. */
  public boolean TxPending;

  /** The default constructor of the CANInfo. */
  public CANInfo()
  {
    // Do nothing;
  }
}