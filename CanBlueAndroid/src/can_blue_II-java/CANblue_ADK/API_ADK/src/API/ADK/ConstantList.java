package API.ADK;

import java.util.UUID;

/**
 * Contain list of constants used by the {@link API_ADK} and {@link Driver} classes.
 * @author hroesdiyono
 */
public interface ConstantList
{
  /** The limitation of Message Channel when using Hardware filter. */
  public final byte HARDWARE_CHANNEL_LIMITATION = 1;

  /** The length (number of lines) of the response buffer. */
  public final int RESPONSE_BUFFER_LENGTH = 8000;

  /** The length (number of lines) of the receive buffer. */
  public final int RECEIVE_BUFFER_LENGTH = 4096;

  /** The length (number of lines) of the error buffer. */
  public final int ERROR_BUFFER_LENGTH = 100;

  /**
   * The number of loop (in {@value API.ADK.ConstantList#SLEEP_TIME}ms unit)
   * needed to wait for a response after sending a command.
   */
  public final int WAITING_FOR_RESPONSE = 60;
  /** Sleep time for a thread in ms. */
  public final int SLEEP_TIME = 100;

  /** The limitation of software filter length for both STD and EXT ID. */
  public final int MAXIMUM_FILTER_LENGTH = 2048;

  /** Default Insecure UUID. */
  public final UUID MY_UUID_INSECURE = UUID.fromString(
      "00001101-0000-1000-8000-00805F9B34FB");

  /**
   * The maximum number of bytes taken from the Bluetooth receive buffer
   * at one time inside the receive thread.
   */
  public final int BYTE_BUFFER_LENGTH = 2048;

  /** The maximum length of the sending message array. */
  public final byte MAXIMUM_MESSAGE_ARRAY_LENGTH = 50;

  /** The maximum possible value for a byte variable. */
  public final byte MAXIMUM_BYTE_SIZE = 127;

  /** Input for receiveFilterType. */
  public static final byte HARDWARE_FILTER = 0, SOFTWARE_FILTER = 1;

  /** Input for frameFormat. */
  public static final byte STANDARD_FRAME = 0, EXTENDED_FRAME = 1;

  /** Input for frameType. BOTH_FRAME is only used internally for filtering. */
  public static final byte DATA_FRAME = 1, REMOTE_FRAME = 2, BOTH_FRAME = 3;

  /** Input for busCoupling. */
  public static final byte HIGH_BUSCOUPLING = 0, LOW_BUSCOUPLING = 1;

  /** Input for latencySetting. */
  public static final byte DEFAULT_LATENCY = 0, SHORTEST_LATENCY = 1;

  /** Input for controllerStatus. */
  public static final byte CONTROLLER_STOPPED = 0, CONTROLLER_STARTED = 1;

  /** Input for mode of CANblueSendCANFrames. */
  public static final byte SEND_FRAME_OFF = 0, SEND_FRAME_ASCII = 1,
      SEND_FRAME_BINARY = 2;

  /** Input for transmit message format. */
  public static final byte BINARY_FORMAT = 0, ASCII_FORMAT = 1;
}
