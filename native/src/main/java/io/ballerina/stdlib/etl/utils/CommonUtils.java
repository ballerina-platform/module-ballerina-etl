package io.ballerina.stdlib.etl.utils;

import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BString;

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
}
