package API.ADK;

/**
 * Structure of the Message (Frame format, Message ID, Frame type, Data, 
 * Data length, Timestamp). This structure is used to retrieve a 
 * message from the receive message buffer or send a message.
 * @author hroesdiyono
 *
 */
public class MessageStructure
{
    /**
     * The frame format of the message, {@link API.ADK.ConstantList#STANDARD_FRAME} 
     * or {@link API.ADK.ConstantList#EXTENDED_FRAME}.
     */
    public byte frameFormat;

    /** The value of the message ID. */
    public int messageID;

    /** The frame type of the message, {@link API.ADK.ConstantList#DATA_FRAME} or 
     * {@link API.ADK.ConstantList#REMOTE_FRAME}.
     */
    public byte frameType;

    /** The length of the data. */
    public byte dataLength;

    /**
     * The array of data. 
     * For a better performance, the data array always contains 8byte.  
     * The length of the valid data is {@link MessageStructure#dataLength}. 
     * For REMOTE_FRAME, the data array contains invalid data, even though 
     * the dataLenght is not zero.
     */
    public int data[] = new int[8];

    /**
     * The time stamp of the message. 
     * The system time in milliseconds since January 1, 1970 00:00:00 UTC.
     */
    public long timeStamp;

    /** The default constructor of the MessageStructure. */
    public MessageStructure() {
        // Do nothing.
    }
}