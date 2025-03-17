package io.ballerina.stdlib.etl.nativeimpl;

import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.etl.utils.ErrorUtils;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.spec.SecretKeySpec;

import static io.ballerina.stdlib.etl.utils.CommonUtils.contains;

@SuppressWarnings("unchecked")
public class EtlSecurity {

    public static Object encryptData(BArray dataset, BArray fieldNames, BString key, BTypedesc returnType) {
        Type describingType = TypeUtils.getReferredType(returnType.getDescribingType());
        BArray result = ValueCreator.createArrayValue(TypeCreator.createArrayType(describingType));
        byte[] encryptKey = Base64.getDecoder().decode(key.getValue());
        Cipher cipher;
        try {
            cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(encryptKey, "AES"));
        } catch (Exception e) {
            return ErrorUtils.createError("Error occurred while encrypting data: " + e.getMessage());
        }
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            BMap<BString, Object> encryptedData = ValueCreator.createRecordValue(
                    TypeCreator.createRecordType(describingType.getName(), describingType.getPackage(),
                            describingType.getFlags(), false, 0));
            for (int j = 0; j < fieldNames.size(); j++) {
                BString fieldName = (BString) fieldNames.get(j);
                if (!data.containsKey(fieldName)) {
                    return ErrorUtils.createError("The dataset does not contain the field - " + fieldName);
                }
            }
            BString[] keys = data.getKeys();
            for (BString keyField : keys) {
                if (contains(fieldNames, keyField)) {
                    String value = data.get(keyField).toString();
                    byte[] encryptedBytes = null;
                    try {
                        encryptedBytes = cipher.doFinal(value.getBytes(StandardCharsets.UTF_8));
                    } catch (IllegalBlockSizeException e) {
                        return ErrorUtils.createError("Error occurred while encrypting data: " + e.getMessage());
                    } catch (BadPaddingException e) {
                        return ErrorUtils.createError("Error occurred while encrypting data: " + e.getMessage());
                    }
                    String encryptedBase64 = Base64.getEncoder().encodeToString(encryptedBytes);
                    encryptedData.put(keyField, StringUtils.fromString(encryptedBase64));
                } else {
                    encryptedData.put(keyField, data.get(keyField));
                }
            }
            result.append(encryptedData);
        }
        return result;
    }

    public static Object decryptData(BArray dataset, BArray fieldNames, BString key, BTypedesc returnType) {
        Type describingType = TypeUtils.getReferredType(returnType.getDescribingType());
        BArray result = ValueCreator.createArrayValue(TypeCreator.createArrayType(describingType));
        byte[] decryptKey = Base64.getDecoder().decode(key.getValue());

        Cipher cipher;
        try {
            cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
            cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(decryptKey, "AES"));
        } catch (Exception e) {
            return ErrorUtils.createError("Error occurred while decrypting data: " + e.getMessage());
        }
        for (int i = 0; i < dataset.size(); i++) {
            BMap<BString, Object> data = (BMap<BString, Object>) dataset.get(i);
            BMap<BString, Object> decryptedData = ValueCreator.createRecordValue(
                    TypeCreator.createRecordType(describingType.getName(), describingType.getPackage(),
                            describingType.getFlags(), false, 0));
            for (int j = 0; j < fieldNames.size(); j++) {
                BString fieldName = (BString) fieldNames.get(j);
                if (!data.containsKey(fieldName)) {
                    return ErrorUtils.createError("The dataset does not contain the field - " + fieldName);
                }
            }
            BString[] keys = data.getKeys();
            for (BString keyField : keys) {
                if (contains(fieldNames, keyField)) {
                    String value = data.get(keyField).toString();
                    byte[] decryptedBytes = null;
                    try {
                        decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(value));
                    } catch (IllegalBlockSizeException e) {
                        return ErrorUtils.createError("Error occurred while decrypting data: " + e.getMessage());
                    } catch (BadPaddingException e) {
                        return ErrorUtils.createError("Error occurred while decrypting data: " + e.getMessage());
                    }
                    String decryptedValue = new String(decryptedBytes, StandardCharsets.UTF_8);
                    decryptedData.put(keyField, StringUtils.fromString(decryptedValue));
                } else {
                    decryptedData.put(keyField, data.get(keyField));
                }
            }
            result.append(decryptedData);
        }
        return result;
    }
    
}
