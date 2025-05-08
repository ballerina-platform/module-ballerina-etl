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

import io.ballerina.runtime.api.types.TypeTags;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.etl.utils.ErrorUtils;

import java.util.HashSet;
import java.util.Set;

import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeBMap;
import static io.ballerina.stdlib.etl.utils.CommonUtils.isFieldExist;

/**
 * This class hold Java external functions for ETL - data enrichment APIs.
 *
 * * @since 0.8.0
 */
@SuppressWarnings("unchecked")
public class EtlEnrichment {

    public static Object joinData(BArray dataset1, BArray dataset2, BString fieldName, BTypedesc returnType) {
        if (!isFieldExist(dataset1, fieldName)) {
            return ErrorUtils
                    .createETLError(String.format("The dataset %d does not contain the field - '%s'", 1, fieldName));
        }
        if (!isFieldExist(dataset2, fieldName)) {
            return ErrorUtils
                    .createETLError(
                            String.format("The second %d dataset does not contain the field - '%s'", 2, fieldName));

        }
        BArray joinedDataset = initializeBArray(returnType);
        Set<String> seenData = new HashSet<>();
        for (int i = 0; i < dataset1.size(); i++) {
            if (TypeUtils.getType(dataset1.get(i)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                continue;
            }
            BMap<BString, Object> data1 = (BMap<BString, Object>) dataset1.get(i);
            if (data1.get(fieldName) == null) {
                continue;
            }
            for (int j = 0; j < dataset2.size(); j++) {
                if (TypeUtils.getType(dataset2.get(j)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                    continue;
                }
                BMap<BString, Object> data2 = (BMap<BString, Object>) dataset2.get(j);
                if (data2.get(fieldName) == null) {
                    continue;
                }
                if (data1.get(fieldName).equals(data2.get(fieldName))) {
                    BMap<BString, Object> newData = initializeBMap(returnType);
                    for (BString key : data1.getKeys()) {
                        newData.put(key, data1.get(key));
                    }
                    for (BString key : data2.getKeys()) {
                        newData.put(key, data2.get(key));
                    }
                    if (!seenData.contains(newData.toString())) {
                        seenData.add(newData.toString());
                        joinedDataset.append(newData);
                    }
                }
            }
        }
        if (joinedDataset.size() == 0) {
            return ErrorUtils.createETLError("No matching records found");
        }
        return joinedDataset;
    }

    public static Object mergeData(BArray datasets, BTypedesc returnType) {
        BArray mergedDataset = initializeBArray(returnType);
        for (int i = 0; i < datasets.size(); i++) {
            if (TypeUtils.getType(datasets.get(i)).getTag() != TypeTags.ARRAY_TAG) {
                ErrorUtils.createETLError("Datasets to be merged must be of type 'record[]{}'");
                ;
            }
            BArray dataset = (BArray) datasets.get(i);
            for (int j = 0; j < dataset.size(); j++) {
                mergedDataset.append(dataset.get(j));
            }
        }
        return mergedDataset;
    }
}
