#!/bin/bash
# Extension file name
EXTENSION_NAME="SwiftPackageKeys+Extension.swift"

# File Paths
PACKAGE_PATH=$1
PLUGIN_WORK_DIR_PATH=$2

generate_environment_property() {
    local LINE_VALUE
    local DOT_ENV_ITEM
    local KEY
    local VALUE
    local RESPONSE
    
    LINE_VALUE=$1
    DOT_ENV_ITEM=(`echo ${LINE_VALUE//=/ }`)
    KEY=${DOT_ENV_ITEM[1]}
    VALUE=${DOT_ENV_ITEM[2]}
    RESPONSE="
    public static var ${key}: String {
        return \"${value}\"
    }
    "
    echo $RESPONSE
}

generate_swift_package_keys_extension() {
    local DOT_ENV_PATH
    local extension_code_value
    local PROPERTY

    DOT_ENV_PATH=$1
    
    extension_code_value="public extension SwiftPackageKeys {
"
    cat $DOT_ENV_PATH | while read line
    do
        echo $line
        PROPERTY=`generate_environment_property $line`
        extension_code_value=$extension_code_value$PROPERTY
    done
        extension_code_value="${extension_code_value}
}"
    echo $extension_code_value > "${PLUGIN_WORK_DIR_PATH}/${EXTENSION_NAME}"
}

fetch_dot_env_path() {
    local DERIVED_DATA_PATH
    local INFO_PLIST_PATH
    local APP_PROJECT_PATHh
    local APP_DIR_PATH
    local DOT_ENV_PATH

    DERIVED_DATA_PATH=`echo ${PACKAGE_PATH%/*/*/*}`
    INFO_PLIST_PATH=${DERIVED_DATA_PATH}/info.plist

    APP_PROJECT_PATHh=`/usr/libexec/PlistBuddy -c "print WorkspacePath" $INFO_PLIST_PATH`
    APP_DIR_PATH=`echo ${APP_PROJECT_PATHh%/*}`

    DOT_ENV_PATH=${APP_DIR_PATH}/.env
    echo $DOT_ENV_PATH
}

DOT_ENV_PATH=`fetch_dot_env_path`
generate_swift_package_keys_extension $DOT_ENV_PATH
