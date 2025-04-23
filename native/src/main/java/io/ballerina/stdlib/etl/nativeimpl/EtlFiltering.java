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

import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BRegexpValue;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.etl.utils.ErrorUtils;
import org.ballerinalang.langlib.regexp.Matches;

import java.util.ArrayList;
import java.util.Collections;

import static io.ballerina.stdlib.etl.utils.CommonUtils.copyBMap;
import static io.ballerina.stdlib.etl.utils.CommonUtils.evaluateCondition;
import static io.ballerina.stdlib.etl.utils.CommonUtils.getFieldType;
import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.isFieldExist;

/**
 * This class hold Java external functions for ETL - data filtering APIs.
 *
 * * @since 0.8.0
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
        int splitIndex = (int) Math.ceil(suffledDataset.size() * ratio);
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
        if (!field.contains("string")) {
            return ErrorUtils.createInvalidFieldTypeError(fieldName, "string", field);
        }
        BArray filteredDataset = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> newData = copyBMap((BMap<BString, Object>) dataset.get(i), returnType);
            if (!newData.containsKey(fieldName)) {
                continue;
            }
            BString fieldvalue = StringUtils.fromString(newData.get(fieldName).toString());
            if (Matches.isFullMatch(regexPattern, fieldvalue)) {
                ((BArray) filteredDataset).append(newData);
            }
        }
        return filteredDataset;
    }

    public static Object filterDataByRelativeExp(BArray dataset, BString fieldName, BString operation, double value,
            BTypedesc returnType) {
        if (!isFieldExist(dataset, fieldName)) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        String field = getFieldType(returnType, fieldName);
        if (!field.contains("int") && !field.contains("float")) {
            return ErrorUtils.createInvalidFieldTypeError(fieldName, "int or float", field);
        }
        BArray filteredDataset = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> newData = copyBMap((BMap<BString, Object>) dataset.get(i), returnType);
            if (!newData.containsKey(fieldName)) {
                continue;
            }
            double fieldValue = newData.get(fieldName) instanceof Double ? (double) newData.get(fieldName)
                    : ((Long) newData.get(fieldName)).doubleValue();
            if (evaluateCondition(fieldValue, value, operation.getValue())) {
                ((BArray) filteredDataset).append(newData);
            }
        }
        return filteredDataset;
    }
}
