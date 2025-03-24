/*
 * Copyright (c) 2025, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.etl.nativeimpl;

import io.ballerina.runtime.api.Environment;
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
import java.util.HashSet;
import java.util.List;

import static io.ballerina.stdlib.etl.utils.CommonUtils.convertJSONToBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeBArray;

/**
 * This class hold Java external functions for ETL - data cleaning APIs.
 *
 * * @since 1.0.0
 */

@SuppressWarnings("unchecked")
public class EtlCleaning {

    public static Object groupApproximateDuplicates(Environment env, BArray dataset, BString modelName,
            BTypedesc returnType) {        
        Object[] args = new Object[] { dataset, modelName, returnType };
        Object clientResponse = env.getRuntime().callFunction(env.getCurrentModule(), "groupApproximateDuplicatesFunc",
                null,
                args);
        switch
        (TypeUtils.getType(clientResponse).getName()) {
            case "ClientConnectorError":
                return ErrorUtils.createClientConnectionError();
            case "IdleTimeoutError":
                return ErrorUtils.createIdleTimeoutError();
            default:
                return convertJSONToBArray(clientResponse, returnType);
        }

    }

    public static Object handleWhiteSpaces(BArray dataset, BTypedesc returnType) {
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            for (BString key : data.getKeys()) {
                if (data.get(key) == null) {
                    continue;
                }
                if (TypeUtils.getType(data.get(key)).getName().equals("string")) {
                    String newFieldValue = data.get(key).toString().replaceAll("\s+", " ").trim();
                    data.put(key, StringUtils.fromString(newFieldValue));
                }
            }
        }
        return dataset;
    }

    public static Object removeDuplicates(BArray dataset, BTypedesc returnType) {
        BArray uniqueDataset = initializeBArray(returnType);
        HashSet<String> seenRecords = new HashSet<>();
        for (int i = 0; i < dataset.size(); i++) {
            Object record = dataset.get(i);
            if (seenRecords.add(record.toString())) {
                uniqueDataset.append(record);
            }
        }
        return uniqueDataset;
    }

    public static Object removeField(BArray dataset, BString fieldName, BTypedesc returnType) {
        boolean isFieldExist = false;
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            if (data.containsKey(fieldName)) {
                data.remove(fieldName);
                isFieldExist = true;
            }
        }
        if (!isFieldExist) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        return dataset;
    }

    public static Object removeNull(BArray dataset, BTypedesc returnType) {

        BArray cleanedDataset = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            boolean hasNullOrEmptyField = false;
            for (BString key : data.getKeys()) {
                if (data.get(key) == null || data.get(key).toString().trim().isEmpty()) {
                    hasNullOrEmptyField = true;
                    break;
                }
            }
            if (!hasNullOrEmptyField) {
                cleanedDataset.append(data);
            }
        }
        return cleanedDataset;
    }

    public static Object replaceText(BArray dataset, BString fieldName, BRegexpValue searchValue, BString replaceValue,
            BTypedesc returnType) {
        boolean isFieldExist = false;
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            if (data.containsKey(fieldName)) {
                String fieldValue = data.get(fieldName).toString();
                String newFieldValue = fieldValue.replaceAll(searchValue.toString(), replaceValue.toString());
                data.put(fieldName, StringUtils.fromString(newFieldValue));
                isFieldExist = true;
            }

        }
        if (!isFieldExist) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        return dataset;
    }

    public static Object sortData(BArray dataset, BString fieldName, boolean isAscending, BTypedesc returnType) {
        BArray sortedDataset = initializeBArray(returnType);
        List<BMap<BString, Object>> dataToSort = new ArrayList<>();
        List<BMap<BString, Object>> nullData = new ArrayList<>();
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            if (data.get(fieldName) == null || !data.containsKey(fieldName)) {
                nullData.add(data);
                continue;
            }
            dataToSort.add(data);
        }
        dataToSort.sort(Comparator.comparing(map -> map.get(fieldName).toString()));
        if (!isAscending) {
            dataToSort.reversed();
        }
        if (dataToSort.isEmpty()) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        dataToSort.addAll(nullData);
        for (BMap<BString, Object> record : dataToSort) {
            sortedDataset.append(record);
        }
        return sortedDataset;
    }

    public static Object standardizeData(Environment env, BArray dataset, BString fieldName, BArray standardValues,
            BString modelName, BTypedesc returnType) {
        boolean isFieldExist = false;
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            if (data.containsKey(fieldName)) {
                isFieldExist = true;
            }
        }
        if (!isFieldExist) {
            return ErrorUtils.createFieldNotFoundError(fieldName);
        }
        Object[] args = new Object[] { dataset, fieldName, standardValues, modelName, returnType };
        Object clientResponse = env.getRuntime().callFunction(env.getCurrentModule(), "standardizeDataFunc", null,
                args);
        switch
        (TypeUtils.getType(clientResponse).getName()) {
            case "ClientConnectorError":
                return ErrorUtils.createClientConnectionError();
            case "IdleTimeoutError":
                return ErrorUtils.createIdleTimeoutError();
            default:
                return convertJSONToBArray(clientResponse, returnType);
        }
    }

}
