package io.ballerina.stdlib.etl.nativeimpl;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;

import static io.ballerina.stdlib.etl.utils.CommonUtils.convertJSONToRecord;

/**
 * This class hold Java external functions for ETL - unstructured data
 * extraction APIs.
 *
 * * @since 1.0.0
 */

public class EtlExtraction {

    public static Object extractFromUnstructuredData(Environment env, BString dataset, BArray fieldNames,
            BString modelName, BTypedesc returnType) {

        Object[] args = new Object[] { dataset, fieldNames, modelName, returnType };
        Object clientResponse = env.getRuntime().callFunction(env.getCurrentModule(), "extractFromUnstructuredDataFunc",
                null, args);
        return convertJSONToRecord(clientResponse, returnType);

    }
}
