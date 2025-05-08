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
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;

import static io.ballerina.stdlib.etl.utils.CommonUtils.getReturnTypeSchema;
import static io.ballerina.stdlib.etl.utils.CommonUtils.processResponseToRecord;

/**
 * This class hold Java external functions for ETL - unstructured data
 * extraction APIs.
 *
 * * @since 0.8.0
 */
public class EtlExtraction {

    public static final String EXTRACT_FROM_UNSTRUCTURED_DATA = "extractFromTextFunc";

    public static Object extractFromText(Environment env, BString sourceText, BTypedesc returnType) {
        BMap<BString, Object> returnTypeSchema = getReturnTypeSchema(returnType);
        Object[] args = new Object[] { sourceText, returnTypeSchema };
        Object clientResponse = env.getRuntime().callFunction(env.getCurrentModule(), EXTRACT_FROM_UNSTRUCTURED_DATA,
                null, args);
        return processResponseToRecord(clientResponse, returnType);
    }
}
