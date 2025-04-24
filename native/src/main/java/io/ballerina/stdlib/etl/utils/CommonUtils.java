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

package io.ballerina.stdlib.etl.utils;

import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.ArrayType;
import io.ballerina.runtime.api.types.Field;
import io.ballerina.runtime.api.types.StructureType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.types.TypeTags;
import io.ballerina.runtime.api.types.UnionType;
import io.ballerina.runtime.api.utils.JsonUtils;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BIterator;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BTypedesc;

import java.util.List;
import java.util.Map;

/**
 * Represents the util functions of ETL operations.
 */

public class CommonUtils {

    public static final String IDLE_TIMEOUT_ERROR = "IdleTimeoutError";
    public static final String CLIENT_CONNECTOR_ERROR = "ClientConnectorError";
    public static final String CLIENT_REQUEST_ERROR = "ClientRequestError";

    public static boolean contains(BArray array, BString key) {
        BIterator<?> iterator = array.getIterator();
        while (iterator.hasNext()) {
            if (iterator.next().equals(key)) {
                return true;
            }
        }
        return false;
    }

    public static boolean evaluateCondition(double fieldValue, double comparisonValue, String operation) {
        switch (operation) {
            case ">":
                return fieldValue > comparisonValue;
            case "<":
                return fieldValue < comparisonValue;
            case ">=":
                return fieldValue >= comparisonValue;
            case "<=":
                return fieldValue <= comparisonValue;
            case "==":
                return fieldValue == comparisonValue;
            default:
                return fieldValue != comparisonValue;
        }
    }

    public static BArray initializeBArray(BTypedesc type) {
        Type arrayType = TypeUtils.getReferredType(type.getDescribingType());
        return ValueCreator.createArrayValue(TypeCreator.createArrayType(arrayType));
    }

    public static BArray initializeNestedBArray(BTypedesc type, int size) {
        ArrayType arrayType = TypeCreator.createArrayType(TypeUtils.getReferredType(type.getDescribingType()));
        return ValueCreator.createArrayValue(TypeCreator.createArrayType(arrayType, size));
    }

    public static BMap<BString, Object> initializeBMap(BTypedesc type) {
        Type describingType = TypeUtils.getReferredType(type.getDescribingType());
        return ValueCreator.createRecordValue(
                TypeCreator.createRecordType(describingType.getName(), describingType.getPackage(),
                        describingType.getFlags(), false, 0));
    }

    public static BMap<BString, Object> copyBMap(BMap<BString, Object> source, BTypedesc targetType) {
        BMap<BString, Object> target = initializeBMap(targetType);
        for (BString key : source.getKeys()) {
            target.put(key, source.get(key));
        }
        return target;
    }

    public static BArray convertJSONToBArray(Object source, BTypedesc type) {
        Type describingType = TypeUtils.getReferredType(type.getDescribingType());
        return (BArray) JsonUtils.convertJSON(source, TypeCreator.createArrayType(describingType));
    }

    public static BArray convertJSONToNestedBArray(Object source, BTypedesc type) {
        ArrayType arrayType = TypeCreator.createArrayType(TypeUtils.getReferredType(type.getDescribingType()));
        return (BArray) JsonUtils.convertJSON(source, TypeCreator.createArrayType(arrayType));
    }

    public static Object convertJSONToRecord(Object source, BTypedesc type) {
        Type describingType = TypeUtils.getReferredType(type.getDescribingType());
        return JsonUtils.convertJSON(source, describingType);
    }

    public static BString[] getFields(BTypedesc type) {
        Type describingType = TypeUtils.getReferredType(type.getDescribingType());
        if (!(describingType.getTag() == TypeTags.RECORD_TYPE_TAG)) {
            ErrorUtils.createInvalidReturnTypeError();
        }
        StructureType structType = (StructureType) describingType;
        Map<String, Field> fields = structType.getFields();
        BString[] fieldNames = new BString[fields.size()];
        int i = 0;
        for (Map.Entry<String, Field> entry : fields.entrySet()) {
            fieldNames[i++] = StringUtils.fromString(entry.getKey());
        }
        return fieldNames;
    }

