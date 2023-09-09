# SwiftPackageKeys

Framework for a simple Swift package manager that generates Swift native code from environment, application key-value files.

# Description

You can automatically generate a Swift class file that manages key-values ​​from the ".env" or ".env.json" file located in the project root directory. This can be achieved using the plugin function of the Swift package manager, making it very easy to incorporate into the application.

The class that manages the auto-generated key values is written out in Derived Data. This reduces the risk of accidentally committing classes that manage sensitive information along with the code of the application under development.

# Installation

## Step1: Add Package

Use Swift Package Manager
File > Swift Packages > Add Package Dependency
Add https://github.com/MasamiYamate/SwiftPackageKeys
Select "Up to Next Major" with "1.0.0"

## Step2: Edit ".gitignore"

**Absolutely, please do it.**
To exclude the ".env" or ".env.json" files from being tracked by Git and prevent them from being committed to the repository, add " .env" and/or ".env.json" to the ".gitignore" file.

```.gitignore
.env
.env.json
```

### hint!

.env and .env.json files are not included in the repository, so it is necessary to consider how to share them.
It is recommended to encrypt the .env or .env.json files using tools such as OpenSSL and pass the encrypted file to the app repository.
A common method is to share the encryption password used within the team, decrypt the encrypted .env or .env.json file during development or on the CI environment, and use it.

## Step3: Create ".env"　".env.json" file

Create an .env or .env.json file in the root directory of your project.

```sh
$ touch .env
```

or

```sh
$ touch .env.json
```

## Step4: Edit ".env" ".env.json"

Add the API key you want to manage to the .env file in the form of Key-Value.

```
APIKEY_DEV=abcdefg123456
apiKeyProd=abcdefg654321
```

It doesn't matter if you write in snake case or camel case.
When converting to Swift native code, key names are automatically converted to snake case.
Also, do not enclose both Key and Value in double quotes.

If you use .env.json, include the following.

```json
{
    "keys": [
        {
            "key": "KEY_NAME",
            "productionValue": "production_key_value",
            "stagingValue": "staging_key_value",
            "debugValue": "debug_key_value"
        },
        {
            "key": "keyName2",
            "productionValue": "production_key_value2",
            "stagingValue": "staging_key_value2",
            "debugValue": "debug_key_value2"
        },
        {
            "key": "key_Name3",
            "productionValue": "production_key_value3",
            "stagingValue": "staging_key_value3",
            "debugValue": "debug_key_value3"
        }
    ]
}
```

When using .env.json, it is possible to define configuration values for a staging environment in addition to production and debug environments.

## Step5: Embed in your app

Build the app once before using Framework.
Xcode may display the alert in the image below.
In this case, select "Trust & Enable All".

<img width="296" alt="スクリーンショット 2023-02-13 0 43 47" src="https://user-images.githubusercontent.com/5555537/218321214-6bd49807-c35d-48f0-b4b4-125dca30423a.png">

If you want to use this framework in your app, you need to first import it in the class you want to use. Values obtained from .env or .env.json can be accessed by obtaining the structure of environment variables from the SwiftPackageKeys class, and then retrieving the values for specific keys and environments.

```swift
import Foundation
import SwiftPackageKeys // << import framework

final class KeyManager {
    
    // Structure for Configuration Values
    let keyObject = SwiftPackageKeys.keyName
    // Key
    var key: String {
        return keyObject.key
    }
    // value
    // - note: If only production environment values are set, those values will be used. 
    //   If both production and debug environment values are set, the appropriate environment variables will be used based on the app's Debug/Release flags.
    var value: String? {
        return keyObject.value
    }
    // production
    var productionValue: String? {
        return keyObject.fetchValue(stage: .production)
    }
    // staging
    var stagingValue: String? {
        return keyObject.fetchValue(stage: .staging)
    }
    // debug
    var debugValue: String? {
        return keyObject.fetchValue(stage: .debug)
    }
}
```

# About encryption of secret information

In this plugin, to make it harder to obtain confidential information through reverse engineering, obfuscation using reversible encryption is performed. After that, the plugin generates code to reference environment variables that can be handled in Swift.

We have adopted the XOR encryption for reversible encryption.
For the XOR encryption, we use a cryptographic key that is randomly generated for each build. Since we don't use a fixed-value cryptographic key, even if reverse engineering is performed from the IPA file, after obtaining the cryptographic key, there is a need to carry out analysis. This makes the analysis more difficult than when using a fixed-value cryptographic key for encryption and obfuscation.

However, since XOR encryption is reversible and the cryptographic key is also embedded in the binary, it is possible to obtain confidential information by analyzing it.
Please understand and use it with the knowledge that we are merely obfuscating confidential information to make it harder to obtain through reverse engineering.