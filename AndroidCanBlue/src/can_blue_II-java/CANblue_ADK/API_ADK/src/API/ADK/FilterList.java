package API.ADK;

/**
 * Structure for the Filter list.
 * It can be standard or extended filter list.
 * This class is used internally for software filtering and externally for 
 * reading the Filter list.
 * @author hroesdiyono
 */
public class FilterList {
  /** The length of the filter. It is defined at the creation of the object. */
  private int filterLength;

  /** The array of Message ID. */
  public int messageID[];

  /** The array of frameType, DATA or REMOTE. */
  public byte frameType[];

  /** The status of the filter. True for enable and false for disable. */
  public boolean filterStatus;

  /** The number of filter inside the array. */
  public int numberOfFilter;

  /**
   * The constructor of the FilterList.
   * @param inputFilterLength Input: Determine the number of ID inside
   *     the filter. The maximum length is 
   *     {@value API.ADK.ConstantList#MAXIMUM_FILTER_LENGTH}.
   */
  public FilterList(int inputFilterLength)
  {
    if (inputFilterLength >= ConstantList.MAXIMUM_FILTER_LENGTH)
    {
      // Limit the maximum length of the filter
      this.filterLength = ConstantList.MAXIMUM_FILTER_LENGTH;
    }
    else
    {
      this.filterLength = inputFilterLength;
    }
    this.messageID = new int[filterLength];
    this.frameType = new byte[filterLength];
    this.filterStatus = false;
    this.numberOfFilter = 0;
  }

  /** The default constructor of the FilterList. */
  public FilterList()
  {
    // Do nothing.
  }

  /** Clear the Software Filter List. */
  public void clearFilterList(){
    this.numberOfFilter = 0;
      for (int i = 0; i < this.filterLength; i++)
      {
        this.messageID[i] = -1;
        this.frameType[i] = -1;
      }
  }
}