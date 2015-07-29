package API.ADK;

/**
 * Enum of the Controller status.
 * @author hroesdiyono
 *
 */
public enum ControllerStatus
{
  /** The controller is stopped. */
  CONTROLLER_START,
  /** The controller is started. */
  CONTROLLER_STOP,
  /**
   * There must be an error either in parsing or from the device 
   * if this value is read.
   */
  CONTROLLER_UNKNOWN
}
