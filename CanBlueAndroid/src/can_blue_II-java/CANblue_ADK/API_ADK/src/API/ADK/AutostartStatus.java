package API.ADK;

/**
 * Enum of the Autostart status.
 * @author hroesdiyono
 */
public enum AutostartStatus
{
  /** Autostart is on. */
  AUTOSTART_ON,
  /** Autostart is on. */
  AUTOSTART_OFF,
  /**
   * There must be an error either in parsing or from the device 
   * if this value is read.
   */
  AUTOSTART_UNKNOWN
}
