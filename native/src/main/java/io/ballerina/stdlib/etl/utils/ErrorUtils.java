package io.ballerina.stdlib.etl.utils;

import io.ballerina.runtime.api.creators.ErrorCreator;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BString;

/**
 * Represents the errors of ETL module.
 */

public class ErrorUtils {

    private ErrorUtils() {
    }

    /**
     * Creates an error message.
     *
     * @param errorMsg the error message
     * @return an error which will be propagated to ballerina user
     */
    public static BError createError(String errorMsg) {
        return ErrorCreator.createError(StringUtils.fromString(errorMsg));
    }

    public static BError createFieldNotFoundError(BString fieldName) {
        return ErrorCreator.createError(StringUtils.fromString("The dataset does not contain the field - " + fieldName));
    }
}
