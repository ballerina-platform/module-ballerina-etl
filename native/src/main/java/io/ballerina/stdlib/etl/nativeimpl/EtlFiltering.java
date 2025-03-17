package io.ballerina.stdlib.etl.nativeimpl;

import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BRegexpValue;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.etl.utils.ErrorUtils;

import java.util.ArrayList;
import java.util.Collections;

import static io.ballerina.stdlib.etl.utils.CommonUtils.evaluateCondition;

@SuppressWarnings("unchecked")
public class EtlFiltering {
    
    public static Object filterDataByRatio(BArray dataset, float ratio, BTypedesc returnType) {
        Type describingType = TypeUtils.getReferredType(returnType.getDescribingType());
        BArray result = ValueCreator.createArrayValue(TypeCreator.createArrayType(describingType));

        BArray dataset1 = ValueCreator.createArrayValue(TypeCreator.createArrayType(dataset.getElementType()));
        BArray dataset2 = ValueCreator.createArrayValue(TypeCreator.createArrayType(dataset.getElementType()));

        result.add(0, dataset1);
        result.add(1, dataset2);

        ArrayList<Object> recordList = new ArrayList<>();
        for (int i = 0; i < dataset.size(); i++) {
            recordList.add(dataset.get(i));
        }
        Collections.shuffle(recordList);

        int size = (int) (recordList.size() * ratio);
        for (int i = 0; i < recordList.size(); i++) {
            if (i < size) {
                dataset1.append(recordList.get(i));
            } else {
                dataset2.append(recordList.get(i));
            }
        }
        return result;
    }

    public static Object filterDataByRegex(BArray dataset, BString fieldName, BRegexpValue regexPattern,
            BTypedesc returnType) {
        Type describingType = TypeUtils.getReferredType(returnType.getDescribingType());
        BArray result = ValueCreator.createArrayValue(TypeCreator.createArrayType(describingType));
        for (int k = 0; k < 2; k++) {
            result.add(k, ValueCreator.createArrayValue(TypeCreator.createArrayType(dataset.getElementType())));
        }
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> record = (BMap<BString, Object>) dataset.get(i);
            if (!record.containsKey(fieldName)) {
                return ErrorUtils.createError("The dataset does not contain the field - " + fieldName);
            }
            if (record.get(fieldName) == null) {
                continue;
            }
            String newData = record.get(fieldName).toString();
            if (newData.matches(regexPattern.toString())) {
                ((BArray) result.get(0)).append(record);
            } else {
                ((BArray) result.get(1)).append(record);
            }
        }
        return result;
    }

    public static Object filterDataByRelativeExp(BArray dataset, BString fieldName, BString operation, float value,
            BTypedesc returnType) {
        Type describingType = TypeUtils.getReferredType(returnType.getDescribingType());
        BArray result = ValueCreator.createArrayValue(TypeCreator.createArrayType(describingType));
        for (int k = 0; k < 2; k++) {
            result.add(k, ValueCreator.createArrayValue(TypeCreator.createArrayType(dataset.getElementType())));
        }
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> record = (BMap<BString, Object>) dataset.get(i);
            if (!record.containsKey(fieldName)) {
                return ErrorUtils.createError("The dataset does not contain the field - " + fieldName);
            }
            if (record.get(fieldName) == null) {
                continue;
            }
            float fieldValue = Float.parseFloat(record.get(fieldName).toString());
            if (evaluateCondition(fieldValue, value, operation.toString())) {
                ((BArray) result.get(0)).append(record);
            } else {
                ((BArray) result.get(1)).append(record);
            }
        }
        return result;
    }
}
