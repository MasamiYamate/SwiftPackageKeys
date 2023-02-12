# SwiftPackageKeys

Framework for a simple Swift package manager that generates Swift native code from environment, application key-value files.

# Description

You can automatically generate a Swift class file that manages key-values ​​from the ".env" file located in the project root directory.
It is very easy to incorporate into the application because it is realized only with the plugin function of the Swift package manager.

Classes that manage auto-generated key values ​​are written out in Derived Data.
You can reduce the risk of accidentally including classes that manage sensitive information in your commits along with the code of your application under development.

# Installation

## Step1: Add Package

Use Swift Package Manager
File > Swift Packages > Add Package Dependency
Add https://github.com/MasamiYamate/SwiftPackageKeys
Select "Up to Next Major" with "0.0.1"

## Step2: Edit ".gitignore"

**Absolutely, please do it.**
Add ".env" to ".gitignore" to remove ".env" from git tracking files and prevent it from being committed to the repository.

```.gitignore
.env
```

### hint!

Since the env file is not included in the repository, it is necessary to consider how to share the env file.
It is recommended to encrypt the env file using opensssl etc. and pass the encrypted file to the app repository.
A common method is to share the password used for encryption within the team, decrypt the encrypted env file during development or on the CI environment, and use it.

## Step3: Create ".env" file

Create an .env file in the root directory of your project.

```sh
$ touch .env
```

## Step4: Edit ".env"

Add the API key you want to manage to the .env file in the form of Key-Value.

```
APIKEY_DEV=abcdefg123456
apiKeyProd=abcdefg654321
```

It doesn't matter if you write in snake case or camel case.
When converting to Swift native code, key names are automatically converted to snake case.
Also, do not enclose both Key and Value in double quotes.

## Step5: Embed in your app