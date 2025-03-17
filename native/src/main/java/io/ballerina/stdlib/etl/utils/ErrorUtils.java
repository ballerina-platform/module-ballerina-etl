package io.ballerina.stdlib.etl.utils;

import io.ballerina.runtime.api.creators.ErrorCreator;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;

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

}
