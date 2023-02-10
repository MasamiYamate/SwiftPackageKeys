# Extension file name
extensionName="SwiftPackageKeys+Extension.swift"

# Get Pass
packagePath=$1
pluginWorkDirPath=$2

derivedDataPath=`echo ${packagePath%/*/*/*}`
infoPlistPath="$derivedDataPath/info.plist"
appProjectPath=`/usr/libexec/PlistBuddy -c "print WorkspacePath" $infoPlistPath`
appDirPath=`echo ${appProjectPath%/*}`

dotEnvPath=${appDirPath}/.env

function generateEnvironmentProperty() {
    dotEnvLine=$1
    keyValue=(`echo ${dotEnvLine//=/ }`)
    key=${keyValue[1]}
    value=${keyValue[2]}
    
    response="
    public static var ${key}: String {
        return \"${value}\"
    }
    "
    echo $response
}

extensionCodeValue="public extension SwiftPackageKeys {
"

cat $dotEnvPath | while read line
do
property=`generateEnvironmentProperty $line`
extensionCodeValue=$extensionCodeValue$property
done

extensionCodeValue="${extensionCodeValue}
}"

echo $extensionCodeValue > "${pluginWorkDirPath}/${extensionName}"
