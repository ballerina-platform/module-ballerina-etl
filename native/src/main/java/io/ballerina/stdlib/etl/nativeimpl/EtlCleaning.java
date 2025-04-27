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

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import static io.ballerina.stdlib.etl.utils.CommonUtils.copyBMap;
import static io.ballerina.stdlib.etl.utils.CommonUtils.getFieldType;
import static io.ballerina.stdlib.etl.utils.CommonUtils.getFields;
import static io.ballerina.stdlib.etl.utils.CommonUtils.processResponseToBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.processResponseToNestedBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeBMap;
import static io.ballerina.stdlib.etl.utils.CommonUtils.isFieldExist;
import static io.ballerina.stdlib.etl.utils.CommonUtils.isStringType;

/**
 * This class hold Java external functions for ETL - data cleaning APIs.
 *
 * * @since 0.8.0
 */
@SuppressWarnings("unchecked")
public class EtlCleaning {

    public static final String ASCENDING = "ascending";
    public static final String GET_UNIQUE_DATA = "getUniqueData";
    public static final String GROUP_APPROXIMATE_DUPLICATES = "groupApproximateDuplicatesFunc";
    public static final String REGEX_MULTIPLE_WHITESPACE = "\\s+";
    public static final String SINGLE_WHITESPACE = " ";
    public static final String STANDARDIZE_DATA = "standardizeDataFunc";

    public static Object groupApproximateDuplicates(Environment env, BArray dataset, BTypedesc returnType) {
        Object[] args = new Object[] { dataset };
        Object clientResponse = env.getRuntime().callFunction(env.getCurrentModule(), GROUP_APPROXIMATE_DUPLICATES,
                null, args);
        return processResponseToNestedBArray(clientResponse, returnType);
    }

    public static Object handleWhiteSpaces(BArray dataset, BTypedesc returnType) {
        BArray cleanedDataset = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i++) {
            if (TypeUtils.getType(dataset.get(i)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                continue;
            }
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            BMap<BString, Object> newData = initializeBMap(returnType);
            for (BString field : data.getKeys()) {
                if (TypeUtils.getType(data.get(field)).getTag() == TypeTags.STRING_TAG) {
                    String fieldValue = data.get(field).toString();
                    String newFieldValue = fieldValue.replaceAll(REGEX_MULTIPLE_WHITESPACE, SINGLE_WHITESPACE)
                            .trim();
                    newData.put(field, StringUtils.fromString(newFieldValue));
                } else {
                    newData.put(field, data.get(field));
                }
            }
            cleanedDataset.append(newData);
        }
        return cleanedDataset;
    }

