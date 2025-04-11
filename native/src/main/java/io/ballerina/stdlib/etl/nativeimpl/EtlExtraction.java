/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
 * 
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.etl.nativeimpl;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.etl.utils.ErrorUtils;

import static io.ballerina.stdlib.etl.utils.CommonUtils.convertJSONToRecord;
import static io.ballerina.stdlib.etl.utils.CommonUtils.getReturnTypeSchema;
import static io.ballerina.stdlib.etl.utils.Constants.CLIENT_CONNECTOR_ERROR;
import static io.ballerina.stdlib.etl.utils.Constants.EXTRACT_FROM_UNSTRUCTURED_DATA;
import static io.ballerina.stdlib.etl.utils.Constants.IDLE_TIMEOUT_ERROR;

/**
 * This class hold Java external functions for ETL - unstructured data
 * extraction APIs.
 *
 * * @since 0.8.0
 */

public class EtlExtraction {

    public static Object extractFromUnstructuredData(Environment env, BString dataset, BTypedesc returnType) {
        BMap<BString, Object> returnTypeSchema = getReturnTypeSchema(returnType);
        Object[] args = new Object[] { dataset, returnTypeSchema };
        Object clientResponse = env.getRuntime().callFunction(env.getCurrentModule(), EXTRACT_FROM_UNSTRUCTURED_DATA,
                null, args);
        switch (TypeUtils.getType(clientResponse).getName()) {
            case CLIENT_CONNECTOR_ERROR:
                return ErrorUtils.createClientConnectionError();
            case IDLE_TIMEOUT_ERROR:
                return ErrorUtils.createIdleTimeoutError();
            default:
                return convertJSONToRecord(clientResponse, returnType);
        }
    }
}
