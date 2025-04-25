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
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BString;

import static io.ballerina.stdlib.etl.nativeimpl.ModuleUtils.getModule;;

/**
 * Represents the errors of ETL module.
 */
public class ErrorUtils {

    public static final String ERROR = "Error";

    public static BError createETLError(BString message) {
        return ErrorCreator.createError(getModule(), ERROR, message, null, null);
    }

    public static BError createCommonFieldNotFoundError(int datasetIndex) {
        return createETLError(
                StringUtils.fromString(String.format("The dataset %d does not contain the field - '%s'", datasetIndex,
                        "fieldName")));
    }

    public static BError createNoMatchesFoundError() {
        return createETLError(StringUtils.fromString("No matching records found"));
    }

    public static BError createFieldNotFoundError(BString fieldName) {
        return createETLError(
                StringUtils.fromString(String.format("The dataset does not contain the field - '%s'", fieldName)));
    }

    public static BError createInvalidFieldTypeError(BString fieldName, String expectedType, Type actualType) {
        return createETLError(
                StringUtils.fromString(String.format("The field '%s' is expected to be of type '%s' but found '%s'",
                        fieldName, expectedType, actualType.toString())));
    }

    public static BError createInvalidDatasetError() {
        return createETLError(StringUtils.fromString("Datasets to be merged must be of type 'record[]{}'"));
    }

    public static BError createInvalidDatasetElementError() {
        return createETLError(
                StringUtils.fromString("The elements of the dataset are expected to be of type 'record{}'"));
    }

    public static BError createInvalidRangeArrayError() {
        return createETLError(StringUtils.fromString("Invalid range array"));
    }

    public static BError createInvalidRegexError() {
        return createETLError(StringUtils.fromString("Invalid regex pattern found in the given regex array"));
    }

    public static BError createInvalidRatioError(float ratio) {
        return createETLError(StringUtils.fromString(
                String.format("Invalid ratio value: %f. Ratio should be between 0 and 1", ratio)));
    }

    public static BError createInvalidReturnTypeError() {
        return createETLError(StringUtils.fromString("Invalid return type"));
    }

    public static BError createCategorizationError() {
        return createETLError(StringUtils.fromString("Error occurred while categorizing the data"));
    }

    public static BError createDeduplicationError() {
        return createETLError(StringUtils.fromString("Error occurred while deduplicating the data"));
    }

    public static BError createDecryptionError() {
        return createETLError(StringUtils.fromString("Error occurred while decrypting the data"));
    }

    public static BError createEncryptionError() {
        return createETLError(StringUtils.fromString("Error occurred while encrypting the data"));
    }

    public static BError createClientConnectionError() {
        return createETLError(StringUtils.fromString("Operation failed due to client connector error"));
    }

    public static BError createClientRequestError() {
        return createETLError(StringUtils
                .fromString("Operation failed due to client request error. Configuration values may be incorrect"));
    }

    public static BError createIdleTimeoutError() {
        return createETLError(StringUtils.fromString("Operation failed due to idle timeout error."));
    }

    public static BError createRemoteServerError() {
        return createETLError(StringUtils.fromString("Operation failed due to remote server error."));
    }

    public static BError createResponseError() {
        return createETLError(
                StringUtils.fromString("Operation failed due to an error occurred while getting the OpenAI response."));
    }
}