    public static boolean isFieldExist(BArray dataset, BString fieldName) {
        Type describingType = TypeUtils.getReferredType(dataset.getElementType());
        if (!(describingType.getTag() == TypeTags.RECORD_TYPE_TAG)) {
            ErrorUtils.createInvalidReturnTypeError();
        }
        StructureType structType = (StructureType) describingType;
        Map<String, Field> fields = structType.getFields();
        return fields.containsKey(fieldName.getValue());
    }

    public static Type getFieldType(BTypedesc type, BString fieldName) {
        Type describingType = TypeUtils.getReferredType(type.getDescribingType());
        if (!(describingType.getTag() == TypeTags.RECORD_TYPE_TAG)) {
            ErrorUtils.createInvalidReturnTypeError();
        }
        StructureType structType = (StructureType) describingType;
        Map<String, Field> fields = structType.getFields();
        return fields.get(fieldName.getValue()).getFieldType();
    }

    public static boolean isStringType(Type type) {
        if (type.getTag() == TypeTags.UNION_TAG) {
            List<Type> memberTypes = ((UnionType) type).getMemberTypes();
            for (Type memberType : memberTypes) {
                if (memberType.getTag() == TypeTags.STRING_TAG) {
                    return true;
                }
            }
            return false;
        }
        return type.getTag() == TypeTags.STRING_TAG;
    }

    public static boolean isNumericType(Type type) {
        if (type.getTag() == TypeTags.UNION_TAG) {
            List<Type> memberTypes = ((UnionType) type).getMemberTypes();
            for (Type memberType : memberTypes) {
                if (memberType.getTag() == TypeTags.INT_TAG || memberType.getTag() == TypeTags.FLOAT_TAG) {
                    return true;
                }
            }
            return false;
        }
        return type.getTag() == TypeTags.INT_TAG || type.getTag() == TypeTags.FLOAT_TAG;
    }

    public static BMap<BString, Object> getReturnTypeSchema(BTypedesc type) {
        BString[] fieldNames = getFields(type);
        BString[] fieldTypes = new BString[fieldNames.length];
        for (int i = 0; i < fieldNames.length; i++) {
            fieldTypes[i] = StringUtils.fromString(getFieldType(type, fieldNames[i]).toString());
        }
        BMap<BString, Object> returnTypeDetails = ValueCreator.createMapValue();
        for (int i = 0; i < fieldNames.length; i++) {
            returnTypeDetails.put(fieldNames[i], fieldTypes[i]);
        }
        return returnTypeDetails;
    }

    public static Object processResponseToBArray(Object clientResponse, BTypedesc returnType) {
        switch (TypeUtils.getType(clientResponse).getName()) {
            case CLIENT_CONNECTOR_ERROR:
                return ErrorUtils.createClientConnectionError();
            case IDLE_TIMEOUT_ERROR:
                return ErrorUtils.createIdleTimeoutError();
            case CLIENT_REQUEST_ERROR:
                return ErrorUtils.createClientRequestError();
            default:
                return convertJSONToBArray(clientResponse, returnType);
        }
    }
    
    public static void mergeNestedBArrays(BArray target, BArray source) {
        for (int i = 0; i < source.size(); i++) {
            BArray sourceCategory = (BArray) source.get(i);
            BArray targetCategory = (BArray) target.get(i);
            for (int j = 0; j < sourceCategory.size(); j++) {
                targetCategory.append(sourceCategory.get(j));
            }
        }
    }
    

    public static Object processResponseToNestedBArray(Object clientResponse, BTypedesc returnType) {
        switch (TypeUtils.getType(clientResponse).getName()) {
            case CLIENT_CONNECTOR_ERROR:
                return ErrorUtils.createClientConnectionError();
            case IDLE_TIMEOUT_ERROR:
                return ErrorUtils.createIdleTimeoutError();
            case CLIENT_REQUEST_ERROR:
                return ErrorUtils.createClientRequestError();
            default:
                return convertJSONToNestedBArray(clientResponse, returnType);
        }
    }

    public static Object processResponseToRecord(Object clientResponse, BTypedesc returnType) {
        switch (TypeUtils.getType(clientResponse).getName()) {
            case CLIENT_CONNECTOR_ERROR:
                return ErrorUtils.createClientConnectionError();
            case IDLE_TIMEOUT_ERROR:
                return ErrorUtils.createIdleTimeoutError();
            case CLIENT_REQUEST_ERROR:
                return ErrorUtils.createClientRequestError();
            default:
                return convertJSONToRecord(clientResponse, returnType);
        }
    }
}
