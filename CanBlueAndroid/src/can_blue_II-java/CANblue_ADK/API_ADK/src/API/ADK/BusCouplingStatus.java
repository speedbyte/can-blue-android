package API.ADK;

/**
 * Enum of the Bus coupling status.
 * @author hroesdiyono
 */
public enum BusCouplingStatus
{
  /** The Bus coupling is low. */
  BUSCOUPLING_LOW,
  /** The Bus coupling is high. */
  BUSCOUPLING_HIGH,
  /**
   * There must be an error either in parsing or from the device 
   * if this value is read.
   */
  BUSCOUPLING_UNKNOWN
}
