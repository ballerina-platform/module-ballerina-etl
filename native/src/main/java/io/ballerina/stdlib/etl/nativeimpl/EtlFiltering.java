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

import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BRegexpValue;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.etl.utils.ErrorUtils;

import java.util.ArrayList;
import java.util.Collections;

import static io.ballerina.stdlib.etl.utils.CommonUtils.copyBMap;
import static io.ballerina.stdlib.etl.utils.CommonUtils.evaluateCondition;
import static io.ballerina.stdlib.etl.utils.CommonUtils.getFieldType;
import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.isFieldExist;
import static io.ballerina.stdlib.etl.utils.Constants.FLOAT;
import static io.ballerina.stdlib.etl.utils.Constants.INT;
import static io.ballerina.stdlib.etl.utils.Constants.INT_OR_FLOAT;
import static io.ballerina.stdlib.etl.utils.Constants.STRING;

/**
 * This class hold Java external functions for ETL - data filtering APIs.
 *
 * * @since 1.0.0
 */
@SuppressWarnings("unchecked")
public class EtlFiltering {

    public static Object filterDataByRatio(BArray dataset, float ratio, BTypedesc returnType) {
        if (ratio < 0 || ratio > 1) {
            return ErrorUtils.createInvalidRatioError(ratio);
        }
        BArray filteredDataset = initializeBArray(returnType);
        ArrayList<Object> suffledDataset = new ArrayList<>();
        for (int i = 0; i < dataset.size(); i++) {
            suffledDataset.add(copyBMap((BMap<BString, Object>) dataset.get(i), returnType));
        }
        Collections.shuffle(suffledDataset);
        int splitIndex = (int) (suffledDataset.size() * ratio);
        for (int i = 0; i < splitIndex; i++) {
            ((BArray) filteredDataset).append(suffledDataset.get(i));
        }
        return filteredDataset;
    }

    public static Object filterDataByRegex(BArray dataset, BString fieldName, BRegexpValue regexPattern,
            BTypedesc returnType) {
        if (!isFieldExist(dataset, fieldName)) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        String field = getFieldType(returnType, fieldName);
        if (!field.contains(STRING)) {
            return ErrorUtils.createInvalidFieldTypeError(fieldName, STRING, field);
        }
        BArray filteredDataset = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> newData = copyBMap((BMap<BString, Object>) dataset.get(i), returnType);
            if (!newData.containsKey(fieldName)) {
                continue;
            }
            String fieldvalue = newData.get(fieldName).toString();
            if (fieldvalue.matches(regexPattern.toString())) {
                ((BArray) filteredDataset).append(newData);
            }
        }
        return filteredDataset;
    }

    public static Object filterDataByRelativeExp(BArray dataset, BString fieldName, BString operation, float value,
            BTypedesc returnType) {
        if (!isFieldExist(dataset, fieldName)) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        String field = getFieldType(returnType, fieldName);
        if (!field.contains(INT) && !field.contains(FLOAT)) {
            return ErrorUtils.createInvalidFieldTypeError(fieldName, INT_OR_FLOAT, field);
        }
        BArray filteredDataset = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> newData = copyBMap((BMap<BString, Object>) dataset.get(i), returnType);
            if (!newData.containsKey(fieldName)) {
                continue;
            }
            float fieldValue = Float.parseFloat(newData.get(fieldName).toString());
            if (evaluateCondition(fieldValue, value, operation.getValue())) {
                ((BArray) filteredDataset).append(newData);
            }
        }
        return filteredDataset;
    }
}
