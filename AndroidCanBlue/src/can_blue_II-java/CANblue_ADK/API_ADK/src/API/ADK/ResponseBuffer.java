package API.ADK;

/**
 * The Response buffer used to communicate between the receive thread 
 * and the CANDevice class.
 * @author hroesdiyono
 */
public class ResponseBuffer
{
  /** The length of the response buffer. */
  public final int bufferLength = ConstantList.RESPONSE_BUFFER_LENGTH;
  /** The response buffer. */
  public volatile String[] buffer = new String[this.bufferLength];
  /** The length of the current response. */
  public volatile int bufferIndex = 0;
  /** The flag of the buffer. True if there is any response. */
  public volatile boolean responseFlag = false;

  /** The default constructor of the ResponseBuffer. */
  public ResponseBuffer()
  {
    // Do nothing.
  }

  /** Reset the buffer index and the response flag. */
  public void resetResponseBuffer()
  {
    bufferIndex = 0;
    responseFlag = false;
  }
}