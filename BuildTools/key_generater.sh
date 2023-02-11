# Extension file name
EXTENSION_NAME="SwiftPackageKeys+Extension.swift"

# File Paths
PACKAGE_PATH=$1
PLUGIN_WORK_DIR_PATH=$2

DERIVED_DATA_PATH=`echo ${PACKAGE_PATH%/*/*/*}`
INFO_PLIST_PATH=${DERIVED_DATA_PATH}/info.plist

APP_PROJECT_PATH=`/usr/libexec/PlistBuddy -c "print WorkspacePath" $INFO_PLIST_PATH`
APP_DIR_PATH=`echo ${APP_PROJECT_PATH%/*}`

DOT_ENV_PATH=${APP_DIR_PATH}/.env

function generateEnvironmentProperty() {
    LINE_VALUE=$1
    DOT_ENV_ITEM=(`echo ${LINE_VALUE//=/ }`)
    RAW_KEY=${DOT_ENV_ITEM[0]}
    CAMEL_CASE_KEY=`echo $RAW_KEY | tr "[:upper:]" "[:lower:]" | awk -F '_' '{ printf $1; for(i=2; i<=NF; i++) {printf toupper(substr($i,1,1)) substr($i,2)}} END {print ""}'`
    VALUE=${DOT_ENV_ITEM[1]}
    RESPONSE="
    public static var ${CAMEL_CASE_KEY}: String {
        return \"${VALUE}\"
    }
    "
    echo $RESPONSE
}

extension_code_value="public extension SwiftPackageKeys {
"

cat $DOT_ENV_PATH | while read line
do
PROPERTY=`generateEnvironmentProperty $line`
extension_code_value=$extension_code_value$PROPERTY
done

extension_code_value="${extension_code_value}
}"

echo $extension_code_value > "${PLUGIN_WORK_DIR_PATH}/${EXTENSION_NAME}"
