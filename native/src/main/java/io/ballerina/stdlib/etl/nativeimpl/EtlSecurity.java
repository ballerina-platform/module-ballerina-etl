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
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.crypto.nativeimpl.Decrypt;
import io.ballerina.stdlib.crypto.nativeimpl.Encrypt;
import io.ballerina.stdlib.etl.utils.ErrorUtils;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

import static io.ballerina.stdlib.etl.utils.CommonUtils.contains;
import static io.ballerina.stdlib.etl.utils.CommonUtils.convertJSONToBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeBMap;
import static io.ballerina.stdlib.etl.utils.CommonUtils.isFieldExist;
import static io.ballerina.stdlib.etl.utils.Constants.CLIENT_CONNECTOR_ERROR;
import static io.ballerina.stdlib.etl.utils.Constants.IDLE_TIMEOUT_ERROR;

/**
 * This class hold Java external functions for ETL - data security APIs.
 *
 * * @since 1.0.0
 */
@SuppressWarnings("unchecked")
public class EtlSecurity {

    public static Object encryptData(BArray dataset, BArray fieldNames, BArray key, BTypedesc returnType) {
        for (int i = 0; i < fieldNames.size(); i++) {
            if (!isFieldExist(dataset, fieldNames.getBString(i))) {
                return ErrorUtils.createFieldNotFoundError(fieldNames.getBString(i));
            }
        }
        BArray encryptedDataset = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            BMap<BString, Object> encryptedData = initializeBMap(returnType);
            BString[] keys = data.getKeys();
            for (BString keyField : keys) {
                if (contains(fieldNames, keyField)) {
                    String value = data.get(keyField).toString();
                    Object encryptedValue = Encrypt.encryptAesEcb(
                            ValueCreator.createArrayValue(value.getBytes(StandardCharsets.UTF_8)), key, "PKCS5");
                    byte[] encryptedBytes = ((BArray) encryptedValue).getBytes();
                    String encryptedBase64 = Base64.getEncoder().encodeToString(encryptedBytes);
                    encryptedData.put(keyField, StringUtils.fromString(encryptedBase64));
                } else {
                    encryptedData.put(keyField, data.get(keyField));
                }
            }
            encryptedDataset.append(encryptedData);
        }
        return encryptedDataset;
    }

    public static Object decryptData(BArray dataset, BArray fieldNames, BArray key, BTypedesc returnType) {
        for (int i = 0; i < fieldNames.size(); i++) {
            if (!isFieldExist(dataset, fieldNames.getBString(i))) {
                return ErrorUtils.createFieldNotFoundError(fieldNames.getBString(i));
            }
        }
        BArray decryptedDataset = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            BMap<BString, Object> decryptedData = initializeBMap(returnType);
            BString[] keys = data.getKeys();
            for (BString keyField : keys) {
                if (contains(fieldNames, keyField)) {
                    String value = data.get(keyField).toString();
                    byte[] decryptedBytes = Base64.getDecoder().decode(value);
                    Object decryptedValue = Decrypt.decryptAesEcb(ValueCreator.createArrayValue(decryptedBytes), key,
                            "PKCS5");
                    decryptedData.put(keyField, StringUtils
                            .fromString(new String((((BArray) decryptedValue).getBytes()), StandardCharsets.UTF_8)));
                } else {
                    decryptedData.put(keyField, data.get(keyField));
                }
            }
            decryptedDataset.append(decryptedData);
        }
        return decryptedDataset;
    }

    public static Object maskSensitiveData(Environment env, BArray dataset, BString maskCharacter,
            BTypedesc returnType) {
        Object[] args = new Object[] { dataset, maskCharacter };
        Object clientResponse = env.getRuntime().callFunction(env.getCurrentModule(), "maskSensitiveDataFunc", null,
                args);
        switch (TypeUtils.getType(clientResponse).getName()) {
            case CLIENT_CONNECTOR_ERROR:
                return ErrorUtils.createClientConnectionError();
            case IDLE_TIMEOUT_ERROR:
                return ErrorUtils.createIdleTimeoutError();
            default:
                return convertJSONToBArray(clientResponse, returnType);
        }
    }
}
