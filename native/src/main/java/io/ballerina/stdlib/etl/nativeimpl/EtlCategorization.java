package io.ballerina.stdlib.etl.nativeimpl;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BRegexpValue;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.etl.utils.ErrorUtils;

import static io.ballerina.stdlib.etl.utils.CommonUtils.convertJSONToBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeNestedBArray;

/**
 * This class hold Java external functions for ETL - data categorization APIs.
 *
 * * @since 1.0.0
 */
@SuppressWarnings("unchecked")
public class EtlCategorization {

    public static Object categorizeNumeric(BArray dataset, BString fieldName, BArray rangeArray, BTypedesc returnType) {

        BArray categorizedData = initializeNestedBArray(returnType, rangeArray.size() + 1);

        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            if (!data.containsKey(fieldName)) {
                return ErrorUtils.createFieldNotFoundError(fieldName);
            }
            if (data.get(fieldName) == null) {
                continue;
            }
            float fieldValue = Float.parseFloat(data.get(fieldName).toString());
            boolean isMatched = false;
            for (int j = 0; j < rangeArray.size(); j++) {
                BArray range = (BArray) rangeArray.get(j);
                float lowerBound = Float.parseFloat(range.get(0).toString());
                float upperBound = Float.parseFloat(range.get(1).toString());
                if (fieldValue >= lowerBound && fieldValue <= upperBound) {
                    ((BArray) categorizedData.get(j)).append(data);
                    isMatched = true;
                    break;
                }
            }
            if (!isMatched) {
                ((BArray) categorizedData.get(rangeArray.size())).append(data);
            }
        }

        return categorizedData;
    }

    public static Object categorizeRegex(BArray dataset, BString fieldName, BArray regexArray, BTypedesc returnType) {

        BArray categorizedData = initializeNestedBArray(returnType, regexArray.size() + 1);

        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            if (!data.containsKey(fieldName)) {
                return ErrorUtils.createFieldNotFoundError(fieldName);
            }
            if (data.get(fieldName) == null) {
                continue;
            }
            String fieldValue = data.get(fieldName).toString();
            boolean isMatched = false;
            for (int j = 0; j < regexArray.size(); j++) {
                BRegexpValue regexPattern = (BRegexpValue) regexArray.get(j);
                if (fieldValue.matches(regexPattern.toString())) {
                    ((BArray) categorizedData.get(j)).append(data);
                    isMatched = true;
                    break;
                }
            }
            if (!isMatched) {
                ((BArray) categorizedData.get(regexArray.size())).append(data);
            }
        }

        return categorizedData;
    }

    public static Object categorizeSemantic(Environment env, BArray dataset, BString fieldName, BArray categories,
            BString modelName, BTypedesc returnType) {
        Object[] args = new Object[] { dataset, fieldName, categories, modelName, returnType };
        Object clientResponse = env.getRuntime().callFunction(env.getCurrentModule(), "categorizeSemanticFunc", null,
                args);
        return convertJSONToBArray(clientResponse, returnType);
    }

}