    public static Object removeDuplicates(Environment env, BArray dataset, BTypedesc returnType) {
        BArray deDuplicatedDataset = initializeBArray(returnType);
        Object[] args = new Object[] { dataset };
        Object uniqueItems = env.getRuntime().callFunction(env.getCurrentModule(),
                GET_UNIQUE_DATA, null, args);
        if (TypeUtils.getType(uniqueItems).getTag() != TypeTags.ARRAY_TAG) {
            ErrorUtils.createDeduplicationError();
        }
        for (int i = 0; i < ((BArray) uniqueItems).size(); i++) {
            if (TypeUtils.getType(((BArray) uniqueItems).get(i)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                continue;
            }
            BMap<BString, Object> newData = copyBMap((BMap<BString, Object>) ((BArray) uniqueItems).get(i), returnType);
            deDuplicatedDataset.append(newData);
        }
        return deDuplicatedDataset;
    }

    public static Object removeField(BArray dataset, BString fieldName, BTypedesc returnType) {
        if (!isFieldExist(dataset, fieldName)) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        BArray newDataset = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i++) {
            if (TypeUtils.getType(dataset.get(i)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                continue;
            }
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            BMap<BString, Object> newData = initializeBMap(returnType);
            for (BString key : data.getKeys()) {
                if (!key.equals(fieldName)) {
                    newData.put(key, data.get(key));
                }
            }
            newDataset.append(newData);
        }
        return newDataset;
    }

    public static Object removeEmptyValues(BArray dataset, BTypedesc returnType) {
        BArray cleanedDataset = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i++) {
            if (TypeUtils.getType(dataset.get(i)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                continue;
            }
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            boolean isNull = false;
            for (BString field : getFields(returnType)) {
                if (data.get(field) == null
                        || data.get(field).toString().trim().isEmpty()) {
                    isNull = true;
                    break;
                }
            }
            if (!isNull) {
                BMap<BString, Object> newData = initializeBMap(returnType);
                for (BString key : data.getKeys()) {
                    newData.put(key, data.get(key));
                }
                cleanedDataset.append(newData);
            }
        }
        return cleanedDataset;
    }

    public static Object replaceText(BArray dataset, BString fieldName, BRegexpValue searchValue, BString replaceValue,
            BTypedesc returnType) {
        if (!isFieldExist(dataset, fieldName)) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        Type fieldType = getFieldType(returnType, fieldName);
        if (!isStringType(fieldType)) {
            return ErrorUtils.createInvalidFieldTypeError(fieldName, TypeConstants.STRING_TNAME, fieldType);
        }
        BArray newDataset = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i++) {
            if (TypeUtils.getType(dataset.get(i)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                continue;
            }
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            if (TypeUtils.getType(data.get(fieldName)).getTag() != TypeTags.STRING_TAG) {
                continue;
            }
            BMap<BString, Object> newData = initializeBMap(returnType);
            String fieldValue = data.get(fieldName).toString();
            String newFieldValue = fieldValue.replaceAll(searchValue.toString(), replaceValue.getValue());
            for (BString key : data.getKeys()) {
                if (key.equals(fieldName)) {
                    newData.put(key, StringUtils.fromString(newFieldValue));
                } else {
                    newData.put(key, data.get(key));
                }
            }
            newDataset.append(newData);
        }
        return newDataset;
    }

    public static Object sortData(BArray dataset, BString fieldName, BString direction, BTypedesc returnType) {
        if (!isFieldExist(dataset, fieldName)) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        BArray sortedDataset = initializeBArray(returnType);
        List<BMap<BString, Object>> dataToSort = new ArrayList<>();
        for (int i = 0; i < dataset.size(); i++) {
            if (TypeUtils.getType(dataset.get(i)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                continue;
            }
            BMap<BString, Object> newData = copyBMap((BMap<BString, Object>) dataset.get(i), returnType);
            dataToSort.add(newData);
        }
        if (direction.equals(StringUtils.fromString(ASCENDING))) {
            dataToSort.sort(Comparator.comparing(
                    map -> map.get(fieldName),
                    Comparator.nullsLast(Comparator.comparing(Object::toString))));
        } else {
            dataToSort.sort(Comparator.comparing(
                    map -> map.get(fieldName),
                    Comparator.nullsLast(Comparator.comparing(Object::toString).reversed())));
            dataToSort.reversed();
        }
        for (BMap<BString, Object> record : dataToSort) {
            sortedDataset.append(record);
        }
        return sortedDataset;
    }

    public static Object standardizeData(Environment env, BArray dataset, BString fieldName, BArray standardValues,
            BTypedesc returnType) {
        if (!isFieldExist(dataset, fieldName)) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        BArray mergedResult = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i += 200) {
            int end = Math.min(i + 200, dataset.size());
            BArray chunk = dataset.slice(i, end);
            Object[] args = new Object[] { chunk, fieldName, standardValues };
            Object clientResponse = env.getRuntime().callFunction(env.getCurrentModule(), STANDARDIZE_DATA, null, args);
            Object chunkResult = processResponseToBArray(clientResponse, returnType);
            if (TypeUtils.getType(chunkResult).getTag() != TypeTags.ARRAY_TAG) {
                return chunkResult;
            }
            for (int j = 0; j < ((BArray) chunkResult).size(); j++) {
                mergedResult.append(((BArray) chunkResult).get(j));
            }
            ;
        }
        return mergedResult;
    }
}
