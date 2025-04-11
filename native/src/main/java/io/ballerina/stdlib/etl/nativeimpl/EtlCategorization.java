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
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BRegexpValue;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.etl.utils.ErrorUtils;

import static io.ballerina.stdlib.etl.utils.CommonUtils.convertJSONToNestedBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.getFieldType;
import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeNestedBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.isFieldExist;
import static io.ballerina.stdlib.etl.utils.Constants.CATEGORIZE_SEMANTIC;
import static io.ballerina.stdlib.etl.utils.Constants.CLIENT_CONNECTOR_ERROR;
import static io.ballerina.stdlib.etl.utils.Constants.FLOAT;
import static io.ballerina.stdlib.etl.utils.Constants.IDLE_TIMEOUT_ERROR;
import static io.ballerina.stdlib.etl.utils.Constants.INT;
import static io.ballerina.stdlib.etl.utils.Constants.INT_OR_FLOAT;
import static io.ballerina.stdlib.etl.utils.Constants.STRING;

/**
 * This class hold Java external functions for ETL - data categorization APIs.
 *
 * * @since 0.8.0
 */
@SuppressWarnings("unchecked")
public class EtlCategorization {

    public static Object categorizeNumeric(BArray dataset, BString fieldName, BArray rangeArray, BTypedesc returnType) {
        if (!isFieldExist(dataset, fieldName)) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        String fieldType = getFieldType(returnType, fieldName);
        if (!fieldType.contains(INT) && !fieldType.contains(FLOAT)) {
            return ErrorUtils.createInvalidFieldTypeError(fieldName, INT_OR_FLOAT, fieldType);
        }
        float lowerBound = Float.parseFloat(String.valueOf(rangeArray.get(0)));
        BArray midRanges = (BArray) rangeArray.get(1);
        float upperBound = Float.parseFloat(String.valueOf(rangeArray.get(2)));
        int numCategories = midRanges.size() + 1;
        BArray categorizedData = initializeNestedBArray(returnType, numCategories);
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            if (!data.containsKey(fieldName)) {
                ((BArray) categorizedData.get(numCategories)).append(data);
                continue;
            }
            float fieldValue = Float.parseFloat(String.valueOf(data.get(fieldName)));
            if (fieldValue <= lowerBound || fieldValue > upperBound) {
                continue;
            }
            float prevBound = lowerBound;
            for (int j = 0; j < midRanges.size(); j++) {
                float nextBound = Float.parseFloat(String.valueOf(midRanges.get(j)));
                if (fieldValue > prevBound && fieldValue <= nextBound) {
                    ((BArray) categorizedData.get(j)).append(data);
                    break;
                }
                prevBound = nextBound;
            }
            if (fieldValue > Float.parseFloat(String.valueOf(midRanges.get(midRanges.size() - 1)))
                    && fieldValue <= upperBound) {
                ((BArray) categorizedData.get(midRanges.size())).append(data);
            }
        }
        return categorizedData;
    }

    public static Object categorizeRegex(BArray dataset, BString fieldName, BArray regexArray, BTypedesc returnType) {
        if (!isFieldExist(dataset, fieldName)) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        String fieldType = getFieldType(returnType, fieldName);
        if (!fieldType.contains(STRING)) {
            return ErrorUtils.createInvalidFieldTypeError(fieldName, STRING, fieldType);
        }
        BArray categorizedData = initializeNestedBArray(returnType, regexArray.size());
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            if (!data.containsKey(fieldName)) {
                ((BArray) categorizedData.get(regexArray.size())).append(data);
                continue;
            }
            String fieldValue = String.valueOf(data.get(fieldName));
            for (int j = 0; j < regexArray.size(); j++) {
                BRegexpValue regexPattern = (BRegexpValue) regexArray.get(j);
                if (fieldValue.matches(regexPattern.toString())) {
                    ((BArray) categorizedData.get(j)).append(data);
                    break;
                }
            }
        }
        return categorizedData;

    }

    public static Object categorizeSemantic(Environment env, BArray dataset, BString fieldName, BArray categories,
            BTypedesc returnType) {
        if (!isFieldExist(dataset, fieldName)) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        String fieldType = getFieldType(returnType, fieldName);
        if (!fieldType.contains(STRING)) {
            return ErrorUtils.createInvalidFieldTypeError(fieldName, STRING, fieldType);
        }
        Object[] args = new Object[] { dataset, fieldName, categories };
        Object clientResponse = env.getRuntime().callFunction(env.getCurrentModule(), CATEGORIZE_SEMANTIC, null,
                args);
        switch (TypeUtils.getType(clientResponse).getName()) {
            case CLIENT_CONNECTOR_ERROR:
                return ErrorUtils.createClientConnectionError();
            case IDLE_TIMEOUT_ERROR:
                return ErrorUtils.createIdleTimeoutError();
            default:
                return convertJSONToNestedBArray(clientResponse, returnType);
        }
    }
}
