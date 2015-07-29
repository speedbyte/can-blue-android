package API.ADK;

/**
 * Enum of the Filter status.
 * @author hroesdiyono
 */
public enum FilterStatus
{
  FILTER_ENABLED,
  FILTER_DISABLED,
  /**
   * There must be an error either in parsing or from the device 
   * if this value is read.
   */
  UNKNOWN_STATUS
}
