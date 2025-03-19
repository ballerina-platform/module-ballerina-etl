package io.ballerina.stdlib.etl.nativeimpl;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.JsonUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BRegexpValue;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.etl.utils.ErrorUtils;

/**
 * This class hold Java external functions for ETL - data categorization APIs.
 *
 * * @since 1.0.0
 */
@SuppressWarnings("unchecked")
public class EtlCategorization {

    public static Object categorizeNumeric(BArray dataset, BString fieldName, BArray rangeArray, BTypedesc returnType) {

        Type describingType = TypeUtils.getReferredType(returnType.getDescribingType());
        BArray result = ValueCreator.createArrayValue(TypeCreator.createArrayType(describingType));

        for (int i = 0; i <= rangeArray.size(); i++) {
            result.add(i, ValueCreator.createArrayValue(TypeCreator.createArrayType(dataset.getElementType())));
        }

        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> record = (BMap<BString, Object>) dataset.get(i);
            if (!record.containsKey(fieldName)) {
                return ErrorUtils.createError("Given field name '" + fieldName + "' is not found in the dataset");
            }
            if (record.get(fieldName) == null) {
                continue;
            }
            float newData = Float.parseFloat(record.get(fieldName).toString());
            boolean found = false;
            for (int j = 0; j < rangeArray.size(); j++) {
                BArray range = (BArray) rangeArray.get(j);
                float lowerBound = Float.parseFloat(range.get(0).toString());
                float upperBound = Float.parseFloat(range.get(1).toString());
                if (newData >= lowerBound && newData <= upperBound) {
                    ((BArray) result.get(j)).append(record);
                    found = true;
                    break;
                }
            }
            if (!found) {
                ((BArray) result.get(rangeArray.size())).append(record);
            }
        }

        return result;
    }

    public static Object categorizeRegex(BArray dataset, BString fieldName, BArray regexArray, BTypedesc returnType) {

        Type describingType = TypeUtils.getReferredType(returnType.getDescribingType());
        BArray result = ValueCreator.createArrayValue(TypeCreator.createArrayType(describingType));

        for (int i = 0; i <= regexArray.size(); i++) {
            result.add(i, ValueCreator.createArrayValue(TypeCreator.createArrayType(dataset.getElementType())));
        }

        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> record = (BMap<BString, Object>) dataset.get(i);
            if (!record.containsKey(fieldName)) {
                return ErrorUtils.createError("Given field name '" + fieldName + "' is not found in the dataset");
            }
            if (record.get(fieldName) == null) {
                continue;
            }
            String newData = record.get(fieldName).toString();
            boolean found = false;
            for (int j = 0; j < regexArray.size(); j++) {
                BRegexpValue regexPattern = (BRegexpValue) regexArray.get(j);
                if (newData.matches(regexPattern.toString())) {
                    ((BArray) result.get(j)).append(record);
                    found = true;
                    break;
                }
            }
            if (!found) {
                ((BArray) result.get(regexArray.size())).append(record);
            }
        }

        return result;
    }

    public static Object categorizeSemantic(Environment env, BArray dataset, BString fieldName, BArray categories,
            BString modelName, BTypedesc returnType) {
        Object[] args = new Object[] { dataset, fieldName, categories, modelName, returnType };
        Object result = env.getRuntime().callFunction(env.getCurrentModule(), "categorizeSemanticFunc", null,
                args);
        Type describingType = TypeUtils.getReferredType(returnType.getDescribingType());
        BArray resultArray = (BArray) JsonUtils.convertJSON(result, TypeCreator.createArrayType(describingType));
        return resultArray;
    }

}
