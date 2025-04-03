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

package io.ballerina.stdlib.etl.utils;

import io.ballerina.runtime.api.creators.ErrorCreator;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BString;

/**
 * Represents the errors of ETL module.
 */

public class ErrorUtils {

    private ErrorUtils() {
    }

    public static BError createCommonFieldNotFoundError(int datasetIndex) {
        return ErrorCreator.createError(
                StringUtils.fromString(String.format("The dataset%d does not contain the field - '%s'", datasetIndex,
                        "fieldName")));
    }

    public static BError createNoMatchesFoundError() {
        return ErrorCreator.createError(StringUtils.fromString("No matching records found"));
    }

    public static BError createFieldNotFoundError(BString fieldName) {
        return ErrorCreator
                .createError(StringUtils
                        .fromString(
                                String.format("The dataset does not contain the field - '%s'", fieldName)));
    }

    public static BError createInvalidFieldTypeError(BString fieldName, String expectedType, String actualType) {
        return ErrorCreator.createError(StringUtils.fromString(
                String.format("The field '%s' is expected to be of type '%s' but found '%s'", fieldName,
                        expectedType,
                        actualType)));
    }

    public static BError createInvalidRatioError(float ratio) {
        return ErrorCreator.createError(StringUtils.fromString(
                String.format("Invalid ratio value: %f. Ratio should be between 0 and 1", ratio)));
    }

    public static BError createClientConnectionError() {
        return ErrorCreator.createError(StringUtils.fromString("Operation failed due to client connector error"));
    }

    public static BError createIdleTimeoutError() {
        return ErrorCreator.createError(
                StringUtils.fromString("Operation failed due to idle timeout. Size of the dataset may be too large"));
    }
}
