package io.ballerina.stdlib.etl.nativeimpl;

import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.etl.utils.ErrorUtils;

/**
 * This class hold Java external functions for ETL - data enrichment APIs.
 *
 * * @since 1.0.0
 */

@SuppressWarnings("unchecked")
public class EtlEnrichment {

    public static Object joinData(BArray dataset1, BArray dataset2, BString primaryKey, BTypedesc returnType) {
        Type describingType = TypeUtils.getReferredType(returnType.getDescribingType());
        BArray result = ValueCreator.createArrayValue(TypeCreator.createArrayType(describingType));

        for (int i = 0; i < dataset1.size(); i++) {
            BMap<BString, Object> record1 = (BMap<BString, Object>) dataset1.get(i);
            if (!record1.containsKey(primaryKey)) {
                return ErrorUtils.createError("First dataset does not contain the primary key - " + primaryKey);
            }
            for (int j = 0; j < dataset2.size(); j++) {
                BMap<BString, Object> record2 = (BMap<BString, Object>) dataset2.get(j);
                if (!record2.containsKey(primaryKey)) {
                    return ErrorUtils.createError("Second dataset does not contain the primary key - " + primaryKey);
                }
                if (record1.get(primaryKey).equals(record2.get(primaryKey))) {
                    BMap<BString, Object> newRecord = ValueCreator.createRecordValue(
                            TypeCreator.createRecordType(describingType.getName(), describingType.getPackage(),
                                    describingType.getFlags(), false, 0));
                    for (BString key : record1.getKeys()) {
                        newRecord.put(key, record1.get(key));
                    }
                    for (BString key : record2.getKeys()) {
                        newRecord.put(key, record2.get(key));
                    }
                    result.append(newRecord);
                }
            }
        }
        return result;
    }

    public static Object mergeData(BArray datasets, BTypedesc returnType) {

        Type describingType = TypeUtils.getReferredType(returnType.getDescribingType());
        BArray result = ValueCreator.createArrayValue(TypeCreator.createArrayType(describingType));

        for (int i = 0; i < datasets.size(); i++) {
            BArray dataset = (BArray) datasets.get(i);
            for (int j = 0; j < dataset.size(); j++) {
                result.append(dataset.get(j));
            }
        }
        return result;
    }
}
