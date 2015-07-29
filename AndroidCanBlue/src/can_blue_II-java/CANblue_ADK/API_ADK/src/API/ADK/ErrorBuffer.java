package API.ADK;

/**
 * Structure for the Error Flag. This error structure contains the status of 
 * the CAN Controller as defined in {@link CANInfo} and the status of the 
 * transmit and receive threads for each device.
 * @author hroesdiyono
 */
public class ErrorBuffer
{
  /**
   * The status of the CAN Controller. Since currently there is only 1 
   * CAN controller for each device, there is only one status. */
  public CANInfo status = new CANInfo();

  /**
   * The status of the transmit thread 
   * {@link Driver.CANDevice.TransmitBulkMessage}. The status could  be 
   * {@link ReturnCode#THREAD_STOPPED}, {@link ReturnCode#THREAD_RUNNING}*/
  public ReturnCode transmitThreadStatus;

  /**
   * The status of the receive thread 
   * {@link Driver.CANDevice.ReceiveData}. It could  be 
   * {@link ReturnCode#THREAD_STOPPED}, {@link ReturnCode#THREAD_RUNNING}*/
  public ReturnCode receiveThreadStatus;

  /** The default constructor of the ErrorBuffer. */
  public ErrorBuffer()
  {
    // Do nothing
  }

  /** Reset the error buffer. */
  public void resetBuffer()
  {
  }
}
