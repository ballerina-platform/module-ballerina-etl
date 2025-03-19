package io.ballerina.stdlib.etl.nativeimpl;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.JsonUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;

/**
 * This class hold Java external functions for ETL - unstructured data extraction APIs.
 *
 * * @since 1.0.0
 */

public class EtlExtraction {

    public static Object extractFromUnstructuredData(Environment env, BString dataset, BArray fieldNames,
            BString modelName, BTypedesc returnType) {
        Object[] args = new Object[] { dataset, fieldNames, modelName, returnType };
        Object result = env.getRuntime().callFunction(env.getCurrentModule(), "extractFromUnstructuredDataFunc", null,
                args);
        Type describingType = TypeUtils.getReferredType(returnType.getDescribingType());
        Object resultArray = JsonUtils.convertJSON(result,
                describingType);
        return resultArray;
    }
}
