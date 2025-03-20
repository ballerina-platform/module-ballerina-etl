/*
 * Copyright (c) 2025, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

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
