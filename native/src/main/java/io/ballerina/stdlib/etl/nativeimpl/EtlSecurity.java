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
import io.ballerina.runtime.api.types.TypeTags;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.crypto.nativeimpl.Decrypt;
import io.ballerina.stdlib.crypto.nativeimpl.Encrypt;
import io.ballerina.stdlib.etl.utils.ErrorUtils;
import org.ballerinalang.langlib.array.FromBase64;
import org.ballerinalang.langlib.array.ToBase64;

import java.nio.charset.StandardCharsets;

import static io.ballerina.stdlib.etl.utils.CommonUtils.contains;
import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeBArray;
import static io.ballerina.stdlib.etl.utils.CommonUtils.initializeBMap;
import static io.ballerina.stdlib.etl.utils.CommonUtils.isFieldExist;
import static io.ballerina.stdlib.etl.utils.CommonUtils.processResponseToBArray;

/**
 * This class hold Java external functions for ETL - data security APIs.
 *
 * * @since 0.8.0
 */
@SuppressWarnings("unchecked")
public class EtlSecurity {

    public static final String MASK_SENSITIVE_DATA = "maskSensitiveDataFunc";

    public static Object encryptData(BArray dataset, BArray fieldNames, BArray key, BTypedesc returnType) {
        for (int i = 0; i < fieldNames.size(); i++) {
            if (!isFieldExist(dataset, fieldNames.getBString(i))) {
                return ErrorUtils.createFieldNotFoundError(fieldNames.getBString(i));
            }
        }
        BArray encryptedDataset = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i++) {
            if (TypeUtils.getType(dataset.get(i)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                ErrorUtils.createInvalidDatasetElementError();
            }
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            BMap<BString, Object> encryptedData = initializeBMap(returnType);
            BString[] keys = data.getKeys();
            for (BString keyField : keys) {
                if (contains(fieldNames, keyField)) {
                    String value = data.get(keyField).toString();
                    Object encryptedValue = Encrypt.encryptAesEcb(
                            ValueCreator.createArrayValue(value.getBytes(StandardCharsets.UTF_8)), key, "PKCS5");
                    if (TypeUtils.getType(encryptedValue).getTag() != TypeTags.ARRAY_TAG) {
                        ErrorUtils.createEncryptionError();
                    }
                    encryptedData.put(keyField, ToBase64.toBase64((BArray) encryptedValue));
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
            if (TypeUtils.getType(dataset.get(i)).getTag() != TypeTags.RECORD_TYPE_TAG) {
                ErrorUtils.createInvalidDatasetElementError();
            }
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            BMap<BString, Object> decryptedData = initializeBMap(returnType);
            BString[] keys = data.getKeys();
            for (BString keyField : keys) {
                if (contains(fieldNames, keyField)) {
                    Object decryptedBytes = FromBase64
                            .fromBase64(StringUtils.fromString(data.get(keyField).toString()));
                    if (TypeUtils.getType(decryptedBytes).getTag() != TypeTags.ARRAY_TAG) {
                        ErrorUtils.createDecryptionError();
                    }
                    Object decryptedValue = Decrypt.decryptAesEcb((BArray) decryptedBytes, key,
                            "PKCS5");
                    if (TypeUtils.getType(decryptedValue).getTag() != TypeTags.ARRAY_TAG) {
                        ErrorUtils.createDecryptionError();
                    }
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
        BArray mergedResult = initializeBArray(returnType);
        for (int i = 0; i < dataset.size(); i += 200) {
            int end = Math.min(i + 200, dataset.size());
            BArray chunk = dataset.slice(i, end);
            Object[] args = new Object[] { chunk, maskCharacter };
            Object clientResponse = env.getRuntime().callFunction(env.getCurrentModule(), MASK_SENSITIVE_DATA, null,
                    args);
            BArray chunkResult = (BArray) processResponseToBArray(clientResponse, returnType);
            for (int j = 0; j < chunkResult.size(); j++) {
                mergedResult.append(chunkResult.get(j));
            }
        }
        return mergedResult;

    }
}
