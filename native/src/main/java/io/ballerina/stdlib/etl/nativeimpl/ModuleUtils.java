/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
 * 
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.etl.nativeimpl;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.Module;

/**
 * This class will hold module related utility functions.
 *
 * @since 0.8.0
 */
public class ModuleUtils {

  private static Module etlModule;

  private ModuleUtils() {
  }

  public static void setModule(Environment env) {
    etlModule = env.getCurrentModule();
  }

  public static Module getModule() {
    return etlModule;
  }
}
