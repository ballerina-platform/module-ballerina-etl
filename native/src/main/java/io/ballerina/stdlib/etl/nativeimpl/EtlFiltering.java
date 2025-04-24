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

import io.ballerina.runtime.api.constants.TypeConstants;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.types.TypeTags;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
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
import static io.ballerina.stdlib.etl.utils.CommonUtils.isNumericType;
import static io.ballerina.stdlib.etl.utils.CommonUtils.isStringType;

/**
 * This class hold Java external functions for ETL - data filtering APIs.
 *
 * * @since 0.8.0
 */
@SuppressWarnings("unchecked")
public class EtlFiltering {

    public static final String INT_OR_FLOAT = String.format("%s or %s", TypeConstants.INT_TNAME,
            TypeConstants.FLOAT_TNAME);

    public static Object filterDataByRatio(BArray dataset, float ratio, BTypedesc returnType) {
        if (ratio < 0 || ratio > 1) {
            return ErrorUtils.createInvalidRatioError(ratio);
        }
        BArray filteredDataset = initializeBArray(returnType);
        ArrayList<Object> suffledDataset = new ArrayList<>();
        for (int i = 0; i < dataset.size(); i++) {
            if (TypeUtils.getType(dataset.get(i)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                ErrorUtils.createInvalidDatasetElementError();
            }
            suffledDataset.add(copyBMap((BMap<BString, Object>) dataset.get(i), returnType));
        }
        Collections.shuffle(suffledDataset);
        int splitIndex = Math.round(suffledDataset.size() * ratio);
        for (int i = 0; i < splitIndex; i++) {
            filteredDataset.append(suffledDataset.get(i));
        }
        return filteredDataset;
    }

    public static Object filterDataByRegex(BArray dataset, BString fieldName, BRegexpValue regexPattern,
            BTypedesc returnType) {
        if (!isFieldExist(dataset, fieldName)) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        Type fieldType = getFieldType(returnType, fieldName);
        if (!isStringType(fieldType)) {
            return ErrorUtils.createInvalidFieldTypeError(fieldName, TypeConstants.STRING_TNAME, fieldType);
        }
        BArray filteredDataset = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i++) {
            if (TypeUtils.getType(dataset.get(i)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                ErrorUtils.createInvalidDatasetElementError();
            }
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            if (TypeUtils.getType(data.get(fieldName)).getTag() != TypeTags.STRING_TAG) {
                continue;
            }
            BMap<BString, Object> newData = copyBMap(data, returnType);
            BString fieldvalue = StringUtils.fromString(newData.get(fieldName).toString());
            if (Matches.isFullMatch(regexPattern, fieldvalue)) {
                filteredDataset.append(newData);
            }
        }
        return filteredDataset;
    }

    public static Object filterDataByRelativeExp(BArray dataset, BString fieldName, BString operation, double value,
            BTypedesc returnType) {
        if (!isFieldExist(dataset, fieldName)) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        Type fieldType = getFieldType(returnType, fieldName);
        if (!isNumericType(fieldType)) {
            return ErrorUtils.createInvalidFieldTypeError(fieldName, INT_OR_FLOAT, fieldType);
        }
        BArray filteredDataset = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i++) {
            if (TypeUtils.getType(dataset.get(i)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                ErrorUtils.createInvalidDatasetElementError();
            }
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            BMap<BString, Object> newData = copyBMap(data, returnType);
            if (TypeUtils.getType(data.get(fieldName)).getTag() != TypeTags.FLOAT_TAG
                    && TypeUtils.getType(data.get(fieldName)).getTag() != TypeTags.INT_TAG) {
                continue;
            }
            double fieldValue = newData.get(fieldName) instanceof Double ? (double) newData.get(fieldName)
                    : ((Long) newData.get(fieldName)).doubleValue();
            if (evaluateCondition(fieldValue, value, operation.getValue())) {
                filteredDataset.append(newData);
            }
        }
        return filteredDataset;
    }
}
