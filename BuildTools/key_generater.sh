# File Paths
PACKAGE_PATH=$1
PLUGIN_WORK_DIR_PATH=$2

DERIVED_DATA_PATH=`echo ${PACKAGE_PATH%/*/*/*}`
INFO_PLIST_PATH=${DERIVED_DATA_PATH}/info.plist

APP_PROJECT_PATH=`/usr/libexec/PlistBuddy -c "print WorkspacePath" $INFO_PLIST_PATH`
APP_DIR_PATH=`echo ${APP_PROJECT_PATH%/*}`

DOT_ENV_PATH=${APP_DIR_PATH}/.env

# Extension file name
EXTENSION_NAME="SwiftPackageKeys+Extension.swift"
EXTENSION_FILE_PATH="${PLUGIN_WORK_DIR_PATH}/${EXTENSION_NAME}"

function generateEnvironmentProperty() {
    LINE_VALUE=$1
    DOT_ENV_ITEM=(`echo ${LINE_VALUE//=/ }`)
    RAW_KEY=${DOT_ENV_ITEM[0]}
    CAMEL_CASE_KEY=`echo $RAW_KEY | tr "[:upper:]" "[:lower:]" | awk -F '_' '{ printf $1; for(i=2; i<=NF; i++) {printf toupper(substr($i,1,1)) substr($i,2)}} END {print ""}'`
    VALUE=${DOT_ENV_ITEM[1]}
    RESPONSE="
    static var ${CAMEL_CASE_KEY}: String {
        return \"${VALUE}\"
    }
    "
    echo $RESPONSE
}

rm $EXTENSION_FILE_PATH

echo "public extension SwiftPackageKeys { " >> "${PLUGIN_WORK_DIR_PATH}/${EXTENSION_NAME}"


cat $DOT_ENV_PATH | while read line
do
PROPERTY=`generateEnvironmentProperty $line`
echo $PROPERTY >> "${PLUGIN_WORK_DIR_PATH}/${EXTENSION_NAME}"
done

echo "}" >> "${PLUGIN_WORK_DIR_PATH}/${EXTENSION_NAME}"
