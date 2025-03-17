package io.ballerina.stdlib.etl.nativeimpl;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.Module;

/**
 * This class will hold module related utility functions.
 *
 * @since 2.0.0
 */
public class ModuleUtils {

  /**
   * I/O standard library package ID.
   */
  private static Module etlModule = null;

  private ModuleUtils() {
  }

  public static void setModule(Environment env) {
    etlModule = env.getCurrentModule();
  }

  public static Module getModule() {
    return etlModule;
  }
}
