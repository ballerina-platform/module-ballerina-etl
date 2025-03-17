package io.ballerina.stdlib.etl.nativeimpl;

import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.Type;
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

@SuppressWarnings("unchecked")
public class EtlCleaning {

    public static Object replaceText(BArray dataset, BString fieldName, BRegexpValue searchValue, BString replaceValue,
            BTypedesc returnType) {

        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> record = (BMap<BString, Object>) dataset.get(i);
            if (!record.containsKey(fieldName)) {
                return ErrorUtils.createError("The dataset does not contain the field - " + fieldName);
            }
            if (record.get(fieldName) == null) {
                continue;
            }
            String newData = record.get(fieldName).toString();
            String outputString = newData.replaceAll(searchValue.toString(), replaceValue.toString());
            record.put(fieldName, StringUtils.fromString(outputString));
        }
        return dataset;
    }

    public static Object handleWhiteSpaces(BArray dataset, BTypedesc returnType) {
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> record = (BMap<BString, Object>) dataset.get(i);
            for (BString key : record.getKeys()) {
                if (record.get(key) == null) {
                    continue;
                }
                String newData = record.get(key).toString();
                String outputString = newData.replaceAll("\s+", " ").trim();
                record.put(key, StringUtils.fromString(outputString));
            }
        }
        return dataset;
    }

    public static Object removeField(BArray dataset, BString fieldName, BTypedesc returnType) {
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> record = (BMap<BString, Object>) dataset.get(i);
            if (!record.containsKey(fieldName)) {
                return ErrorUtils.createError("The dataset does not contain the field - " + fieldName);
            }
            record.remove(fieldName);
        }
        return dataset;
    }

    public static Object removeDuplicates(BArray dataset, BTypedesc returnType) {
        Type describingType = TypeUtils.getReferredType(returnType.getDescribingType());
        BArray list = ValueCreator.createArrayValue(TypeCreator.createArrayType(describingType));
        HashSet<String> recordSet = new HashSet<>();

        for (int i = 0; i < dataset.size(); i++) {
            Object record = dataset.get(i);
            if (recordSet.add(record.toString())) {
                list.append(record);
            }
        }
        return list;
    }

    public static Object removeNull(BArray dataset, BTypedesc returnType) {
        Type describingType = TypeUtils.getReferredType(returnType.getDescribingType());
        BArray list = ValueCreator.createArrayValue(TypeCreator.createArrayType(describingType));
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> record = (BMap<BString, Object>) dataset.get(i);
            boolean isNull = false;
            for (BString key : record.getKeys()) {
                if (record.get(key) == null || record.get(key).toString().trim().isEmpty()) {
                    isNull = true;
                    break;
                }
            }
            if (!isNull) {
                list.append(record);
            }
        }
        return list;
    }

    public static Object sortData(BArray dataset, BString fieldName, boolean isAscending, BTypedesc returnType) {
        Type describingType = TypeUtils.getReferredType(returnType.getDescribingType());
        BArray list = ValueCreator.createArrayValue(TypeCreator.createArrayType(describingType));
        List<BMap<BString, Object>> recordList = new ArrayList<>();
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> record = (BMap<BString, Object>) dataset.get(i);
            if (!record.containsKey(fieldName)) {
                return ErrorUtils.createError("The dataset does not contain the field - " + fieldName);
            }
            if (record.get(fieldName) == null) {
                return ErrorUtils.createError("Null value found in the dataset for the field" + fieldName);
            }
            recordList.add(record);
        }
        recordList.sort(Comparator.comparing(map -> map.get(fieldName).toString()));
        if (!isAscending) {
            recordList.reversed();
        }
        for (BMap<BString, Object> record : recordList) {
            list.append(record);
        }
        return list;
    }

}
