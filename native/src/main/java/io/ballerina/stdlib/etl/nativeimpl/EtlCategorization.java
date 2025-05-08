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

import static io.ballerina.stdlib.etl.utils.CommonUtils.getFieldType;
import static io.ballerina.stdlib.etl.utils.CommonUtils.processResponseToNestedBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeNestedBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.isFieldExist;
import static io.ballerina.stdlib.etl.utils.CommonUtils.isNumericType;
import static io.ballerina.stdlib.etl.utils.CommonUtils.isStringType;
import static io.ballerina.stdlib.etl.utils.CommonUtils.mergeNestedBArrays;

/**
 * This class hold Java external functions for ETL - data categorization APIs.
 *
 * * @since 0.8.0
 */
@SuppressWarnings("unchecked")
public class EtlCategorization {

    public static final String CATEGORIZE_SEMANTIC = "categorizeSemanticFunc";
    public static final String INT_OR_FLOAT = String.format("%s or %s", TypeConstants.INT_TNAME,
            TypeConstants.FLOAT_TNAME);

    public static Object categorizeNumeric(BArray dataset, BString fieldName, BArray rangeArray, BTypedesc returnType) {
        if (!isFieldExist(dataset, fieldName)) {
            return ErrorUtils.createETLError(String.format("The dataset does not contain the field - '%s'", fieldName));
        }
        Type fieldType = getFieldType(returnType, fieldName);
        if (!isNumericType(fieldType)) {
            return ErrorUtils
                    .createETLError(String.format("The field '%s' is expected to be of type '%s' but found '%s'",
                            fieldName, TypeConstants.STRING_TNAME, fieldType.toString()));
        }
        double lowerBound = rangeArray.getFloat(0);
        if (TypeUtils.getType(rangeArray.get(1)).getTag() != TypeTags.ARRAY_TAG) {
            ErrorUtils.createETLError("Invalid range array");
        }
        BArray midRanges = (BArray) rangeArray.get(1);
        double upperBound = rangeArray.getFloat(2);
        int numCategories = midRanges.size() + 1;
        BArray categorizedData = initializeNestedBArray(returnType, numCategories);
        for (int i = 0; i < dataset.size(); i++) {
            if (TypeUtils.getType(dataset.get(i)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                continue;
            }
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            if ((TypeUtils.getType(data.get(fieldName)).getTag() != TypeTags.FLOAT_TAG)
                    && (TypeUtils.getType(data.get(fieldName)).getTag() != TypeTags.INT_TAG)) {
                continue;
            }
            double fieldValue = data.get(fieldName) instanceof Double ? (double) data.get(fieldName)
                    : ((Long) data.get(fieldName)).doubleValue();
            if (fieldValue <= lowerBound || fieldValue > upperBound) {
                continue;
            }
            double prevBound = lowerBound;
            for (int j = 0; j < midRanges.size(); j++) {
                double nextBound = midRanges.getFloat(j);
                if (fieldValue > prevBound && fieldValue <= nextBound) {
                    if (TypeUtils.getType(categorizedData.get(j)).getTag() != TypeTags.ARRAY_TAG) {
                        ErrorUtils.createETLError("Error occurred while categorizing the data");
                    }
                    ((BArray) categorizedData.get(j)).append(data);
                    break;
                }
                prevBound = nextBound;
            }
            if (fieldValue > midRanges.getFloat(midRanges.size() - 1) && fieldValue <= upperBound) {
                ((BArray) categorizedData.get(midRanges.size())).append(data);
            }
        }
        return categorizedData;
    }

    public static Object categorizeRegex(BArray dataset, BString fieldName, BArray regexArray, BTypedesc returnType) {
        if (!isFieldExist(dataset, fieldName)) {
            return ErrorUtils.createETLError(String.format("The dataset does not contain the field - '%s'", fieldName));
        }
        Type fieldType = getFieldType(returnType, fieldName);
        if (!isStringType(fieldType)) {
            return ErrorUtils
                    .createETLError(String.format("The field '%s' is expected to be of type '%s' but found '%s'",
                            fieldName, TypeConstants.STRING_TNAME, fieldType.toString()));
        }
        BArray categorizedData = initializeNestedBArray(returnType, regexArray.size());
        for (int i = 0; i < dataset.size(); i++) {
            if (TypeUtils.getType(dataset.get(i)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                continue;
            }
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            if (TypeUtils.getType(data.get(fieldName)).getTag() != TypeTags.STRING_TAG) {
                continue;
            }
            BString fieldValue = StringUtils.fromString(data.get(fieldName).toString());
            for (int j = 0; j < regexArray.size(); j++) {
                if (TypeUtils.getType(regexArray.get(j)).getTag() != TypeTags.REG_EXP_TYPE_TAG) {
                    ErrorUtils.createETLError("Invalid regex pattern found in the given regex array");
                }
                BRegexpValue regexPattern = (BRegexpValue) regexArray.get(j);
                if (Matches.isFullMatch(regexPattern, fieldValue)) {
                    if (TypeUtils.getType(categorizedData.get(j)).getTag() != TypeTags.ARRAY_TAG) {
                        ErrorUtils.createETLError("Error occurred while categorizing the data");
                    }
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
            return ErrorUtils.createETLError(String.format("The dataset does not contain the field - '%s'", fieldName));
        }
        Type fieldType = getFieldType(returnType, fieldName);
        if (!isStringType(fieldType)) {
            return ErrorUtils
                    .createETLError(String.format("The field '%s' is expected to be of type '%s' but found '%s'",
                            fieldName, TypeConstants.STRING_TNAME, fieldType.toString()));
        }
        BArray mergedResult = initializeNestedBArray(returnType, categories.size());
        for (int i = 0; i < dataset.size(); i += 200) {
            int end = Math.min(i + 200, dataset.size());
            BArray chunk = dataset.slice(i, end);
            Object[] args = new Object[] { chunk, fieldName, categories };
            Object clientResponse = env.getRuntime().callFunction(env.getCurrentModule(), CATEGORIZE_SEMANTIC, null,
                    args);
            Object chunkResult = processResponseToNestedBArray(clientResponse, returnType);
            if (TypeUtils.getType(chunkResult).getTag() != TypeTags.ARRAY_TAG) {
                return chunkResult;
            }
            mergeNestedBArrays(mergedResult, (BArray) chunkResult);
        }
        return mergedResult;
    }
}
