package io.ballerina.stdlib.etl.utils;

import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.ArrayType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.JsonUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;

/**
 * Represents the util functions of ETL operations.
 */

public class CommonUtils {

    public static boolean contains(BArray array, BString key) {
        for (int i = 0; i < array.size(); i++) {
            if (array.get(i).equals(key)) {
                return true;
            }
        }
        return false;
    }

    public static boolean evaluateCondition(float fieldValue, float comparisonValue, String operation) {

        switch (operation) {
            case ">":
                return (fieldValue > comparisonValue);
            case "<":
                return (fieldValue < comparisonValue);
            case ">=":
                return (fieldValue >= comparisonValue);
            case "<=":
                return (fieldValue <= comparisonValue);
            case "==":
                return (fieldValue == comparisonValue);
            default:
                return (fieldValue != comparisonValue);
        }
    }

    public static BArray initializeBArray(BTypedesc type) {
        Type describingType = TypeUtils.getReferredType(type.getDescribingType());
        return ValueCreator.createArrayValue(TypeCreator.createArrayType(describingType));
    }

    public static BArray initializeNestedBArray(BTypedesc type, int size) {
        Type describingType = TypeUtils.getReferredType(type.getDescribingType());
        BArray nestedArray = ValueCreator.createArrayValue(TypeCreator.createArrayType(describingType));
        for (int i = 0; i < size; i++) {
            nestedArray.add(i, ValueCreator.createArrayValue((ArrayType) nestedArray.getElementType()));
        }
        return nestedArray;
    }

    public static BMap<BString, Object> initializeBMap(BTypedesc type) {
        Type describingType = TypeUtils.getReferredType(type.getDescribingType());
        BMap<BString, Object> result = ValueCreator.createRecordValue(
                TypeCreator.createRecordType(describingType.getName(), describingType.getPackage(),
                        describingType.getFlags(), false, 0));
        return result;

    }

    public static BArray convertJSONToBArray(Object source, BTypedesc type) {
        Type describingType = TypeUtils.getReferredType(type.getDescribingType());
        return (BArray) JsonUtils.convertJSON(source, TypeCreator.createArrayType(describingType));
    }

    public static Object convertJSONToRecord(Object source, BTypedesc type) {
        Type describingType = TypeUtils.getReferredType(type.getDescribingType());
        return JsonUtils.convertJSON(source, describingType);
    }
}
