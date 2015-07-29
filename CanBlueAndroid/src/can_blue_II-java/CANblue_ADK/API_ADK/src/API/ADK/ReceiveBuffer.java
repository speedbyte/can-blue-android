package API.ADK;

import java.util.concurrent.Semaphore;

/**
 * The Receive Message buffer. This buffer is filled inside the receive 
 * thread and taken by {@link Driver.CANDevice.CANMessage#receiveMessage} and 
 * {@link Driver.CANDevice.CANMessage#receiveBufferStatus}.
 * @author hroesdiyono
 */
public class ReceiveBuffer
{
  /**
   * The length (number of line) is defined in the 
   * {@link API.ADK.ConstantList#RECEIVE_BUFFER_LENGTH}.
   */
  public final int bufferLength = ConstantList.RECEIVE_BUFFER_LENGTH;
  /** The message buffer. */
  private MessageStructure[] buffer = new MessageStructure[bufferLength];
  /** The current pointer for taken message. */
  private volatile int bufferGet = 0;
  /** The current pointer for put message. */
  private volatile int bufferPut = 0;
  /** The current remaining message inside the buffer. */
  private volatile int bufferCount = 0;
  /**
   * The status of the error buffer, {@link ReturnCode#RECEIVE_BUFFER_NO_STATUS} 
   * or {@link ReturnCode#RECEIVE_BUFFER_OVERRUN}.
   */
  public ReturnCode receiveBufferStatus = ReturnCode.RECEIVE_BUFFER_NO_STATUS;

  /** Semaphore for writing and reading to the buffer and variables. */
  Semaphore bufferSemaphore = new Semaphore(1, false);

  /** The default constructor of the ReceiveBuffer. */
  public ReceiveBuffer()
  {
     // Initialize the buffer.
    for (int i = 0; i < bufferLength; i++)
    {
      buffer[i] = new MessageStructure();
    }

  }

  /**
   * Put a message into the receive buffer.
   * @param receiveBuffer Input: The input message.
   * @return {@link ReturnCode#SUCCESS}, 
   *         {@link ReturnCode#RECEIVE_BUFFER_FULL}, 
   *         {@link ReturnCode#EXCEPTION_SEMAPHORE_ACQUIRE}, or 
   *         {@link ReturnCode#EXCEPTION_SEMAPHORE_RELEASE}.
   */
  public ReturnCode queuePut(MessageStructure receiveBuffer)
  {
    try
    {
      bufferSemaphore.acquire();
    }
    catch (InterruptedException e)
    {
      e.printStackTrace();
      return ReturnCode.EXCEPTION_SEMAPHORE_ACQUIRE;
  }
    if (bufferCount < bufferLength)
    {
      buffer[bufferPut].frameFormat = receiveBuffer.frameFormat;
      buffer[bufferPut].messageID = receiveBuffer.messageID;
      buffer[bufferPut].frameType = receiveBuffer.frameType;
      buffer[bufferPut].dataLength = receiveBuffer.dataLength;
      buffer[bufferPut].timeStamp = receiveBuffer.timeStamp;
      if (buffer[bufferPut].frameType == API_ADK.DATA_FRAME)
      {
        for (int i = 0; i < buffer[bufferPut].dataLength; i++)
        {
          buffer[bufferPut].data[i] = receiveBuffer.data[i];
        }
      }
      /*buffer[bufferPut] = new MessageStructure(receiveBuffer);*/
      if (++bufferPut >= bufferLength)
      {
        bufferPut = 0;
      }
      bufferCount++;
      try
      {
        bufferSemaphore.release();
      }
      catch (Exception e)
      {
        e.printStackTrace();
        return ReturnCode.EXCEPTION_SEMAPHORE_RELEASE;
      }
      return ReturnCode.SUCCESS;
    }
    else
    {
      receiveBufferStatus = ReturnCode.RECEIVE_BUFFER_OVERRUN;
      bufferSemaphore.release();
      return ReturnCode.RECEIVE_BUFFER_FULL;
    }
  }

  /**
   * Take a message from the receive buffer.
   * @param receiveBuffer Output: The output message.
   * @return {@link ReturnCode#SUCCESS}, 
   *         {@link ReturnCode#RECEIVE_BUFFER_EMPTY}, 
   *         {@link ReturnCode#EXCEPTION_SEMAPHORE_ACQUIRE}, or 
   *         {@link ReturnCode#EXCEPTION_SEMAPHORE_RELEASE}.
   */
  public ReturnCode queueGet(MessageStructure receiveBuffer)
  {
    try
    {
      bufferSemaphore.acquire();
    }
    catch (InterruptedException e)
    {
      e.printStackTrace();
      return ReturnCode.EXCEPTION_SEMAPHORE_ACQUIRE;
    }
    if (bufferCount > 0)
    {
      receiveBuffer.frameFormat = buffer[bufferGet].frameFormat;
      receiveBuffer.messageID = buffer[bufferGet].messageID;
      receiveBuffer.frameType = buffer[bufferGet].frameType;
      receiveBuffer.dataLength = buffer[bufferGet].dataLength;
      receiveBuffer.timeStamp = buffer[bufferGet].timeStamp;
      if (receiveBuffer.frameType == API_ADK.DATA_FRAME)
      {
        for (int i = 0; i < receiveBuffer.dataLength; i++)
        {
          receiveBuffer.data[i] = buffer[bufferGet].data[i];
        }
      }
      if (++bufferGet >= bufferLength)
      {
        bufferGet = 0;
      }
      bufferCount--;
      if ((bufferCount == 0) && (bufferGet != bufferPut)){
        bufferPut = bufferGet;
      }
      try
      {
        bufferSemaphore.release();
      }
      catch (Exception e)
      {
        e.printStackTrace();
        return ReturnCode.EXCEPTION_SEMAPHORE_RELEASE;
      }
      return ReturnCode.SUCCESS;
    }
    else
    {
      // Reset the buffer.
      //resetBuffer();
      bufferSemaphore.release();
      return ReturnCode.RECEIVE_BUFFER_EMPTY;
    }
  }

  /** Reset the receive buffer and its status. */
  public void resetBuffer()
  {
    bufferGet = 0;
    bufferPut = 0;
    bufferCount = 0;
    receiveBufferStatus = ReturnCode.RECEIVE_BUFFER_NO_STATUS;
  }
}