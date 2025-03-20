package io.ballerina.stdlib.etl.nativeimpl;

import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.etl.utils.ErrorUtils;

import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeBMap;

/**
 * This class hold Java external functions for ETL - data enrichment APIs.
 *
 * * @since 1.0.0
 */

@SuppressWarnings("unchecked")
public class EtlEnrichment {

    public static Object joinData(BArray dataset1, BArray dataset2, BString primaryKey, BTypedesc returnType) {

        BArray joinedDataset = initializeBArray(returnType);

        for (int i = 0; i < dataset1.size(); i++) {
            BMap<BString, Object> data1 = (BMap<BString, Object>) dataset1.get(i);
            if (!data1.containsKey(primaryKey)) {
                return ErrorUtils.createError("First dataset does not contain the primary key - " + primaryKey);
            }
            for (int j = 0; j < dataset2.size(); j++) {
                BMap<BString, Object> data2 = (BMap<BString, Object>) dataset2.get(j);
                if (!data2.containsKey(primaryKey)) {
                    return ErrorUtils.createError("Second dataset does not contain the primary key - " + primaryKey);
                }
                if (data1.get(primaryKey).equals(data2.get(primaryKey))) {
                    BMap<BString, Object> newData = initializeBMap(returnType);
                    for (BString key : data1.getKeys()) {
                        newData.put(key, data1.get(key));
                    }
                    for (BString key : data2.getKeys()) {
                        newData.put(key, data2.get(key));
                    }
                    joinedDataset.append(newData);
                }
            }
        }
        return joinedDataset;
    }

    public static Object mergeData(BArray datasets, BTypedesc returnType) {

        BArray mergedDataset = initializeBArray(returnType);

        for (int i = 0; i < datasets.size(); i++) {
            BArray dataset = (BArray) datasets.get(i);
            for (int j = 0; j < dataset.size(); j++) {
                mergedDataset.append(dataset.get(j));
            }
        }
        return mergedDataset;
    }
}
